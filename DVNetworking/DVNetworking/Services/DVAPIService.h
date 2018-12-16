//
//  DVAPIService.h
//  DVNetworking_Example
//
//  Created by David on 2018/12/1.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVAPIServiceDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface DVAPIService : NSObject <DVAPIService>

- (instancetype)initWithMethondName:(NSString *)methodName identifier:(NSString * _Nullable)identifier;

@property(nonatomic,readonly,copy)NSString *urlString;
@property (nonatomic, assign)DVServiceAPIEnvironment apiEnvironment;

@end

NS_ASSUME_NONNULL_END
