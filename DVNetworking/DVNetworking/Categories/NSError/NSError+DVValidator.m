//
//  NSError+DVValidator.m
//  DVNetworking_Example
//
//  Created by David on 2018/12/2.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import "NSError+DVValidator.h"

@implementation NSError (DVValidator)

+ (NSError *)errorWithCode:(DVValidatorType)validatorCode errorMesesage:(NSString *)errorMessage
{
    return [NSError errorWithDomain:errorMessage code:validatorCode userInfo:nil];
}


@end
