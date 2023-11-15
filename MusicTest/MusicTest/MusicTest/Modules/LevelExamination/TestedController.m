//
//  TestedController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import "TestedController.h"
#import "TestInfoCell.h"
#import "OnlineTestController.h"
#import "WaitTestDetailViewController.h"
#import "LZTestModel.h"
#import "LZTestNetworkAPI.h"
#import "OnlineTestConfigInfoController.h"
#import "TestFormalViewController.h"
@interface TestedController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray <LZTestModel *> *dataSource;

@end

@implementation TestedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubview];
    
    self.page = 1;
    [self loadList:kRefreshNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTestStateNotification:) name:@"ChangeTestState" object:nil];
//    if (self.state == LZTestStateNotTested) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testFinishNotification) name:@"TestFinishNotification" object:nil];
//    }
}

- (void)changeTestStateNotification:(NSNotification *)notification{
//    NSDictionary *dict = notification.object;
    [self testFinishNotification];
}
- (void)testFinishNotification{
    self.page = 1;
    [self loadList:kRefreshNormal];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"TestInfoCell";
    TestInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[TestInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell reloadWithModel:self.dataSource[indexPath.row] state:self.state];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 104;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.state != LZTestStateNotTested || [self.dataSource[indexPath.row].status integerValue] == 6) {
        
        WaitTestDetailViewController * vc = [WaitTestDetailViewController new];
        vc.test_id = self.dataSource[indexPath.row].id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        LZTestModel *model =self.dataSource[indexPath.row];
        if ([model.examStatus isEqual:@"8"]) {
            [MBProgressHUD showError:@"该考试目前暂停中，请等待考级恢复后再参加考试。" ToView:self.view];
        }else{
            if (model.resetTimes < 2 && model.recordCnt == 0) {
                [TestInfoCache removeCacheWithId:model.id];
            }
            
            if(model.recordCnt == 0){
                OnlineTestConfigInfoController * vc = [[OnlineTestConfigInfoController alloc]init];
                vc.test_id = model.id;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [LZTestNetworkAPI loadTestDetailsWithId:model.id block:^(LZNetworkResult *result, NSError *error) {
                    if (!error) {
                        if (result.isSuccess) {
                            
                            TestFormalViewController *controller = [[TestFormalViewController alloc] init];
                            controller.model = [LZTestDetailsModel yy_modelWithJSON:result.data];
                            [self.navigationController pushViewController:controller animated:YES];
                        } else {
                            [MBProgressHUD showError:result.msg ToView:self.view];
                        }
                    } else {
                        [MBProgressHUD showError:error.localizedDescription ToView:self.view];
                    }
                }];
            }
        }
        
    }
}

-(void)initSubview{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if(@available(iOS 15.0,*)){
            _tableView.sectionHeaderTopPadding = 0;
        }
        @weakify(self);
        [_tableView setRefreshHeaderWithBlock:^{
            @strongify(self)if(!self)return;
            self.page = 1;
            [self loadList:kRefreshHeader];
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
        [self loadList:kRefreshFooter];
    }];
}

- (void)loadList:(kRefreshStatus)status{
    if (status == kRefreshNormal) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    kWeakSelf;
    LZNetworkBlock block = ^(LZNetworkResult *result, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
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
                [MBProgressHUD showError:result.msg ToView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
        }
    };
    if (self.state == LZTestStateTested) {
        [LZTestNetworkAPI loadTestedWithPage:self.page block:block];
    }else{
        [LZTestNetworkAPI loadListWithPage:self.page status:self.transferTestState block:block];
    }
    
    
}

- (NSInteger)transferTestState{
    NSInteger status;
    switch (self.state) {
        case LZTestStateNotTested:
            status = 2;
            break;
        case LZTestStateTested:
            status = 4;
            break;
        case LZTestStateLackTested:
            status = 6;
            break;
        default:
            break;
    }
    return status;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
