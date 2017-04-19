//
//  Server.m
//  ServerKit
//
//  Created by rurza on 15/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "Server.h"
#import "GCDAsyncSocket.h"
#import "Request.h"
#import "RouteCollection.h"

static NSTimeInterval const kTimeOutInterval = 15.0f;


/**
 to hide implementation detail
 */
@interface Request ()
@property (nonatomic, weak)     GCDAsyncSocket  *socket;
@end


@interface Server () <GCDAsyncSocketDelegate>
@property (nonatomic) GCDAsyncSocket                            *listeningSocket;
@property (nonatomic) NSMutableArray<GCDAsyncSocket *>          *connectedSockets;
@property (nonatomic) RouteCollection                           *routes;
@property (nonatomic) dispatch_queue_t                          delegateQueue;
@property (nonatomic) BOOL                                      isRunning;

@end

@implementation Server

+ (instancetype)sharedServer
{
    static Server *server = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[Server alloc] init];
    });
    return server;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t queue = dispatch_queue_create("pl.micropixels.ServerKit.delegateQueue", NULL);
        self.listeningSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    }
    return self;
}

#pragma mark -Start/Stop
- (BOOL)startRunningOnPort:(uint16_t)port error:(NSError * __autoreleasing *)error
{
    if (self.isRunning) {
        return YES;
    }
    BOOL succes = [self.listeningSocket acceptOnPort:port error:error];
    self.isRunning = succes;
    return succes;
}

- (void)stop
{
    [self.listeningSocket disconnectAfterReadingAndWriting];
}

- (dispatch_queue_t)serverQueue
{
    return self.listeningSocket.delegateQueue;
}

- (void)route:(NSString *)endpoint forMethod:(HTTPMethod)method withHandler:(RouteHandler)handler
{
    Route *route = [Route routeWithEndPoint:endpoint method:method andHandler:handler];
    [self.routes addRoute:route];
}

- (void)get:(NSString *)endpoint withHandler:(RouteHandler)handler
{
    [self route:endpoint forMethod:HTTPMethodGet withHandler:handler];
}

- (void)post:(NSString *)endpoint withHandler:(RouteHandler)handler
{
    [self route:endpoint forMethod:HTTPMethodPost withHandler:handler];
}


#pragma mark - Private
#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    @synchronized (self.connectedSockets) {
        [self.connectedSockets addObject:newSocket];
    }
    [newSocket readDataWithTimeout:kTimeOutInterval tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    Request *request = [[Request alloc] initWithData:data];
    request.socket = sock;
    [self processRequest:request];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (sock != self.listeningSocket) {
        @synchronized (self.connectedSockets) {
            [self.connectedSockets removeObject:sock];
        }
    } else {
        self.isRunning = NO;
        if ([self.delegate respondsToSelector:@selector(serverDidStop:)]) {
            [self.delegate serverDidStop:self];
        }
    }
}

#pragma mark - Process Request
- (void)processRequest:(Request *)request
{
    Route *route = [self.routes routeForRequest:request];
    if (!route) {
        [request.socket writeData:Response.notFound.data withTimeout:kTimeOutInterval tag:0];
        return;
    }
    NSArray *variables = [route mapVariablesToRequest:request];
    
    if (route.handler) {
        Response *response = route.handler(variables, request);
        NSData *responseData = response.data;
        if (responseData) {
            [request.socket writeData:responseData withTimeout:kTimeOutInterval tag:0];
        } else {
            [request.socket writeData:Response.internalServerError.data withTimeout:kTimeOutInterval tag:0];
        }
    } else {
        [request.socket writeData:Response.ok.data withTimeout:kTimeOutInterval tag:0];
    }
}

- (Route *)routeForRequest:(Request *)request
{
    return [self.routes routeForRequest:request];
}

#pragma mark - Lazy
- (NSMutableArray<GCDAsyncSocket *> *)connectedSockets
{
    if (!_connectedSockets) {
        _connectedSockets = [[NSMutableArray alloc] init];
    }
    return _connectedSockets;
}

- (RouteCollection *)routes
{
    if (!_routes) {
        _routes = [[RouteCollection alloc] init];
    }
    return _routes;
}

@end
