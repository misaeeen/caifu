//
//  LZUserManger.m
//  MusicTest
//
//  Created by LZZ on 2020/12/3.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZUserManger.h"

static LZUserManger *instance = nil;

static NSString *const LZUserCahceName = @"LZUserCahceName";

@implementation LZUserManger

/// 静态方法
+ (LZUserManger *)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [LZUserManger new];
            [instance userInfo];
        }
    });
    return instance;
}

/// 用户是否登录
+ (BOOL)isLogon {
    return self.manager.isLogon;
}

// 获取用户是否登录
- (BOOL)isLogon {
    if (self.userModel) {
        return YES;
    }
    return NO;
}

/// 用户authorization
+ (NSString *)authorization {
    //因为登录的时候userModel没有初始化
    if ([self manager].userModel) {
        NSString *token = [self manager].userModel.token;
        return token.length == 0 ? @"" : token;
    }
     return @"";
}

#pragma mark - save

//  类方法设置，保存model
+ (BOOL)setWithSaveModel:(UserInfoModel *)userModel{
    [[self manager] setUserModel:userModel];

    return [[self manager] saveUserInfo];
}

/// 保存个人信息
- (BOOL)saveUserInfo {
    [[NSUserDefaults standardUserDefaults] setObject:[self.userModel yy_modelToJSONObject] forKey:LZUserCahceName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return NO;
}

/// 缓存中获取个人信息
- (void)userInfo{
    self.userModel = [UserInfoModel yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:LZUserCahceName]];
}

/// 清除用户信息
- (BOOL)cleanUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserCahceName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return NO;
}

// 退出,只清理token，不清理整个数据
- (void)logout {
    /// post 即将登出通知
    [self cleanUserInfo];
    self.userModel = nil;
}



#pragma mark - private methods

#pragma mark - singleton setting
// 限制当前对象创建多实例
+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

#pragma mark - Notification

#pragma mark - /// 发送用户登录通知
+ (void)postUserLoginNotification {
    /// post 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LZUserLoginNotification object:nil userInfo:nil];
}

#pragma mark - /// 发送用户正常登出通知
+ (void)logoutWithPostNotification {
    /// 正常登出
    [[self manager] logout];
    
    /// post 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LZUserLogoutNotification object:nil userInfo:nil];
}


@end


/// 用户登录通知
NSString *const LZUserLoginNotification = @"LZUserLoginNotification";

/// 用户正常登出通知
NSString *const LZUserLogoutNotification = @"LZUserLogoutNotification";
