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

@property (nonatomic, readonly) HTTPMethod      method;
@property (nonatomic, readonly) NSDictionary    *headers;
@property (nonatomic, readonly) NSData          *body;
@property (nonatomic, readonly) NSURL           *url;

- (instancetype)initWithData:(NSData *)data;

@end
