//
//  Request.h
//  ServerKit
//
//  Created by rurza on 15/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPMethod.h"

@interface Request : NSObject

/**
 http method request
 */
@property (nonatomic, readonly) HTTPMethod      method;

/**
 sent headers
 */
@property (nonatomic, readonly) NSDictionary    *headers;

/**
 http body data
 */
@property (nonatomic, readonly) NSData          *body;

/**
 request url - currently not supported
 */
@property (nonatomic, readonly) NSURL           *url;

/**
 returns new request object if data was valid http request

 @param data http request
 @return return nil if couldn't create request
 */
- (instancetype)initWithData:(NSData *)data;

- (instancetype)init NS_UNAVAILABLE;
@end
