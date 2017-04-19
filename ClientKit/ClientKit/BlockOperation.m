//
//  BlockOperation.m
//  MUSICA
//
//  Created by rurza on 01/12/2016.
//  Copyright © 2016 Adam Różyński. All rights reserved.
//

#import "BlockOperation.h"

@interface BlockOperation ()
@property (nonatomic, copy) void (^block)(BlockOperation *operation);
@property (nonatomic)       BOOL isFinished;
@property (nonatomic)       BOOL isExecuting;

@end

@implementation BlockOperation

+ (instancetype)operatioWithBlock:(void (^)(BlockOperation *op))block
{
    BlockOperation *operation = [[BlockOperation alloc] init];
    operation.block = block;
    return operation;
}

- (void)start
{
    self.isExecuting = YES;
    if (self.block) {
        self.block(self);
    } else {
        self.operationDidFinish = YES;
    }
}

- (void)setOperationDidFinish:(BOOL)operationDidFinish
{
    _operationDidFinish = operationDidFinish;
    self.isExecuting = !operationDidFinish;
    self.isFinished = operationDidFinish;
}


- (void)setIsFinished:(BOOL)isFinished
{
    [self willChangeValueForKey:@"isFinished"];
    _isFinished = isFinished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setIsExecuting:(BOOL)isExecuting
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = isExecuting;
    [self didChangeValueForKey:@"isExecuting"];
}


@end
