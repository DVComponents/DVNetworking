//
//  DVValidator.m
//  DVNetworking_Example
//
//  Created by David on 2018/12/1.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import "DVValidator.h"
#import "NSError+DVValidator.h"

@interface DVValidator()

@property (nonatomic,strong) NSError *error;
@property (nonatomic,strong) id content;
@property (nonatomic, assign) DVValidatorType status;

@end

@implementation DVValidator

- (instancetype)initWithContent:(id)data error:(NSError *)error;
{
    self = [super init];
    if (self){
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        self.content = response;
        self.status = [self responseStatusWithError:error];
        [self errorUpdate];
    }
    return self;
}

- (void)errorUpdate
{
    if (![self.content isKindOfClass:[NSDictionary class]])
    {
        self.error = [NSError errorWithCode:DVAPIManagerErrorTypeUnexpectedResponse errorMesesage:@"未知错误"];
        return;
    }
    id code = [self.content objectForKey:@"code"];
    if (code && [code respondsToSelector:@selector(integerValue)]){
        if ([code intValue] != 200){
            self.error = [NSError errorWithCode:DVAPIManagerErrorTypeUnexpectedResponse errorMesesage:@"未知错误"];
            return;
        }
    }
    id data = [self.content objectForKey:@"data"];
    if (![data isKindOfClass:[NSDictionary class]]){
         self.error = [NSError errorWithCode:DVAPIManagerErrorTypeUnexpectedResponse errorMesesage:@"未知错误"];
         return;
    }
}

- (DVValidatorType)responseStatusWithError:(NSError *)error
{
    if (error){
        DVValidatorType result = DVAPIManagerErrorTypeNoNetWork;
        
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = DVAPIManagerErrorTypeTimeout;
        }
        if (error.code == NSURLErrorCancelled) {
            result = DVAPIManagerErrorTypeCanceled;
        }
        if (error.code == NSURLErrorNotConnectedToInternet) {
            result = DVAPIManagerErrorTypeNoNetWork;
        }
        return result;
    }else{
        return DVAPIManagerErrorTypeSuccess;
    }
}


@end
