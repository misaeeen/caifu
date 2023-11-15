//
//  LZConfigAPI.h
//  MusicTest
//
//  Created by LZZ on 2021/7/3.
//  Copyright © 2021 CF. All rights reserved.
//

#import "LZNetworkAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZConfigAPI : LZNetworkAPI

/// APP配置接口
/// @param appVersion  当前版本号
/// @param appType app类型，1-ios， 2-android
/// @param block 回调
+ (void)loadConfigWithAppVersion:(NSString *)appVersion appType:(NSString *)appType block:(LZNetworkBlock)block;

@end

NS_ASSUME_NONNULL_END
