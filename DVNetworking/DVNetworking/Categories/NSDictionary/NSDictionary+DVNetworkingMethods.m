//
//  NSDictionary+AXNetworkingMethods.m
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "NSDictionary+DVNetworkingMethods.h"

@implementation NSDictionary (DVNetworkingMethods)

- (NSString *)DV_transformToUrlParamString
{
    NSMutableString *paramString = [NSMutableString string];
    for (int i = 0; i < self.count; i ++) {
        NSString *string;
        if (i == 0) {
            string = [NSString stringWithFormat:@"?%@=%@", self.allKeys[i], self[self.allKeys[i]]];
        } else {
            string = [NSString stringWithFormat:@"&%@=%@", self.allKeys[i], self[self.allKeys[i]]];
        }
        [paramString appendString:string];
    }
    return paramString;
}

- (NSString *)DV_jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
