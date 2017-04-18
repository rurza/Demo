//
//  NSString+HTTPMethod.h
//  ServerKit
//
//  Created by rurza on 17/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPMethod.h"

@interface NSString (HTTPMethod)

@property (nonatomic, readonly) HTTPMethod httpMethod;

+ (instancetype)stringWithHTTPMethod:(HTTPMethod)method;


@end
