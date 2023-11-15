//
//  AppDelegate.m
//  MusicTest
//
//  Created by LZZ on 2020/11/2.
//  Copyright © 2020 CF. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "LZConfigAPI.h"
#import <AliyunPlayer/AliPrivateService.h>
@interface AppDelegate ()

@property (nonatomic,assign) UIInterfaceOrientationMask mask;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kURL_BASE_FRONT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    UIViewController * rootVC = [[UIViewController alloc]init];
    [self.window setRootViewController:rootVC];
    [self.window makeKeyAndVisible];
    
    // app版本
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [LZConfigAPI loadConfigWithAppVersion:app_Version appType:@"1" block:^(LZNetworkResult *result, NSError *error) {
        if ([[result.data objectForKey:@"forceUpdate"] boolValue]) {
            CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"提示" message:@"当前版本过低，请前往应用市场下载并更新应用"];
            [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
                abort();
            }]];
            CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                NSString *url = @"https://itunes.apple.com/app/apple-store/id1549189816?mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                abort();
            }];
            action.bgColor = ColorWithHex(@"FFCF26");
            [alertV addAction:action];
            [alertV showAlertViewWithController:self.window.rootViewController];
        }else{
            NSString *base_url = [[result.data objectForKey:@"currentVersion"] objectForKey:@"apiAddress"];
            [[NSUserDefaults standardUserDefaults] setObject:base_url forKey:@"kURL_BASE_FRONT"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            BaseTabBarController * _rootVC = [[BaseTabBarController alloc]init];
            [self.window setRootViewController:_rootVC];
            [self.window makeKeyAndVisible];
        }
    }];
    
    NSString *encrptyFilePath = [[NSBundle mainBundle] pathForResource:@"encryptedApp" ofType:@"dat"];
    [AliPrivateService initKey:encrptyFilePath];

    [self setThemeStyle];

    return YES;
}

-(void)setThemeStyle{
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setTintColor:ColorWithHex(@"#333333")];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:ColorWithHex(@"#333333")];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:ColorWithHex(@"#333333")}
     ];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance setBackgroundColor:[UIColor whiteColor]];
        appearance.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f weight:UIFontWeightSemibold],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"333333"]};
        [[UINavigationBar appearance] setScrollEdgeAppearance: appearance];
        [[UINavigationBar appearance] setStandardAppearance:appearance];

    }
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    if (self.allowRotation) {//如果设置了allowRotation属性，支持全屏
            return UIInterfaceOrientationMaskAll;
        }
        return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
}

@end
