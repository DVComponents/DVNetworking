//
//  DVAPIBaseManager.m
//  DVNetworking_Example
//
//  Created by David on 2018/11/30.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import "DVAPIBaseManager.h"
#import "DVApiProxy.h"
#import "NSDictionary+DVNetworkingMethods.h"
#import "CTMediator+CTAppContext.h"
#import "DVValidator.h"
#import <AFNetworking/AFNetworking.h>

#pragma mark - DVAPIManagerTask

typedef void (^DVAPITaskCompletionHandler)(DVAPIManagerTask *task, id reponseObject, NSError *error);
typedef void(^DVAPITaskConstructingBody)(id<AFMultipartFormData>formData);

@interface DVAPIManagerTask : NSObject

@property (nonatomic, copy) NSString *serviceIdentifier;
@property (nonatomic, assign) DVAPIManagerRequestType requestType;
@property (nonatomic, copy) NSString *methodName;
@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic, copy) DVAPITaskCompletionHandler completionHandler;
@property (nonatomic, copy) DVAPITaskConstructingBody constructingBody;

@property (nonatomic,strong) NSNumber *requestId;
@property (nonatomic,strong) id responseObject;

@end

@implementation DVAPIManagerTask

- (instancetype)initWithParams:(NSDictionary *)params
                    methodName:(NSString *)methodName
                   requestType:(DVAPIManagerRequestType)requestType
             serviceIdentifier:(NSString *)serviceIdentifier
              completionHandle:(DVAPITaskCompletionHandler)completion
{
    self = [super init];
    if (self){
        self.params = params;
        self.methodName = methodName;
        self.requestType = requestType;
        self.serviceIdentifier = serviceIdentifier;
        self.completionHandler = completion;
    }
    return self;
}

- (instancetype)initWithParams:(NSDictionary *)params
                    methodName:(NSString *)methodName
                   requestType:(DVAPIManagerRequestType)requestType
             serviceIdentifier:(NSString *)serviceIdentifier
             constructingBody:(DVAPITaskConstructingBody)constructingBody
              completionHandle:(DVAPITaskCompletionHandler)completion

{
    self = [self initWithParams:params methodName:methodName requestType:requestType serviceIdentifier:serviceIdentifier completionHandle:completion];
    if (self){
        self.constructingBody = constructingBody;
    }
    return self;
}

- (instancetype)initWithResponseObject:(id)responseObject complitionHandle:(DVAPITaskCompletionHandler)completion
{
    self = [super init];
    if (self){
        self.responseObject = responseObject;
        self.completionHandler = completion;
    }
    return self;
}

- (void)stop
{
    [[DVApiProxy shareInstance] cancelRequestWithRequestID:self.requestId];
}

- (void)start
{
    if (self.responseObject){
        self.completionHandler ? self.completionHandler(self,self.responseObject,nil) : nil;
        return;
    }
    if (self.requestType == DVAPIManagerRequestTypePost){
        self.requestId = [[DVApiProxy shareInstance] callPostWithParams:self.params methodName:self.methodName serviceIdentifier:self.serviceIdentifier success:^(id responseObject) {
            self.completionHandler ? self.completionHandler(self,responseObject,nil):nil;
        } error:^(NSError *error) {
            self.completionHandler ? self.completionHandler(self,nil,error) :nil;
        }];
    }else if (self.requestType == DVAPIManagerRequestTypePostByForm){
        self.requestId = [[DVApiProxy shareInstance] callPostWithParams:self.params methodName:self.methodName serviceIdentifier:self.serviceIdentifier formData:self.constructingBody success:^(id responseObject) {
            self.completionHandler ? self.completionHandler(self,responseObject,nil):nil;
        } error:^(NSError *error) {
            self.completionHandler ? self.completionHandler(self,nil,error) :nil;
        }];
        
    }else if (self.requestType == DVAPIManagerRequestTypeGet) {
        self.requestId = [[DVApiProxy shareInstance]callGetWithParams:self.params methodName:self.methodName serviceIdentifier:self.serviceIdentifier success:^(id responseObject) {
            self.completionHandler ? self.completionHandler(self,responseObject,nil):nil;
        } error:^(NSError *error) {
            self.completionHandler ? self.completionHandler(self,nil,error) :nil;
        }];
        
    }else{
        NSAssert(NO, @"unsupport this type");
    }
}

@end

#pragma mark -----  DVAPIBaseManager

static dispatch_queue_t DV_manager_request_creation_queue() {
    static dispatch_queue_t DV_api_manager_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DV_api_manager_creation_queue = dispatch_queue_create("com.say.networking.manager.creation", DISPATCH_QUEUE_SERIAL);
    });
    
    return DV_api_manager_creation_queue;
}


@interface DVAPIBaseManager()

@property (nonatomic,strong) NSCache *cache; ///< 缓存列表
@property (nonatomic,strong) NSMutableArray *requestTaskList; ///< 任务队列

@end

@implementation DVAPIBaseManager

#pragma mark - life circle
- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(DVAPIManager)]){
            self.child = (NSObject<DVAPIManager> *)self;
        }
        if ([self conformsToProtocol:@protocol(DVAPIManagerValidator)]){
            self.validator = (id<DVAPIManagerValidator>)self;
        }
    }
    return self;
}

- (DVAPIManagerTask *)loadDataWithParams:(NSDictionary *)params success:(void (^)(DVAPIManagerTask * _Nonnull, id _Nonnull))success failure:(void (^)(DVAPIManagerTask * _Nullable, id _Nullable, NSError * _Nonnull))failure
{
    id result = [self.cache objectForKey:[self keyWithServiceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName requestParams:params]];
    if (self.child.shouldCache && result != nil){
        DVAPIManagerTask *requestTask = [[DVAPIManagerTask alloc]initWithResponseObject:result complitionHandle:^(DVAPIManagerTask *task, id reponseObject, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeTask:task];
                [self.cache setObject:result forKey:[self keyWithServiceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName requestParams:params]];
                success ? success(task,reponseObject) : nil;
            });
        }];
        [self addTask:requestTask];
        [requestTask start];
        return requestTask;
    }
    if (![self isReachable]){
        NSError *error = [NSError errorWithDomain:@"无网络连接" code:DVAPIManagerErrorTypeNoContent userInfo:nil];
        failure ? failure(nil, nil, error) : nil;
        
        return nil;
    }
    DVAPIManagerTask *requestTask = [[DVAPIManagerTask alloc]initWithParams:params methodName:self.child.methodName requestType:self.child.requestType serviceIdentifier:self.child.serviceIdentifier completionHandle:^(DVAPIManagerTask *task, id reponseObject, NSError *error) {
        
        [self removeTask:task];
        if (error && reponseObject == nil){
            failure ? failure(task,nil,error) : nil;
            return ;
        }
        DVValidator *response = [[DVValidator alloc]initWithContent:reponseObject error:error];
        if (response.error == nil && [self.validator respondsToSelector:@selector(manager:task:callbackData:)] && [self.validator manager:self task:task callbackData:reponseObject]){
            response = [self.validator manager:self task:task callbackData:reponseObject];
        }
        if (response.error == nil){
            
            success ? success(task,reponseObject) : nil;
        }else{
           failure ? failure(task,nil,response.error) : nil;
        }
    }];
    [self addTask:requestTask];
    [requestTask start];
    
    return requestTask;
}

- (void)resumeTask:(DVAPIManagerTask *)task
{
    [self addTask:task];
    [task start];
}

- (void)cancelTask:(DVAPIManagerTask *)task
{
    [self removeTask:task];
    [task stop];
}

- (void)cancelAllTasks
{
    for (DVAPIManagerTask *task in self.requestTaskList) {
        [task stop];
    }
    [self.requestTaskList removeAllObjects];
}

#pragma mark - private

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams
{
    NSString *key = [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams DV_transformToUrlParamString]];
    return key;
}

- (void)addTask:(nullable DVAPIManagerTask *)task
{
    if ([task isKindOfClass:[DVAPIManagerTask class]]){
        dispatch_sync(DV_manager_request_creation_queue(), ^{
           [self.requestTaskList addObject:task];
        });
    }
}

- (void)removeTask:(nullable DVAPIManagerTask *)task
{
    if ([self.requestTaskList containsObject:task]){
        dispatch_sync(DV_manager_request_creation_queue(), ^{
            [self.requestTaskList removeObject:task];
        });
    }
}

- (BOOL)isReachable
{
    return [[CTMediator sharedInstance] CTNetworking_isReachable];
}

#pragma mark - getter

- (NSCache *)cache
{
    if (_cache == nil){
        _cache = [[NSCache alloc]init];
    }
    return _cache;
}

- (NSMutableArray *)requestTaskList
{
    if (_requestTaskList == nil){
        _requestTaskList = @[].mutableCopy;
    }
    return _requestTaskList;
}


@end
