//
//  DVBindMobileManager.m
//  AFNetworking
//
//  Created by David on 2018/12/3.
//

#import "DVBindMobileManager.h"
#import "NSError+DVValidator.h"
@implementation DVBindMobileManager

- (void)bindMobile:(NSString *)phoneNumber
       countryCode:(NSString *)countryCode
  completionHandle:(void (^)(NSError * _Nullable))completionHandle
{
    NSParameterAssert(phoneNumber);
    NSParameterAssert(countryCode);
    
    if (!phoneNumber || !countryCode){
        NSError *error = [NSError errorWithCode:DVAPIManagerErrorTypeUnexpectedResponse errorMesesage:@"信息不完整"];
        completionHandle ? completionHandle(error) : nil;
        return;
    }
    NSDictionary *params = @{@"mobile":phoneNumber,@"countryCode":countryCode};
    [self loadDataWithParams:params success:^(DVAPIManagerTask * _Nonnull task, id  _Nonnull responseObject) {
        completionHandle ? completionHandle(nil) : nil;
    } failure:^(DVAPIManagerTask * _Nullable task, id  _Nullable responseObject, NSError * _Nonnull error) {
        completionHandle ? completionHandle(error) : nil;
    }];
}

- (NSString *)methodName
{
    return @"v1/account/profile/bindMobile";
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
