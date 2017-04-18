//
//  RouteCollection.m
//  ServerKit
//
//  Created by rurza on 16/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "RouteCollection.h"
#import "Route.h"
#import "NSString+HTTPMethod.h"

@interface RouteCollection ()
@property (nonatomic) NSMutableDictionary *routes;
@end

@implementation RouteCollection {
    NSMutableOrderedSet *_unionSet;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.routes = [@{} mutableCopy];
        _unionSet = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (void)addRoute:(Route *)route
{
    NSString *methodKey = [NSString stringWithHTTPMethod:route.method];
    NSMutableSet *endpoints = [self.routes objectForKey:methodKey];
    if (endpoints) {
        if ([endpoints containsObject:route]) {
            [NSException raise:NSGenericException format:@"You're trying to add already existing route"];
        }
        [endpoints addObject:route];
    } else {
        NSMutableSet *newRoutes = [[NSMutableSet alloc] init];
        [newRoutes addObject:route];
        [self.routes setObject:newRoutes forKey:methodKey];
    }
    [_unionSet addObject:route];
}

#pragma mark - Helper methods
- (Route *)routeForRequest:(Request *)request
{
    __block Route *routeForRequest;
    [self enumerateUsingBlock:^(Route *route, BOOL *stop) {
        if ([route hasSamePathComponentsAsRequest:request]) {
            routeForRequest = route;
        }
    }];
    return routeForRequest;
}


- (Route *)routeForMethod:(HTTPMethod)method andEndpoint:(NSString *)endpoint
{
    NSString *methodKey = [NSString stringWithHTTPMethod:method];
    NSMutableSet *endpoints = [self.routes objectForKey:methodKey];
    if (endpoints) {
        Route *routeToFind = [Route routeWithEndPoint:endpoint method:method andHandler:nil];
        Route *route = [endpoints member:routeToFind];
        return route;
    }
    return nil;
}

#pragma mark - Enumerator
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return [_unionSet countByEnumeratingWithState:state objects:buffer count:len];
}

- (void)enumerateUsingBlock:(void (^)(Route *route, BOOL *stop))block
{
    BOOL stop = NO;
    for (Route *route in self) {
        if (block) {
            block(route, &stop);
        }
        if (stop) {
            break;
        }
    }
}

#pragma mark -
- (NSString *)description
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [self.routes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableSet * _Nonnull set, BOOL * _Nonnull stop) {
        [description appendFormat:@"%@: \n", key];
        for (Route *route in set) {
            [description appendFormat:@"%@ \n", route];
        }
    }];
    return description;
}

@end
