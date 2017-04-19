//
//  RouteTests.m
//  ServerKit
//
//  Created by rurza on 18/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ServerKit.h"
#import "RouteCollection.h"

@interface RouteTests : XCTestCase

@end

@implementation RouteTests

- (void)testRouteEquality
{
    Route *route1 = [Route routeWithEndPoint:@"/user/<name>/friends/<names>" method:HTTPMethodGet andHandler:nil];
    Route *route2 = [Route routeWithEndPoint:@"/user/<username>/friends/<usernames>" method:HTTPMethodGet andHandler:nil];
    XCTAssertEqualObjects(route1, route2);
}

- (void)testAddToRouteCollection
{
    Route *route1 = [Route routeWithEndPoint:@"/user/<name>/friends/<names>" method:HTTPMethodGet andHandler:nil];
    Route *route2 = [Route routeWithEndPoint:@"/user/<username>/friends/<usernames>" method:HTTPMethodGet andHandler:nil];
    RouteCollection *collection = [[RouteCollection alloc] init];
    [collection addRoute:route1];
    XCTAssertThrowsSpecific([collection addRoute:route2], NSException);
}

- (void)testRouteHandler
{
    Route *route1 = [Route routeWithEndPoint:@"/user/<name>/friends/<name>" method:HTTPMethodGet andHandler:^Response * _Nonnull(NSArray * _Nullable variables, Request * _Nonnull request) {
        
        return Response.ok;
    }];
    Response *response = route1.handler(nil, nil);
    XCTAssertNotNil(response);
}


@end
