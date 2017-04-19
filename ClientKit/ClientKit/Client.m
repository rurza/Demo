//
//  Client.m
//  ClientKit
//
//  Created by rurza on 19/04/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

#import "Client.h"
#import "BlockOperation.h"
#import "NSString+HTTPMethod.h"

@interface Client ()
@property (nonatomic) NSOperationQueue  *operationQueue;
@property (nonatomic) NSURLSession      *session;
@end

@implementation Client


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyAddOperationToQueue = YES;
    }
    return self;
}

- (NSOperation *)networkOperationWithHttpMethod:(HTTPMethod)httpMethod
                                            url:(NSURL *)url
                                        headers:(NSDictionary<NSString *, NSString *> *)requestParameters
                                           body:(NSString *)body
                           andCompletionHandler:(ClientGenericBlock)handler
{
    __weak typeof(self) weakSelf = self;
    BlockOperation *operation = [BlockOperation operatioWithBlock:^(BlockOperation *op) {
        [weakSelf _performApiCallForMethod:httpMethod url:url parameters:requestParameters body:body andCompletionHandler:^(NSError *error, id json) {
            if (handler) {
                [weakSelf _performBlockOnMainQueue:handler withError:error andResult:json];
            }
            op.operationDidFinish = YES;
        }];
    }];
    return [self _addOperationToQueueIfNeededOrReturnIt:operation];
}

- (void)cancelRequestWithURL:(NSURL *)url handler:(void (^)(BOOL taskRemoved))handler
{
    [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        [dataTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.originalRequest.URL isEqualTo:url]) {
                [obj cancel];
            }
        }];
    }];
}

#pragma mark - Private

- (NSOperation *)_addOperationToQueueIfNeededOrReturnIt:(NSOperation *)operation
{
    if (self.automaticallyAddOperationToQueue) {
        [self.operationQueue addOperation:operation];
    }
    return operation;
}

- (void)_performBlockOnMainQueue:(void (^)(NSError *blockError, id blockResult))block withError:(NSError *)error andResult:(id)result
{
    if (block) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error, result);
        });
    }
}


- (void)_performApiCallForMethod:(HTTPMethod)httpMethod
                             url:(NSURL *)url
                      parameters:(NSDictionary<NSString *, NSString *> *)requestParameters
                            body:(NSString *)body
            andCompletionHandler:(void (^)(NSError *error, id json))handler
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = url;
    request.timeoutInterval = self.requestTimeout;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.HTTPMethod = [NSString stringWithHTTPMethod:httpMethod];
    if (body) {
        request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (requestParameters) {
        request.allHTTPHeaderFields = requestParameters;
    }
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (handler) {
            if (data) {
                NSError *jsonParseError;
                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonParseError];
                if (!jsonParseError) {
                    handler(nil, json);
                    return;
                } else {
                    handler(jsonParseError, nil);
                    return;
                }
            } else {
                handler(error, nil);
            }
        }
    }];

    [task resume];
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [NSOperationQueue new];
        _operationQueue.maxConcurrentOperationCount = 3;
    }
    return _operationQueue;
}

- (NSUInteger)requestTimeout
{
    if (_requestTimeout == 0) {
        _requestTimeout = 10;
    }
    return _requestTimeout;
}

- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

@end
