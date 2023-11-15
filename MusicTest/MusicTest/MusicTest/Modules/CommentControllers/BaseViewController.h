//
//  BaseViewController.h
//  MusicTest
//
//  Created by LZZ on 2020/11/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

/**
 用户正常登录
 */
- (void)_userLogin;

/**
 用户登录出
 */
- (void)_userLogout;

@end

NS_ASSUME_NONNULL_END
