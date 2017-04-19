//
//  UnsplashPhoto.h
//  ClientApp
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnsplashPhoto : NSObject

@property (nonatomic, copy) NSString    *id;
@property (nonatomic) NSDate            *date;
- (NSDictionary *)dictRepresentation;

@end
