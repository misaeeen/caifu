//
//  LoginViewController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/2.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "LZLoginNetworkAPI.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欢迎登录";
    [self initSubview];
    
}
-(void)initSubview{
    
    LoginView * loginView = [[LoginView alloc]init];
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.offset(0);
    }];
    
    //登录操作
    [loginView.loginSubject subscribeNext:^(id  _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


@end
