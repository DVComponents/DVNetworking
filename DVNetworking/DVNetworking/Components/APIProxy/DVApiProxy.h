//
//  DVApiProxy.h
//  DVNetworking_Example
//
//  Created by David on 2018/11/30.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVNetworkingDefines.h"

@protocol AFMultipartFormData;

typedef void(^DVApiProxySuccessHandler)(id responseObject);
typedef void(^DVApiProxyErrorHandle)(NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface DVApiProxy : NSObject

+ (instancetype)shareInstance;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (NSNumber *)callPostWithParams:(NSDictionary *)params
                      methodName:(NSString *)methodName
               serviceIdentifier:(NSString *)serviceIdentifier
                         success:(DVApiProxySuccessHandler)success
                           error:(DVApiProxyErrorHandle)failure;
- (NSNumber *)callPostWithParams:(NSDictionary *)params
                      methodName:(NSString *)methodName
               serviceIdentifier:(NSString *)serviceIdentifier
                        formData:(void (^)(_Nullable id<AFMultipartFormData>))formData
                         success:(DVApiProxySuccessHandler)success
                           error:(DVApiProxyErrorHandle)failure;
- (NSNumber *)callGetWithParams:(NSDictionary *)params
                     methodName:(NSString *)methodName
              serviceIdentifier:(NSString *)serviceIdentifier
                        success:(DVApiProxySuccessHandler)success
                          error:(DVApiProxyErrorHandle)failure;

@end

NS_ASSUME_NONNULL_END
