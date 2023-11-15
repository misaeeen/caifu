//
//  BaseViewController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import "BaseViewController.h"
#import "LZUserManger.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    
    /// 注册通知
    [self registerBaseNotifications];
}


- (void)registerBaseNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_userLogin)
                                 name:LZUserLoginNotification
                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_userLogout)
                                 name:LZUserLogoutNotification
                               object:nil];
}

- (void)_userLogin{
    
}

- (void)_userLogout{
    
}

@end
