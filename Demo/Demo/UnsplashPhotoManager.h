//
//  UnsplashPhotoManager.h
//  ClientApp
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UnsplashPhoto;

@interface UnsplashPhotoManager : NSObject

@property (nonatomic) NSMutableArray *photos;

- (UnsplashPhoto *)photoWithDictionary:(NSDictionary *)dict;
- (void)addUniquePhotos:(NSArray *)photos;
- (NSArray *)arrayOfDictsWithPhotos;

@end
