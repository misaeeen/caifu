//
//  MyTestVideoDetailViewController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//
///我的考级
#import "MyTestVideoDetailViewController.h"
#import "MyTestVideoDetailView.h"
@interface MyTestVideoDetailViewController ()
@property(nonatomic,strong)MyTestVideoDetailView * detailView;
@end

@implementation MyTestVideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正式考级";
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
}

-(MyTestVideoDetailView *)detailView{
    if (!_detailView) {
        _detailView = [[MyTestVideoDetailView alloc]init];
    }
    return _detailView;
}
@end
