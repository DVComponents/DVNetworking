//
//  DVAPIService.m
//  DVNetworking_Example
//
//  Created by David on 2018/12/1.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import "DVAPIService.h"

@interface DVAPIService()

@property(nonatomic,copy) NSString *urlString;
@property (nonatomic,strong) NSString *baseURL;
@property(nonatomic,copy) NSString *identifier;

@end

@implementation DVAPIService

- (instancetype)initWithMethondName:(NSString *)methodName identifier:(NSString *)identifier
{
    self = [super init];
    if (self){
        self.identifier = identifier;
        self.urlString = [self joinURLString:methodName];
    }
    return self;
}

- (NSString *)joinURLString:(nonnull NSString *)methodName
{
    NSAssert(methodName, @"methondName can't be nil");
    if (methodName == nil){
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@",self.baseURL,methodName];
}

- (DVServiceAPIEnvironment)apiEnvironment
{
    return DVServiceAPIEnvironmentDevelop;
}

#pragma mark getter
- (NSString *)baseURL
{
    NSString *result = @"";
    if ([result isEqualToString:@"OldBaseURL"]) result = @"v2/old";
    return result;
}

@end
