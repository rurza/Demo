//
//  UnsplashClient.h
//  ClientApp
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <ClientKit/ClientKit.h>


@interface UnsplashClient : Client
@property (nonatomic) NSURL *url;
@property (nonatomic) NSMutableDictionary *header;

+ (instancetype)sharedInstance;

- (void)getLatestPhotosWithCompletionHandler:(void (^)(NSError *error, id json))handler;

@end
