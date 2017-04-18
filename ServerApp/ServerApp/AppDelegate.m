//
//  AppDelegate.m
//  ServerApp
//
//  Created by rurza on 15/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "AppDelegate.h"
@import ServerKit;

@interface AppDelegate ()
@property (nonatomic) Server *server;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.server = [Server sharedServer];
    [self.server get:@"/user/<name>/children" withHandler:^Response *(NSArray *variables, Request *request) {
        if ([variables.firstObject isKindOfClass:[NSString class]]) {
            NSLog(@"%@", variables.firstObject);
        }
        Response *resp = Response.ok;
        return resp;
    }];
    
    NSError *error;
    if (![self.server startRunningOnPort:5001 error:&error]) {
        NSLog(@"server error = %@", error);
    }
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
