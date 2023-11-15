//
//  BaseTabBarController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "UserCenterViewController.h"
@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setTranslucent:NO];
//    self.tabBar.tintColor = ColorWithHex(@"#333333");
    [self initSubVCs];
}


- (void)initSubVCs{
    
   HomeViewController  *homeVC = [[HomeViewController alloc]init];
//    homeVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *homeNav =[[UINavigationController alloc]initWithRootViewController:homeVC];
    homeNav.tabBarItem.title = @"首页";
    homeNav.tabBarItem.image = [[UIImage imageNamed:@"tab_icon_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_icon_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UserCenterViewController *userVC = [[UserCenterViewController alloc]init];
    UINavigationController *userNav =[[UINavigationController alloc]initWithRootViewController:userVC];
    userNav.tabBarItem.title = @"我的";
    userNav.tabBarItem.image = [[UIImage imageNamed:@"tab_icon_user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_icon_user_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[homeNav,userNav];
    
}

//- (BOOL) shouldAutorotate {
//    return YES;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [self.viewControllers.lastObject supportedInterfaceOrientations];
//}
//- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
//    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
//}

@end
