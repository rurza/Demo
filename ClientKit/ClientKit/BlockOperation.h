//
//  BlockOperation.h
//  MUSICA
//
//  Created by rurza on 01/12/2016.
//  Copyright © 2016 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockOperation : NSOperation
@property (nonatomic) BOOL operationDidFinish;

+ (instancetype)operatioWithBlock:(void (^)(BlockOperation *op))block;


@end
