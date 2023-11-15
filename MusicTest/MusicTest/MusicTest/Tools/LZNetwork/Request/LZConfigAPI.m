//
//  LZConfigAPI.m
//  MusicTest
//
//  Created by LZZ on 2021/7/3.
//  Copyright © 2021 CF. All rights reserved.
//

#import "LZConfigAPI.h"

@implementation LZConfigAPI

+ (void)loadConfigWithAppVersion:(NSString *)appVersion appType:(NSString *)appType block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"appVersion":appVersion,
        @"appType":appType
    };
    [self GET:@"/1.0/app/detail" param:param block:block];
}

@end
