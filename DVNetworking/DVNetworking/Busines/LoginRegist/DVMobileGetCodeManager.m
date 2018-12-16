//
//  DVMobileGetCodeManager.m
//  AFNetworking
//
//  Created by David on 2018/12/3.
//

#import "DVMobileGetCodeManager.h"

@implementation DVMobileGetCodeManager

- (void)getPhoneCodeWithType:(SDLoginType)type
                    phoneNum:(NSString *)phoneNumber
                 countryCode:(NSString *)countryCode
            completionHandle:(void (^)(NSDictionary * _Nullable response,NSError * _Nullable error))completionHandle
{
    NSParameterAssert(phoneNumber);
    NSParameterAssert(countryCode);
    NSParameterAssert(completionHandle);
    
    NSDictionary *params = @{@"mobile":phoneNumber,@"countryCode":countryCode,@"type":@(type),@"message_type":@"1"};
    [self loadDataWithParams:params success:^(DVAPIManagerTask * _Nonnull task, id  _Nonnull responseObject) {
        completionHandle(responseObject,nil);
    } failure:^(DVAPIManagerTask * _Nullable task, id  _Nullable responseObject, NSError * _Nonnull error) {
        completionHandle(nil,error);
    }];
}

- (NSString *)methodName
{
    return @"v1/common/verify/getPhoneCode";
}

- (NSString * _Nonnull)serviceIdentifier
{
    return @"";
}

- (DVAPIManagerRequestType)requestType
{
    return DVAPIManagerRequestTypePost;
}

@end
