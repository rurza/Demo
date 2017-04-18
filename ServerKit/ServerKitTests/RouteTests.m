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


@end
