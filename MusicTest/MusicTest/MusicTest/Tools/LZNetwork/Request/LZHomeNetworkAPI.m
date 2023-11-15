//
//  LZHomeNetworkAPI.m
//  MusicTest
//
//  Created by LZZ on 2020/12/14.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZHomeNetworkAPI.h"

@implementation LZHomeNetworkAPI

+(void)bannerWithBlock:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"pageNum":@(1),
        @"pageSize":@(10),
    };
    [self GET:@"/1.0/article/banner/list" param:param block:block];
}

@end
