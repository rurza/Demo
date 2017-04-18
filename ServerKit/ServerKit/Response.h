//
//  Response.h
//  ServerKit
//
//  Created by rurza on 16/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (nonatomic)                   NSDictionary<NSString *, NSString *>    *header;
@property (nonatomic)                   NSString                                *body;
@property (nonatomic, getter=isJson)    BOOL                                    json;
@property (nonatomic, readonly)         NSUInteger                              code;
@property (nonatomic, readonly)         NSData                                  *data;

@property (class, nonatomic, readonly)  Response                                *ok;
@property (class, nonatomic, readonly)  Response                                *notFound;
@property (class, nonatomic, readonly)  Response                                *internalServerError;


- (instancetype)initWithResponseCode:(NSUInteger)code;


@end
