//
//  AppDelegate.h
//  MusicTest
//
//  Created by LZZ on 2020/11/2.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

/**
 * 是否允许转向
 */
@property(nonatomic,assign)BOOL allowRotation;

@end

