//
//  LZUserManger.h
//  MusicTest
//
//  Created by LZZ on 2020/12/3.
//  Copyright © 2020 CF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserInfoModel.h"


@interface LZUserManger : NSObject

///静态管理器
@property (nonatomic, class, readonly)LZUserManger *manager;
/// 判断用户是否登录
@property (nonatomic, class, readonly) BOOL isLogon;
/// 用户个人信息数据模型
@property (nonatomic, strong) UserInfoModel *userModel;
///user authorization 如没有user信息返回空字符串
@property (nonatomic, class, readonly)NSString *authorization;


/// 保存用户信息
- (BOOL)saveUserInfo;

///  类方法设置，保存model，w覆盖user，然后保存本地
+ (BOOL)setWithSaveModel:(UserInfoModel *)userModel;

/// 清理user model
- (BOOL)cleanUserInfo;

/// 登出
- (void)logout;

/// 发送用户登录通知
+ (void)postUserLoginNotification;

/// 发送用户登出通知
+ (void)logoutWithPostNotification;

@end


/// 用户登录通知
UIKIT_EXTERN NSString *const LZUserLoginNotification;

/// 用户正常登出通知
UIKIT_EXTERN NSString *const LZUserLogoutNotification;
