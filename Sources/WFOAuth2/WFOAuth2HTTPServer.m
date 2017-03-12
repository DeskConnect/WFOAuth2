//
//  WFOAuth2HTTPServer.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/8/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2HTTPServer.h>

#if !TARGET_OS_WATCH

#import <arpa/inet.h>
#import <CFNetwork/CFNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2HTTPServer ()

@property (nonatomic, readonly) dispatch_source_t server;

@end

@implementation WFOAuth2HTTPServer

- (nullable instancetype)init {
    self = [super init];
    if (!self)
        return nil;
    
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_len = sizeof(server_addr);
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(0);
    server_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    int sock;
    if ((sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == -1)
        return nil;
    
    if (bind(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1)
        return nil;
    
    if (listen(sock, 1) == -1)
        return nil;
    
    socklen_t length = sizeof(server_addr);
    if (getsockname(sock, (struct sockaddr *)&server_addr, &length) == -1)
        return nil;
    
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.deskconnect.WFOAuth2.callback_server", DISPATCH_QUEUE_SERIAL);
    });
    
    _server = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, sock, 0, queue);
    
    dispatch_source_set_event_handler(_server, ^{
        int client_sock;
        struct sockaddr_in client_addr;
        socklen_t size = sizeof(client_addr);
        if ((client_sock = accept(sock, (struct sockaddr *)&client_addr, &size)) == -1)
            return;
        
        __block CFHTTPMessageRef message = NULL;
        dispatch_io_t channel = dispatch_io_create(DISPATCH_IO_STREAM, client_sock, queue, ^(int __unused error) {
            if (message) {
                CFRelease(message);
                message = NULL;
            }
            close(client_sock);
        });
        dispatch_io_set_low_water(channel, 1);
        dispatch_io_read(channel, 0, SIZE_MAX, queue, ^(bool done, dispatch_data_t data, int __unused error) {
            if (done && data == dispatch_data_empty) {
                dispatch_io_close(channel, DISPATCH_IO_STOP);
                return;
            }
            
            if (data && dispatch_data_get_size(data) > 0) {
                if (!message) {
                    message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, true);
                }
                
                size_t length = 0;
                const void *bytes = NULL;
                dispatch_data_t mapped __attribute__((unused, objc_precise_lifetime)) = dispatch_data_create_map(data, &bytes, &length);
                if (!CFHTTPMessageAppendBytes(message, bytes, (CFIndex)length)) {
                    dispatch_io_close(channel, DISPATCH_IO_STOP);
                    return;
                }
            }
            
            if (message && CFHTTPMessageIsHeaderComplete(message)) {
                NSURL *requestURL = (__bridge_transfer id)CFHTTPMessageCopyRequestURL(message);
                if (message) {
                    CFRelease(message);
                    message = NULL;
                }
                
                NSLog(@"URL: %@", requestURL.absoluteURL);
                
                CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 302, NULL, kCFHTTPVersion1_0);
                CFHTTPMessageSetHeaderFieldValue(response, CFSTR("Location"), CFSTR("about:blank"));
                CFDataRef serialized = CFHTTPMessageCopySerializedMessage(response);
                dispatch_data_t data = dispatch_data_create(CFDataGetBytePtr(serialized), CFDataGetLength(serialized), queue, ^{
                    CFRelease(serialized);
                });
                CFRelease(response);
                
                dispatch_io_write(channel, 0, data, queue, ^(bool done, dispatch_data_t __unused data, int __unused error) {
                    if (done) {
                        dispatch_io_close(channel, DISPATCH_IO_STOP);
                    }
                });
            }
        });
    });
    dispatch_source_set_cancel_handler(_server, ^{
        close(sock);
    });
    dispatch_resume(_server);
    
    _redirectURI = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%hu", ntohs(server_addr.sin_port)]];
    
    return self;
}

- (void)dealloc {
    dispatch_source_cancel(_server);
}

@end

NS_ASSUME_NONNULL_END

#endif
