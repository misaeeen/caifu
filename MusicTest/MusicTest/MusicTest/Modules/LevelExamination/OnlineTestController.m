//
//  OnlineTestController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import "OnlineTestController.h"
#import "OnlineTestCell.h"
#import "ChooseTestController.h"
#import "ChooseMusicalController.h"
#import "CFWebViewController.h"

@interface OnlineTestController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSArray *dataSource;

@end

@implementation OnlineTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线上考级";
    
    [self _setupSubviews];
}

- (void)_setupSubviews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.offset(0.0f);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"OnlineTestCell";
    OnlineTestCell *cell = (OnlineTestCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[OnlineTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell reloadWithModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        CFWebViewController *webV = [[CFWebViewController alloc] init];
        webV.url = BEFORE_EXAMINATION_URL;
        webV.titleStr = @"考前必读";
        webV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webV animated:YES];
    }else if (indexPath.row == 1){
        ChooseMusicalController *vc = [ChooseMusicalController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ChooseTestController *vc = [ChooseTestController new];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}


#pragma mark - getter and setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 118.0f;
        _tableView.rowHeight = 118.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if(@available(iOS 15.0,*)){
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[
                        @{@"image":[UIImage imageNamed:@"test_front_read"],@"title":@"考前必读"},
                        @{@"image":[UIImage imageNamed:@"test_front_simulation"],@"title":@"考前模拟"},
                        @{@"image":[UIImage imageNamed:@"formal_test"],@"title":@"正式考级"}
        ];
    }
    return _dataSource;
}


@end
