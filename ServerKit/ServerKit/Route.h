//
//  Route.h
//  ServerKit
//
//  Created by rurza on 16/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "Response.h"

/**
 Handler called when server match request to defined route

 @param variables array of variable strings sent in url
 @param request http message request
 @return Response object that will be sent as a HTTP response
 */
typedef Response *_Nonnull(^RouteHandler)(NSArray * _Nullable variables, Request * _Nonnull request);

/**
 Describe endpoint served by server
 */
@interface Route : NSObject

/**
 whole endpoint string, i.e. /user/<variable>/friends
 */
@property (nonatomic, readonly) NSString        * _Nonnull endPoint;
/**
 array of variable parts of endpoint, i.e. /wather/<country>/<city> has 2 variables: <country> and <city>
 */
@property (nonatomic, readonly) NSArray         * _Nullable variables;

/**
 handler called when server match request to route
 */
@property (nonatomic, readonly) RouteHandler    _Nullable handler;

/**
 HTTP that matches route to request, i.e route GET /users and POST /users are different
 */
@property (nonatomic, readonly) HTTPMethod      method;

/**
 @param endpoint that will be matched with http request.
 @param method that will be matched with http request
 @param handler block that will be called when server will match http request
 @return new Route
 */
+ (instancetype _Nonnull)routeWithEndPoint:(NSString * _Nonnull)endpoint method:(HTTPMethod)method andHandler:(RouteHandler _Nullable)handler;

/**
 Matches request against route

 @param request url is used for matching route
 @return YES if request has the same endpoint and httpmethod as a request
 */
- (BOOL)hasSamePathComponentsAsRequest:(Request * _Nonnull)request;

/**
 @return array of passed variables to route by request
 */
- (NSArray * _Nullable)mapVariablesToRequest:(Request * _Nonnull)request;



@end
