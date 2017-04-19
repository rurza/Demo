//
//  Response.h
//  ServerKit
//
//  Created by rurza on 16/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Object wrapping HTTP response
 */
@interface Response : NSObject

/**
 header sent to client. Content-Length is set when - (NSData *)data is sent
 */
@property (nonatomic)                   NSDictionary<NSString *, NSString *>    *header;

/**
 http response body. It's encoded when - (NSData *)data is sent
 */
@property (nonatomic)                   NSString                                *body;

/**
 is response is in JSON format. Sets Content-Type to application/json is TRUE
 */
@property (nonatomic, getter=isJson)    BOOL                                    json;

/**
 http code
 */
@property (nonatomic, readonly)         NSUInteger                              code;

/**
 encoded response
 */
@property (nonatomic, readonly)         NSData                                  *data;

//*********************
// For convenience
//*********************
/**
 creates 200 OK response
 */
@property (class, nonatomic, readonly)  Response                                *ok;

/**
 creates 404 Not found response
 */
@property (class, nonatomic, readonly)  Response                                *notFound;

/**
 creates 500 Internal Server Error response
 */
@property (class, nonatomic, readonly)  Response                                *internalServerError;


/**
 designated initializer

 @param code http response
 */
- (instancetype)initWithResponseCode:(NSUInteger)code;
- (instancetype)init NS_UNAVAILABLE;

@end
