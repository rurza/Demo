//
//  HTTPMethod.h
//  ServerKit
//
//  Created by rurza on 16/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#ifndef HTTPMethod_h
#define HTTPMethod_h

static NSString *kHTTPMethodPost = @"POST";
static NSString *kHTTPMethodGet = @"GET";
static NSString *kHTTPMethodPut = @"PUT";

typedef NS_ENUM(NSInteger, HTTPMethod) {
    HTTPMethodUnknown,
    HTTPMethodGet = 1,
    HTTPMethodPost,
    HTTPMethodPut
};

#endif /* HTTPMethod_h */
