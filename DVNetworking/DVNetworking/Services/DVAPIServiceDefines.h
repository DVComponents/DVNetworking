//
//  DVService.h
//  DVNetworking
//
//  Created by David on 2018/12/1.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVNetworkingDefines.h"
#import <AFNetworking/AFNetworking.h>

@protocol DVAPIService <NSObject>

@property (nonatomic, assign)DVServiceAPIEnvironment apiEnvironment;

//- (NSURLRequest *)requestWithParams:(NSDictionary *)params
//                         methodName:(NSString *)methodName
//                        requestType:(DVAPIManagerRequestType)type;

@optional
- (AFHTTPSessionManager *)sessionManager;

@end


