//
//  RouteCollection.h
//  ServerKit
//
//  Created by rurza on 16/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPMethod.h"
@class Route;
@class Request;

@interface RouteCollection : NSObject <NSFastEnumeration>

- (void)addRoute:(Route *)route;
- (Route *)routeForMethod:(HTTPMethod)method andEndpoint:(NSString *)endpoint;
- (Route *)routeForRequest:(Request *)request;

//enumeration
- (void)enumerateUsingBlock:(void (^)(Route *route, BOOL *stop))block;

@end
