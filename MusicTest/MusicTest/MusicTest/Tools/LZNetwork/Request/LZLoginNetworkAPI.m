//
//  LZLoginNetworkAPI.m
//  MusicTest
//
//  Created by LZZ on 2020/12/3.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZLoginNetworkAPI.h"
#import "NSString+CLString.h"

@implementation LZLoginNetworkAPI

/// 登录
/// @param phone 手机号
/// @param smscode 验证码
/// @param block 回调
+ (void)loginWithPhone:(NSString *)phone smscode:(NSString *)smscode block:(LZNetworkBlock)block{
    NSString *path = @"/1.0/user/login";
    NSDictionary *param = @{
        @"username":CLNoNilString(phone),
        @"smscode":CLNoNilString(smscode)
    };
    [self POST:path param:param block:block];
}


/// 发送验证码
/// @param phone 手机号
/// @param block 回调
+ (void)sendCodeWithPhone:(NSString *)phone block:(LZNetworkBlock)block{
    NSString *path = @"/1.0/user/sms/send";
    NSDictionary *param = @{
        @"mobile":CLNoNilString(phone)
    };
    [self POST:path param:param block:block];
}

/// 退出登录
+ (void)logoutWithBlock:(LZNetworkBlock)block{
    NSString *path = @"/1.0/user/logout";
    [self POST:path param:nil block:block];
}


@end
