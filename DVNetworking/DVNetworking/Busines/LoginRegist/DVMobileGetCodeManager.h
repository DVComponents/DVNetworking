//
//  DVMobileGetCodeManager.h
//  AFNetworking
//
//  Created by David on 2018/12/3.
//

#import "DVAPIBaseManager.h"
#import "DVLoginRegistDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface DVMobileGetCodeManager : DVAPIBaseManager <DVAPIManager,DVAPIManagerValidator>

- (void)getPhoneCodeWithType:(SDLoginType)type
                phoneNum:(NSString *)phoneNumber
          countryCode:(NSString *)countryCode
     completionHandle:(void (^)(NSDictionary * _Nullable response,NSError * _Nullable error))completionHandle;

@end

NS_ASSUME_NONNULL_END
