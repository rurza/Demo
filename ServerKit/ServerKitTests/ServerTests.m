//
//  ServerKitTests.m
//  ServerKitTests
//
//  Created by rurza on 15/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ServerKit.h"

@interface ServerTests : XCTestCase

@end

@implementation ServerTests

- (void)testServerSingleton
{
    Server *server = [Server sharedServer];
    Server *server1 = [Server sharedServer];
    XCTAssertEqual(server, server1);
}

- (void)testRunServer
{
    Server *server = [Server sharedServer];
    NSError *error;
    BOOL success = [server startRunningOnPort:5001 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(success);
}

- (void)testAddRoute
{
    Server *server = [Server sharedServer];
    XCTAssertThrowsSpecific([server route:@"" forMethod:HTTPMethodGet withHandler:nil], NSException);
    XCTAssertThrowsSpecific([server route:@"test" forMethod:HTTPMethodUnknown withHandler:nil], NSException);

    
}

- (void)testServerDispatchQueue
{
    Server *server = [Server sharedServer];
    dispatch_queue_t serverQueue = [server serverQueue];
    XCTAssertNotNil(serverQueue);
}

@end
