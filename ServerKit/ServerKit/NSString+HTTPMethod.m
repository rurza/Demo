//
//  NSString+HTTPMethod.m
//  ServerKit
//
//  Created by rurza on 17/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "NSString+HTTPMethod.h"

@implementation NSString (HTTPMethod)

+ (instancetype)stringWithHTTPMethod:(HTTPMethod)method
{
    switch (method) {
        case HTTPMethodGet:
            return kHTTPMethodGet;
        case HTTPMethodPost:
            return kHTTPMethodPost;
        case HTTPMethodPut:
            return kHTTPMethodPut;
        case HTTPMethodUnknown:
            return nil;
        default:
            return nil;
    }
}

- (HTTPMethod)httpMethod
{
    if ([self isEqualToString:kHTTPMethodGet]) {
        return HTTPMethodGet;
    }
    if ([self isEqualToString:kHTTPMethodPost]) {
        return HTTPMethodPost;
    }
    if ([self isEqualToString:kHTTPMethodPut]) {
        return HTTPMethodPut;
    }
    return HTTPMethodUnknown;
};


@end
