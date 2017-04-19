//
//  Request.m
//  ServerKit
//
//  Created by rurza on 15/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "Request.h"
#import "NSString+HTTPMethod.h"
#import "GCDAsyncSocket.h"

@interface Request ()
@property (nonatomic) NSDictionary          *headers;
@property (nonatomic) NSData                *body;
@property (nonatomic) NSURL                 *url;
@property (nonatomic) NSString              *methodString;
@property (nonatomic, weak) GCDAsyncSocket  *socket;
@end

@implementation Request

- (instancetype)initWithData:(NSData *)data 
{
    BOOL deserializedSuccessfully = NO;
    self = [super init];
    if (self) {
        deserializedSuccessfully = [self deserializeData:data];
    }
    return deserializedSuccessfully ? self:nil;
}

- (BOOL)deserializeData:(NSData *)data
{
    CFHTTPMessageRef request = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, TRUE);
    if (!CFHTTPMessageAppendBytes(request, data.bytes, data.length)) {
        return NO;
    }
    if (CFHTTPMessageIsHeaderComplete(request)) {
        self.headers = (__bridge NSDictionary *)CFHTTPMessageCopyAllHeaderFields(request);
        CFDataRef data = CFHTTPMessageCopyBody(request);
        self.body = (__bridge NSData *)data;
        self.url = (__bridge NSURL *)CFHTTPMessageCopyRequestURL(request);
        self.methodString = (__bridge NSString *)CFHTTPMessageCopyRequestMethod(request);
        CFRelease(request);
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Method: %@ for \nURL: %@, \nHeaders: %@, \nBody: %@ ", self.methodString, self.url, self.headers, self.body];
}

- (HTTPMethod)method
{
    return self.methodString.httpMethod;
}



@end
