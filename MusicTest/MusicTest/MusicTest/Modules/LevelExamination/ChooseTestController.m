//
//  ChooseTestController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//
//选择考级

#import "ChooseTestController.h"
#import "ChooseTestView.h"
#import "OnlineTestConfigInfoController.h"
#import "LZTestModel.h"
#import "LZTestNetworkAPI.h"
#import "TestFormalViewController.h"
#import "LZTestDetailsModel.h"
@interface ChooseTestController ()
@property(nonatomic,strong)ChooseTestView * chooseTestView;
@end

@implementation ChooseTestController

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"TestFinishNotification" object:nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择考试";
    [self.view addSubview:self.chooseTestView];
    [self.chooseTestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    [self dealSubviewEvent];
}

-(void)dealSubviewEvent{
    //cell点击事件
    __weak typeof(self) weakSelf = self;
    [self.chooseTestView.chooseTestViewDidSelect subscribeNext:^(id  _Nullable x) {
        LZTestModel *model = x;
        if ([model.examStatus isEqual:@"8"]) {
            [MBProgressHUD showError:@"该考试目前暂停中，请等待考级恢复后再参加考试。" ToView:self.view];
        }else{
            if (model.resetTimes < 2 && model.recordCnt == 0) {
                [TestInfoCache removeCacheWithId:model.id];
            }
            
            if(model.recordCnt == 0){
                OnlineTestConfigInfoController * vc = [[OnlineTestConfigInfoController alloc]init];
                vc.test_id = model.id;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                [LZTestNetworkAPI loadTestDetailsWithId:model.id block:^(LZNetworkResult *result, NSError *error) {
                    if (!error) {
                        if (result.isSuccess) {
                            
                            TestFormalViewController *controller = [[TestFormalViewController alloc] init];
                            controller.model = [LZTestDetailsModel yy_modelWithJSON:result.data];
                            [weakSelf.navigationController pushViewController:controller animated:YES];
                        } else {
                            [MBProgressHUD showError:result.msg ToView:weakSelf.view];
                        }
                    } else {
                        [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
                    }
                }];
            }
        }
    }];
}

-(ChooseTestView *)chooseTestView{
    if (!_chooseTestView) {
        _chooseTestView = [[ChooseTestView alloc]init];
    }
    return _chooseTestView;
}

@end
