//
//  UIDevice+CFDevice.h
//  MusicTest
//
//  Created by LZZ on 2020/11/8.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDevice (CFDevice)

/**
 * @interfaceOrientation 输入要强制转屏的方向
 */
+ (void)switchNewOrientation:(UIDeviceOrientation)orientation;


@end

