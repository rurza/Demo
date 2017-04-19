//
//  UnsplashPhotoManager.m
//  ClientApp
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "UnsplashPhotoManager.h"
#import "UnsplashPhoto.h"

@interface UnsplashPhotoManager ()
@property (nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation UnsplashPhotoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!self.photos) {
            self.photos = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (UnsplashPhoto *)photoWithDictionary:(NSDictionary *)dict
{
    NSString *photoId = [dict objectForKey:@"id"];
    NSDate *date = [self.dateFormatter dateFromString:[dict objectForKey:@"created_at"]];
    if (photoId && date) {
        UnsplashPhoto *photo = [[UnsplashPhoto alloc] init];
        photo.id = photoId;
        photo.date = date;
        return photo;
    }
    return nil;
}

- (void)addUniquePhotos:(NSArray *)photos
{
    [photos enumerateObjectsUsingBlock:^(UnsplashPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.photos containsObject:obj]) {
            [self.photos addObject:obj];
        }
    }];
    [self.photos sortUsingComparator:^NSComparisonResult(UnsplashPhoto * _Nonnull obj1, UnsplashPhoto * _Nonnull obj2) {
        return [obj1.date compare:obj2.date];
    }];
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
    }
    return _dateFormatter;
}

- (NSArray *)arrayOfDictsWithPhotos
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (UnsplashPhoto *photo in self.photos) {
        [photos addObject:[photo dictRepresentation]];
    }
    return photos;
}

@end
