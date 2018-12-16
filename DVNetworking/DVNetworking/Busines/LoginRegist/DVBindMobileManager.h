//
//  DVBindMobileManager.h
//  AFNetworking
//
//  Created by David on 2018/12/3.
//

#import "DVAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DVBindMobileManager : DVAPIBaseManager <DVAPIManager,DVAPIManagerValidator>

- (void)bindMobile:(NSString *)phoneNumber
       countryCode:(NSString *)countryCode
  completionHandle:(void (^)(NSError * _Nullable error))completionHandle;

@end

NS_ASSUME_NONNULL_END
