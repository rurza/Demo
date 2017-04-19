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
@class Server;

@protocol ServerDelegate <NSObject>
@optional
/**
 called when server did close all connections

 @param server that stopped
 */
- (void)serverDidStop:(Server *)server;
@end

@interface Server : NSObject

/**
 state of the server
 */
@property (nonatomic, readonly) BOOL                isRunning;

@property (nonatomic, weak)     id<ServerDelegate>  delegate;

/**

 @return Server singleton
 */
+ (instancetype)sharedServer;

/**

 @param port port on which server will be running
 @param error when something goes wrong.
 @return returns YES if server did start or if it was already running
 */
- (BOOL)startRunningOnPort:(uint16_t)port error:(NSError * __autoreleasing *)error;
/**
 stops server. This method stops server asynchronously. Implement ServerDelegate to receive message when server did stop
 */
- (void)stop;

/**
 creates route underyling object to dispatch requests sent to server

 @param endpoint endpoint, variables are supported and should be marked inside <>, ie /user/<username>
 @param method http method for which request should be dispatched
 @param handler block that will be called when server recognize request. This handler will be called on server queue
 */
- (void)route:(NSString *)endpoint forMethod:(HTTPMethod)method withHandler:(RouteHandler)handler;

/**
 creates route for http get method. Calls route:forMethod:withHandler internally
 */
- (void)get:(NSString *)endpoint withHandler:(RouteHandler)handler;

/**
 creates route for http post method. Calls route:forMethod:withHandler internally
 */
- (void)post:(NSString *)endpoint withHandler:(RouteHandler)handler;

/**
 queue on which server is running
 */
- (dispatch_queue_t)serverQueue;


@end
