//
//  Client.h
//  ClientKit
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPMethod.h"

typedef void(^ClientGenericBlock)(NSError *error, id json);


@interface Client : NSObject

/**
 10s by default
 */
@property (nonatomic)               NSUInteger    requestTimeout;

/**
 YES by default
 */
@property (nonatomic)               BOOL          automaticallyAddOperationToQueue;


- (NSOperation *)networkOperationWithHttpMethod:(HTTPMethod)httpMethod
                                            url:(NSURL *)url
                                        headers:(NSDictionary<NSString *, NSString *> *)requestParameters
                                           body:(NSString *)body
                           andCompletionHandler:(ClientGenericBlock)handler;

- (void)cancelRequestWithURL:(NSURL *)url handler:(void (^)(BOOL taskRemoved))handler;

@end
