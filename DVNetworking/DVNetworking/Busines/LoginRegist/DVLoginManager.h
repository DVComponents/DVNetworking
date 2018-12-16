//
//  DVLoginManager.h
//  AFNetworking
//
//  Created by David on 2018/12/3.
//

#import "DVAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DVLoginManager : DVAPIBaseManager <DVAPIManager,DVAPIManagerValidator>

- (void)loginWithPhoneNum:(NSString *)phoneNum
                  verCode:(NSString *)verCode
              countryCode:(NSString *)countryCode
         completionHandle:(void (^)(NSDictionary * _Nullable response,NSError * _Nullable error))completionHandle;

@end

NS_ASSUME_NONNULL_END
