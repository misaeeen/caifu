//
//  LZHomeNetworkAPI.h
//  MusicTest
//
//  Created by LZZ on 2020/12/14.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZNetworkAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZHomeNetworkAPI : LZNetworkAPI

/// 获取首页banner
+ (void)bannerWithBlock:(LZNetworkBlock)block;

@end

NS_ASSUME_NONNULL_END
