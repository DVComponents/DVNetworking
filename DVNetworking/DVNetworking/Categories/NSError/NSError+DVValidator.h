//
//  NSError+DVValidator.h
//  DVNetworking_Example
//
//  Created by David on 2018/12/2.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVNetworkingDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSError (DVValidator)

+ (NSError *)errorWithCode:(DVValidatorType)validatorCode errorMesesage:(NSString *)errorMessage;

@end

NS_ASSUME_NONNULL_END
