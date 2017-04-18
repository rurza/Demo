//
//  Response.m
//  ServerKit
//
//  Created by rurza on 16/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "Response.h"
#import "GCDAsyncSocket.h"

@interface Response ()
@property (nonatomic) NSUInteger code;
@end

@implementation Response {
    CFHTTPMessageRef _response;
}

- (instancetype)initWithResponseCode:(NSUInteger)code
{
    self = [super init];
    if (self) {
        self.code = code;
        _response = CFHTTPMessageCreateResponse(NULL, code, NULL, kCFHTTPVersion2_0);
    }
    return self;
}

#pragma mark - Getters
- (NSData *)data
{
    NSData *bodyData = [self.body dataUsingEncoding:NSUTF8StringEncoding];
    CFHTTPMessageSetBody(_response, (__bridge CFDataRef _Nonnull)(bodyData));
    CFHTTPMessageSetHeaderFieldValue(_response, CFSTR("Content-Length"), CFStringCreateWithFormat(NULL, NULL, CFSTR("%lu"), (unsigned long)[bodyData length]));
    return (__bridge NSData *)CFHTTPMessageCopySerializedMessage(_response);
}

#pragma mark - Setters
- (void)setHeader:(NSDictionary<NSString *,NSString *> *)header
{
    _header = header;
    for (NSString *key in header) {
        CFHTTPMessageSetHeaderFieldValue(_response, (__bridge CFStringRef)key, (__bridge CFStringRef)[header objectForKey:key]);
    }
}

- (void)setBody:(NSString *)body
{
    _body = body;
}

- (void)setJson:(BOOL)json
{
    _json = json;
    if (json) {
        CFHTTPMessageSetHeaderFieldValue(_response, CFSTR("Content-Type"), CFSTR("application/json"));
    } else {
        CFHTTPMessageSetHeaderFieldValue(_response, CFSTR("Content-Type"), NULL);
    }
}


#pragma mark - Convenience
+ (Response *)ok
{
    return [[Response alloc] initWithResponseCode:200];
}

+ (Response *)notFound
{
    return [[Response alloc] initWithResponseCode:404];
}

+ (Response *)internalServerError
{
    return [[Response alloc] initWithResponseCode:500];
}

#pragma mark - Lifecycle
- (void)dealloc
{
    CFRelease(_response);
}

@end
