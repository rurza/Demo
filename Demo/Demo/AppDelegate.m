//
//  AppDelegate.m
//  ClientApp
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "AppDelegate.h"
#import "UnsplashClient.h"
#import "UnsplashPhotoManager.h"
#import <ServerKit/ServerKit.h>

@interface AppDelegate ()
@property (nonatomic) UnsplashClient        *client;
@property (nonatomic) NSTimer               *timer;
@property (nonatomic) UnsplashPhotoManager  *manager;
@property (nonatomic) Server                *server;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    __weak typeof(self) weakSelf = self;

    self.client = [UnsplashClient sharedInstance];
    self.manager = [[UnsplashPhotoManager alloc] init];
    self.server = [Server sharedServer];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:60*10 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf getLatestPhotos];
    }];
    
    [self.server get:@"/photos" withHandler:^Response * _Nonnull(NSArray * _Nullable variables, Request * _Nonnull request) {
        if (weakSelf.manager.photos.count > 0) {
            Response *response = Response.ok;
            response.json = YES;
            NSError *jsonError;
            NSData *body = [NSJSONSerialization dataWithJSONObject:[weakSelf.manager arrayOfDictsWithPhotos] options:NSJSONWritingPrettyPrinted error:&jsonError];
            if (body && !jsonError) {
                response.body = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                return response;
            } else {
                return Response.internalServerError;
            }
        } else {
            return Response.notFound;
        }
    }];
    NSError *serverError;
    BOOL success = [self.server startRunningOnPort:5001 error:&serverError];
    if (!success || serverError) {
        NSLog(@"server error! %@", serverError);
    }
    
    [self getLatestPhotos];
}

- (void)getLatestPhotos
{
    [self.client getLatestPhotosWithCompletionHandler:^(NSError *error, id json) {
        if ([json isKindOfClass:[NSArray class]]) {
            NSMutableArray *photos = [[NSMutableArray alloc] init];
            for (id object in json) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    UnsplashPhoto *photo = [self.manager photoWithDictionary:object];
                    if (photos) {
                        [photos addObject:photo];
                    }
                }
            }
            [self.manager addUniquePhotos:photos];
            NSLog(@"new photos 🙈");
        }
    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
