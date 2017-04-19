//
//  UnsplashPhoto.m
//  ClientApp
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "UnsplashPhoto.h"

@interface UnsplashPhoto ()
@property (nonatomic) NSDateFormatter *dateFormatter;
@end


@implementation UnsplashPhoto

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    } else if ([object isKindOfClass:[UnsplashPhoto class]]) {
        if (self.hash == [object hash]) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)dictRepresentation
{
    return @{@"url":[NSString stringWithFormat:@"https://source.unsplash.com/%@", self.id], @"created_at":[self.dateFormatter stringFromDate:self.date]};
}

- (NSUInteger)hash
{
    return self.id.hash;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
    }
    return _dateFormatter;
}

@end
