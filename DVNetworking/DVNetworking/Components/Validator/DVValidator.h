//
//  DVValidator.h
//  DVNetworking_Example
//
//  Created by David on 2018/12/1.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//  异常收集类

#import <Foundation/Foundation.h>
#import "DVNetworkingDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface DVValidator : NSObject

@property (nonatomic,readonly,strong) NSError *error;
@property (nonatomic,readonly,strong) id content;
@property (nonatomic, assign, readonly) DVValidatorType status;

- (instancetype)initWithContent:(id)data error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
