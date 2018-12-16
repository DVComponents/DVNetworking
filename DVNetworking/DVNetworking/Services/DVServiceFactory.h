//
//  DVServiceFactory.h
//  DVNetworking_Example
//
//  Created by David on 2018/12/1.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//  抽象工厂

#import <Foundation/Foundation.h>
#import "DVAPIServiceDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface DVServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (id<DVAPIService>)serviceWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
