//
//  DVLoginManager.m
//  AFNetworking
//
//  Created by David on 2018/12/3.
//

#import "DVLoginManager.h"
#import "NSError+DVValidator.h"
#import <AdSupport/AdSupport.h>

@implementation DVLoginManager

- (void)loginWithPhoneNum:(NSString *)phoneNum verCode:(NSString *)verCode countryCode:(NSString *)countryCode completionHandle:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))completionHandle
{
    NSParameterAssert(phoneNum);
    NSParameterAssert(verCode);
    NSParameterAssert(countryCode);
    
    if (!phoneNum || !verCode || !countryCode){
        NSError *error = [NSError errorWithCode:DVAPIManagerErrorTypeUnexpectedResponse errorMesesage:@"信息不完整"];
        completionHandle ? completionHandle(nil,error) : nil;
        return;
    }
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] ?: @"";
    NSDictionary *params = @{@"mobile":phoneNum,@"verifyCode":verCode,@"countryCode":countryCode,@"imei":idfa,@"deviceId":idfa};
    [self loadDataWithParams:params success:^(DVAPIManagerTask * _Nonnull task, id  _Nonnull responseObject) {
        completionHandle ? completionHandle(responseObject,nil) : nil;
    } failure:^(DVAPIManagerTask * _Nullable task, id  _Nullable responseObject, NSError * _Nonnull error) {
        completionHandle ? completionHandle(nil,error) : nil;
    }];
}

- (NSString *)methodName
{
    return @"v1/account/login/login";
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
