//
//  RegisterController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import "RegisterController.h"
#import "RegisterView.h"
@interface RegisterController ()
@property(nonatomic,strong)RegisterView * registerView;
@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self.view addSubview:self.registerView];
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.offset(0);
    }];
    
}

-(RegisterView *)registerView{
    if (!_registerView) {
        _registerView = [[RegisterView alloc]init];
    }
    
    return _registerView;
}

@end
