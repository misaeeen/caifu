//
//  LZLoginNetworkAPI.h
//  MusicTest
//
//  Created by LZZ on 2020/12/3.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZNetworkAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZLoginNetworkAPI : LZNetworkAPI


/// 登录
/// @param phone 手机号
/// @param smscode 验证码
/// @param block 回调
+ (void)loginWithPhone:(NSString *)phone smscode:(NSString *)smscode block:(LZNetworkBlock)block;


/// 发送验证码
/// @param phone 手机号
/// @param block 回调
+ (void)sendCodeWithPhone:(NSString *)phone block:(LZNetworkBlock)block;

/// 退出登录
+ (void)logoutWithBlock:(LZNetworkBlock)block;


@end

NS_ASSUME_NONNULL_END
