//
//  UnsplashClient.m
//  ClientApp
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "UnsplashClient.h"


@implementation UnsplashClient

+ (instancetype)sharedInstance
{
    static UnsplashClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[UnsplashClient alloc] init];
    });
    return client;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.url = [NSURL URLWithString:@"https://api.unsplash.com/photos"];
        self.header = [[NSMutableDictionary alloc] initWithDictionary:@{@"Accept-Version":@"v1",
                                                                        @"Authorization":@"Client-ID 69c0228bf02e30f3c7751ba5711e3f970b54efddf70db8731b25a97c892bd501"}];
    }
    return self;
}

- (void)getLatestPhotosWithCompletionHandler:(void (^)(NSError *error, id json))handler
{
    
    [self networkOperationWithHttpMethod:HTTPMethodGet url:self.url headers:self.header body:nil andCompletionHandler:handler];
}

@end
