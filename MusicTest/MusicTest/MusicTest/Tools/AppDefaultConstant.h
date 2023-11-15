//
//  AppDefaultConstant.h
//  MusicTest
//
//  Created by LZZ on 2020/11/2.
//  Copyright © 2020 CF. All rights reserved.
//

#ifndef AppDefaultConstant_h
#define AppDefaultConstant_h


#define kWeakSelf __weak typeof(self) weakSelf = self;

// 状态栏高度
#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
// 安全高度
#define SafeHeight (StatusBarHeight > 20.0f ? 34.0f : 0.0f)
// 状态栏 + 导航栏
#define NavBarHeight (StatusBarHeight + 44)

//屏幕尺寸
#define SCREEN_WDITH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CONTROLLER_FRAME(size) (size*SCREEN_WDITH)/375

//颜色设置
#define ColorWithHex(str)  [UIColor colorWithHexString:str]
//默认色
#define AppDefaultThemeColor  [UIColor colorWithHexString:@"0893FF"]

// 字体
#pragma mark - font
#define FontWithSize(size)              [UIFont systemFontOfSize:size]
#define FontWith14px              [UIFont systemFontOfSize:CONTROLLER_FRAME(14)]

#define FontWithNameSize(name, size)    [UIFont fontWithName:name size:size]
#define ScoreFontWithSize(fontSize)     [UIFont fontWithName:@"Bradley Hand" size:fontSize]
#define BoldFontWithSize(size)          [UIFont boldSystemFontOfSize:size]
#define MediumFontWithSize(size)        [UIFont systemFontOfSize:size weight:UIFontWeightMedium]

#endif /* AppDefaultConstant_h */
