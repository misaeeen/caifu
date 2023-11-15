//
//  UIDevice+CFDevice.m
//  MusicTest
//
//  Created by LZZ on 2020/11/8.
//  Copyright © 2020 CF. All rights reserved.
//

#import "UIDevice+CFDevice.h"

@implementation UIDevice (CFDevice)

+ (void)switchNewOrientation:(UIDeviceOrientation)orientation{
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
@end
