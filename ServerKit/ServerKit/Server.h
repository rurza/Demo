//
//  Server.h
//  ServerKit
//
//  Created by rurza on 15/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPMethod.h"
#import "Route.h"

@interface Server : NSObject
@property (nonatomic, readonly) BOOL isRunning;

+ (instancetype)sharedServer;

- (BOOL)startRunningOnPort:(uint16_t)port error:(NSError * __autoreleasing *)error;
- (void)stop;

- (void)route:(NSString *)endpoint forMethod:(HTTPMethod)method withHandler:(RouteHandler)handler;
- (void)get:(NSString *)endpoint withHandler:(RouteHandler)handler;
- (void)post:(NSString *)endpoint withHandler:(RouteHandler)handler;

- (dispatch_queue_t)serverQueue;


@end
