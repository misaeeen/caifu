//
//  LZAuthorityManager.h
//  MusicTest
//
//  Created by LZZ on 2021/2/3.
//  Copyright © 2021 CF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZAuthorityManager : NSObject

//相机获取到权限处理事件
+ (void)cameraAuthority:(void (^)(void))handleBlock denied:(void (^)(void))deniedBlock;
//相册获取到权限处理事件
+ (void)albumAuthority:(void (^)(void))handleBlock denied:(void (^)(void))deniedBlock;
//麦克风获得权限处理事件
+ (void)microPhoneAuthority:(void (^)(void))handleBlock denied:(void (^)(void))deniedBlock;

@end

NS_ASSUME_NONNULL_END
