//
//  DVAPIBaseManager.h
//  DVNetworking_Example
//
//  Created by David on 2018/11/30.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVNetworkingDefines.h"
#import "DVValidator.h"
@class DVAPIManagerTask;
@class DVAPIBaseManager;

@protocol DVAPIManager <NSObject>

@required
- (NSString * _Nonnull)methodName;
- (NSString * _Nonnull)serviceIdentifier;
- (DVAPIManagerRequestType)requestType;

@optional
- (BOOL)shouldCache;

@end

@protocol DVAPIManagerValidator <NSObject>

@optional
- (DVValidatorType)validatorType;
- (DVValidator *)manager:(DVAPIBaseManager *)manager task:(DVAPIManagerTask *)task callbackData:(id)data;
@end



NS_ASSUME_NONNULL_BEGIN

@interface DVAPIBaseManager : NSObject

@property (nonatomic,weak) NSObject<DVAPIManager> *child;
@property (nonatomic,weak) id<DVAPIManagerValidator> validator;

- (DVAPIManagerTask *)loadDataWithParams:(NSDictionary *)params success:(void (^)(DVAPIManagerTask *task ,id responseObject))success  failure:(void (^)(DVAPIManagerTask * _Nullable task ,id _Nullable responseObject ,NSError *error))failure;

- (void)resumeTask:(DVAPIManagerTask *)task;
- (void)cancelTask:(DVAPIManagerTask *)task;
- (void)cancelAllTasks;

@end

NS_ASSUME_NONNULL_END
