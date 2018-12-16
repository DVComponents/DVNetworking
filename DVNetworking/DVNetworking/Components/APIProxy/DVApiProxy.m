//
//  DVApiProxy.m
//  DVNetworking_Example
//
//  Created by David on 2018/11/30.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import "DVApiProxy.h"
#import "DVAPIService.h"
#import <AFNetworking/AFNetworking.h>

@interface DVApiProxy()

@property (nonatomic, strong) NSMutableDictionary *taskTable;

@end

@implementation DVApiProxy

#pragma mark - life cycle
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static DVApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DVApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *operation = self.taskTable[requestID];
    [operation cancel];
    [self.taskTable removeObjectForKey:requestID];
}

- (NSNumber *)callPostWithParams:(NSDictionary *)params
                      methodName:(NSString *)methodName
               serviceIdentifier:(NSString *)serviceIdentifier
                         success:(DVApiProxySuccessHandler)success
                           error:(DVApiProxyErrorHandle)failure
{
    DVAPIService *service = [[DVAPIService alloc]initWithMethondName:methodName identifier:serviceIdentifier];
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask  = [[self sessionManagerWithService:service] POST:service.urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.taskTable removeObjectForKey:requestID];
        success ? success(responseObject) :nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.taskTable removeObjectForKey:requestID];
         failure ? failure(error) : nil;
    }];
    NSNumber *requestID = @(dataTask.taskIdentifier);
    self.taskTable[requestID] = dataTask;
    [dataTask resume];
    return requestID;
}

- (NSNumber *)callPostWithParams:(NSDictionary *)params
                      methodName:(NSString *)methodName
               serviceIdentifier:(NSString *)serviceIdentifier
                        formData:(void (^)(id<AFMultipartFormData> _Nullable))formData
                         success:(DVApiProxySuccessHandler)success
                           error:(DVApiProxyErrorHandle)failure
{
    DVAPIService *service = [[DVAPIService alloc]initWithMethondName:methodName identifier:serviceIdentifier];
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [[self sessionManagerWithService:service] POST:service.urlString parameters:params constructingBodyWithBlock:formData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.taskTable removeObjectForKey:requestID];
        success ? success(responseObject) :nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.taskTable removeObjectForKey:requestID];
        failure ? failure(error) : nil;
    }];
    
    NSNumber *requestID = @(dataTask.taskIdentifier);
    self.taskTable[requestID] = dataTask;
    [dataTask resume];
    return requestID;
}

- (NSNumber *)callGetWithParams:(NSDictionary *)params
                     methodName:(NSString *)methodName
              serviceIdentifier:(NSString *)serviceIdentifier
                        success:(DVApiProxySuccessHandler)success
                          error:(DVApiProxyErrorHandle)failure
{
     DVAPIService *service = [[DVAPIService alloc]initWithMethondName:methodName identifier:serviceIdentifier];
    __block NSURLSessionDataTask *dataTask = [[self sessionManagerWithService:service] GET:service.urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.taskTable removeObjectForKey:requestID];
        success ? success(responseObject) :nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.taskTable removeObjectForKey:requestID];
        failure ? failure(error) : nil;
    }];
    [dataTask resume];
    NSNumber *taskIdentifier = @(dataTask.taskIdentifier);
    self.taskTable[taskIdentifier] = dataTask;
    return taskIdentifier;
}

- (AFHTTPSessionManager *)sessionManagerWithService:(id<DVAPIService>)service
{
    AFHTTPSessionManager *sessionManager = nil;
    if ([service respondsToSelector:@selector(sessionManager)]){
        sessionManager = service.sessionManager;
    }
    if (sessionManager == nil){
        sessionManager = [AFHTTPSessionManager manager];
    }
   AFHTTPRequestSerializer * httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    [httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    sessionManager.requestSerializer = httpRequestSerializer;
    return sessionManager;
}

#pragma mark - getter

- (NSMutableDictionary *)taskTable
{
    if (_taskTable == nil) {
        _taskTable = [[NSMutableDictionary alloc] init];
    }
    return _taskTable;
}

@end
