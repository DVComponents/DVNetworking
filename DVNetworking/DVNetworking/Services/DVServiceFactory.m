//
//  DVServiceFactory.m
//  DVNetworking_Example
//
//  Created by David on 2018/12/1.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#import "DVServiceFactory.h"
#import "CTMediator.h"

@interface DVServiceFactory()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation DVServiceFactory

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static DVServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DVServiceFactory alloc] init];
    });
    return sharedInstance;
}

- (id<DVAPIService>)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil){
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private

- (id <DVAPIService>)newServiceWithIdentifier:(NSString *)identifier
{
    return [[CTMediator sharedInstance] performTarget:identifier action:identifier params:nil shouldCacheTarget:NO];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}
@end
