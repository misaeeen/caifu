//
//  TestResultViewController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//
// 成绩查询
#import "TestResultViewController.h"
#import "TestResultView.h"
@interface TestResultViewController ()
@property(nonatomic,strong)TestResultView * testView;
@end

@implementation TestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.testView];
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}

-(TestResultView *)testView{
    if (!_testView) {
        _testView = [[TestResultView alloc]init];
    }
    return _testView;
}


@end
