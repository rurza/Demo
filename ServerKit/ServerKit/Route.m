//
//  Route.m
//  ServerKit
//
//  Created by rurza on 16/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "Route.h"
#import "NSString+HTTPMethod.h"

@interface Route ()
@property (nonatomic, copy) NSString        *endPoint;
@property (nonatomic, copy) NSArray         *variables;
@property (nonatomic, copy) RouteHandler    handler;
@property (nonatomic)       HTTPMethod      method;
@property (nonatomic)       NSString        *uniformedEndpoint;

@end

@implementation Route

+ (instancetype)routeWithEndPoint:(NSString *)endpoint method:(HTTPMethod)method andHandler:(RouteHandler)handler
{
    if (!endpoint || endpoint.length == 0) {
        [NSException raise:NSInvalidArgumentException format:@"Endpoint can't be nil or empty string."];
    }
    if (method == HTTPMethodUnknown) {
        [NSException raise:NSInvalidArgumentException format:@"HTTP method can't be HTTPMethodUnknown"];
    }
    Route *route = [[Route alloc] initWithEndPoint:endpoint method:method andHandler:handler];
    return route;
}

- (instancetype)initWithEndPoint:(NSString *)endpoint method:(HTTPMethod)method andHandler:(RouteHandler)handler
{
    self = [super init];
    if (self) {
        self.endPoint = endpoint;
        self.handler = handler;
        self.method = method;
        [self parseVariables];
    }
    return self;
}

- (void)parseVariables
{
    NSError *regexError;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<[^<]*>" options:NSRegularExpressionCaseInsensitive error:&regexError];
    NSMutableArray *variables = [[NSMutableArray alloc] init];
    [regex enumerateMatchesInString:self.endPoint
                            options:0 range:NSMakeRange(0, self.endPoint.length)
                         usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop)
    {
        NSString *variable = [self.endPoint substringWithRange:result.range];
        if (variables) {
            [variables addObject:variable];
        }
    }];
    self.variables = variables;
}

#pragma mark - Map to Request
- (BOOL)hasSamePathComponentsAsRequest:(Request *)request
{
    __block BOOL hasSamePathComponents = YES;
    NSArray *requestPathComponent = [request.url.path componentsSeparatedByString:@"/"];
    NSArray *routePathComponents = [self.endPoint componentsSeparatedByString:@"/"];
    if (requestPathComponent.count == routePathComponents.count) {
        [requestPathComponent enumerateObjectsUsingBlock:^(NSString * _Nonnull requestPathComponent, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *routePathComponent = [routePathComponents objectAtIndex:idx];
            if (![routePathComponent hasPrefix:@"<"] && ![routePathComponent hasSuffix:@">"]) {
                if ([requestPathComponent localizedCaseInsensitiveCompare:routePathComponent] != NSOrderedSame) {
                    hasSamePathComponents = NO;
                    *stop = YES;
                }
            }
        }];
    } else {
        hasSamePathComponents = NO;
    }

    return hasSamePathComponents;
}

- (NSArray *)mapVariablesToRequest:(Request *)request
{
    NSMutableArray *variables;
    if (self.variables) {
        NSArray *requestPathComponents = [request.url.path componentsSeparatedByString:@"/"];
        NSArray *routePathComponents = [self.endPoint componentsSeparatedByString:@"/"];
        
        if (requestPathComponents.count == routePathComponents.count) {
            variables = [[NSMutableArray alloc] init];
            
            [routePathComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull routePathComponent, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([routePathComponent hasPrefix:@"<"] && [routePathComponent hasSuffix:@">"]) {
                    NSString *requestVar = [requestPathComponents objectAtIndex:idx];
                    [variables addObject:requestVar];
                }
            }];
        }

    }
    return variables;
}

#pragma mark - Equality
- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if ([other isKindOfClass:[Route class]]) {
        if (self.hash == [other hash]) {
            return YES;
        }
    }
    return NO;
}


- (NSUInteger)hash
{
    return [[NSString stringWithFormat:@"%@%@", [NSString stringWithHTTPMethod:self.method], self.uniformedEndpoint] hash];
}

#pragma mark - Setters
- (void)setEndPoint:(NSString *)endPoint
{
    _endPoint = endPoint;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<[^<]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *uniformedEndpoint = [regex stringByReplacingMatchesInString:endPoint options:0 range:NSMakeRange(0, endPoint.length) withTemplate:@"#<.🙈🙉🙊.>#"];
    self.uniformedEndpoint = uniformedEndpoint;
}

#pragma mark - Description
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", [NSString stringWithHTTPMethod:self.method], self.endPoint];
}

@end
