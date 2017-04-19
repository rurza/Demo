//
//  RequestTests.m
//  ServerKit
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ServerKit.h"

@interface RequestTests : XCTestCase

@end

@implementation RequestTests

- (void)testRequestInitializationWithEmptyData
{
    Request *req = [[Request alloc] initWithData:[NSData data]];
    XCTAssertNil(req);
}


@end
