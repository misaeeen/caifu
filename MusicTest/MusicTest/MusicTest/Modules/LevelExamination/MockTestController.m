//
//  MockTestController.m
//  MusicTest
//
//  Created by LZZ on 2020/12/14.
//  Copyright © 2020 CF. All rights reserved.
//

#import "MockTestController.h"
#import "LZTestDetailsModel.h"
#import "OnlineTestConfigCell.h"
#import "CFWebViewController.h"

@interface MockTestController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * submitButton;

@property (nonatomic, strong)NSMutableArray *dataSource;


@end

@implementation MockTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模拟信息";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        make.height.mas_equalTo(36);
        make.bottom.offset(-55);
    }];
    
    [self bindDataSource];
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"OnlineTestConfigCell";
    OnlineTestConfigCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[OnlineTestConfigCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell reloadWithData:self.dataSource[indexPath.row]];
    
    return cell;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self createHeaderView];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        if(@available(iOS 15.0,*)){
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    
    return _tableView;
}

-(UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"确认无误，开始考级" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = FontWith14px;
        [_submitButton setBackgroundColor: ColorWithHex(@"#fdcf2c")];
        _submitButton.layer.cornerRadius = 2.5f;
        [_submitButton setTitleColor:ColorWithHex(@"#343434") forState:UIControlStateNormal];
        [[_submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            CFWebViewController *webV = [[CFWebViewController alloc] init];
            webV.model = self.model;
            webV.titleStr = @"考前必读";
            [self.navigationController pushViewController:webV animated:YES];
            
        }];
        _submitButton.layer.masksToBounds = YES;
        
    }
    
    return _submitButton;
}


-(UIView *)createHeaderView{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 104)];
    UILabel * nameL = [UILabel createWithColor:ColorWithHex(@"#333333") font:FontWithSize(13)];
    nameL.frame = CGRectMake(24 + 80, 28, SCREEN_WDITH - 36 - 80, 14);
    nameL.text = self.model.profile.name;
    [headView addSubview:nameL];
    
    UILabel *detailsL = [UILabel createWithColor:ColorWithHex(@"#FF3B30") font:FontWithSize(12)];
    detailsL.frame = CGRectMake(24 + 80, 28 + 14 + 12, SCREEN_WDITH - 36 - 80, 13);
    detailsL.text = @"模拟考生，不会消耗考级次数";
    [headView addSubview:detailsL];
    
    UIImageView *headImageV = [[UIImageView alloc]init];
    headImageV.frame = CGRectMake(16, 12, 80, 80);
//    headImageV.layer.cornerRadius = 10.0f;
//    headImageV.layer.masksToBounds = YES;
    headImageV.image = [UIImage imageNamed:@"defute_header"];
//    headImageV.backgroundColor = ColorWithHex(@"#999999");
    [headView addSubview:headImageV];
    return headView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



- (void)bindDataSource{
    NSArray *titles = @[
        @"考生姓名：",@"考级教材：",@"考级科目：",@"考级等级：",@"考级曲目：",@"",@"",@"考级时间：",@"剩余考试次数："
    ];
    NSString *examTime = [NSString getCurrentTimeString];
    self.model.examTime = examTime;
    NSArray *contents = @[
        CLNoNilString(self.model.profile.name),
        CLNoNilString(self.model.book),
        CLNoNilString(self.model.subject),
        CLNoNilString(self.model.level),
        CLNoNilString(@"模拟曲目一"),
        CLNoNilString(@"模拟曲目二"),
        CLNoNilString(@"模拟曲目三"),
        CLNoNilString(examTime),
        @"10000"
    ];
    
    for (NSInteger i = 0; i < titles.count; i ++) {
        [self.dataSource addObject:@{
                    @"title":titles[i],
                    @"content":contents[i]
        }];
    }
}

@end
