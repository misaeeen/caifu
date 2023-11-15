//
//  ChooseTestView.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//

#import "ChooseTestView.h"
#import "ChooseTestCell.h"
#import "LZTestNetworkAPI.h"
#import "LZTestModel.h"

@interface ChooseTestView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic, strong) NSMutableArray <LZTestModel *>*dataSource;

@end
@implementation ChooseTestView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.offset(0);
        }];
        
        self.page = 1;
        [self loadEnrollList:kRefreshNormal];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testFinishNotification) name:@"TestFinishNotification" object:nil];
        
    }
    
    return self;
}

- (void)testFinishNotification{
    self.page = 1;
    [self loadEnrollList:kRefreshNormal];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"ChooseTestCell";
    ChooseTestCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ChooseTestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell reloadWithModel:self.dataSource[indexPath.row]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.chooseTestViewDidSelect sendNext:self.dataSource[indexPath.row]];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if(@available(iOS 15.0,*)){
            _tableView.sectionHeaderTopPadding = 0;
        }
        @weakify(self);
        [_tableView setRefreshHeaderWithBlock:^{
            @strongify(self)if(!self)return;
            self.page = 1;
            [self loadEnrollList:kRefreshHeader];
        }];
    }
    
    return _tableView;
}

- (NSMutableArray<LZTestModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

/// 设置foote
- (void)setTableViewFooter:(BOOL)hide {
    @weakify(self);
    [self.tableView setRefreshFooter:hide withBlock:^{
        @strongify(self)if(!self)return;
        self.page ++;
        [self loadEnrollList:kRefreshFooter];
    }];
}


-(RACSubject *)chooseTestViewDidSelect{
    if (!_chooseTestViewDidSelect) {
        _chooseTestViewDidSelect = [RACSubject new];
    }
    
    return _chooseTestViewDidSelect;
}

- (void)loadEnrollList:(kRefreshStatus)status{
    if (status == kRefreshNormal) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    kWeakSelf;
    [LZTestNetworkAPI loadListWithPage:self.page status:2 block:^(LZNetworkResult *result, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        [weakSelf.tableView endRefreshing:status];
        if (!error) {
            if (result.isSuccess) {
                
                // 清除所有数据
                if (status != kRefreshFooter) {
                    [self.dataSource removeAllObjects];
                }
                
                NSArray *list = [NSArray yy_modelArrayWithClass:[LZTestModel class] json:result.data[@"list"]];
                if (list) {
                    [weakSelf.dataSource addObjectsFromArray:list];
                }
                NSInteger total = [result.data[@"total"] integerValue];
                // 没有了
                [weakSelf setTableViewFooter:(weakSelf.dataSource.count >= total)];
                
                [weakSelf.tableView reloadData];
                
            } else {
                [MBProgressHUD showError:result.msg ToView:weakSelf];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf];
        }
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
