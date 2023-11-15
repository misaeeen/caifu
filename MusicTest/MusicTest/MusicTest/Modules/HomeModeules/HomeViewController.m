//
//  ViewController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/2.
//  Copyright © 2020 CF. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeControllerViewCell.h"
#import "OnlineTestController.h"
#import "LZUserManger.h"
#import "LoginViewController.h"
#import "LZHomeNetworkAPI.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LZBannerModel.h"
#import "UserInfoModel.h"
#import "CFWebViewController.h"
#import "Aes.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray <LZBannerModel *>*bannerDataSource;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"SPA线上考级";
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.cycleScrollView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.offset(0);
    }];
    
    [self loadBanner];
    
//    UserInfoModel * model = [UserInfoModel shareUserInfoModel];
//    UserInfoModel * amodel = [[UserInfoModel alloc]init];
    
//    NSLog(@"%@-------%@",model,amodel);

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"HomeControllerViewCell";
    HomeControllerViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[HomeControllerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self dealCellSelectEvent:cell];
    }
    [cell reloadDataWithArray:self.dataSource[indexPath.row]];
    return cell;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    LZBannerModel *model = self.bannerDataSource[index];
    if (model.content.length != 0) {
        [self goWebPageWithUrl:model.content title:@""];
    }
}

-(SDCycleScrollView *)cycleScrollView{
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WDITH, CONTROLLER_FRAME(148.0f)) delegate:self placeholderImage:nil];
        _cycleScrollView.autoScrollTimeInterval = 3.0f;
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _cycleScrollView;
}

-(void)dealCellSelectEvent:(HomeControllerViewCell*)cell{
    [cell.homeViewCellDidSelectSubject subscribeNext:^(id  _Nullable x) {
        if([LZUserManger isLogon]){
            switch ([x integerValue]) {
                case 1:
                    [self goWebPageWithUrl:[NSString stringWithFormat:@"%@?token=%@",TEXT_BOOK_URL,[LZUserManger authorization]] title:@"教材推荐"];
                    break;
//                case 2:
//                    [self goWebPageWithUrl:[NSString stringWithFormat:@"%@?token=%@",PROCESS_INTRODUCTION_URL,[LZUserManger authorization]] title:@"流程介绍"];
//                    break;
                case 3:{
                    if([[LZNetworkAPI baseURLString] isEqual:kURL_BASE_FRONT]){
                        [self goWebPageWithUrl:[NSString stringWithFormat:@"%@?token=%@",EXAM_GUIDE_URL,[LZUserManger authorization]] title:@"备考指南"];
                    }else{
                        [self goWebPageWithUrl:[NSString stringWithFormat:@"http://te.caifulife.cn:8088/exam_register/shoot_and_description?token=%@",[LZUserManger authorization]] title:@"备考指南"];
                    }
                    
                }
                    break;
                case 4:{
                    
                        OnlineTestController * vc = [[OnlineTestController alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case 5:
                    if([[LZNetworkAPI baseURLString] isEqual:kURL_BASE_FRONT]){
                        [self goWebPageWithUrl:[NSString stringWithFormat:@"%@?token=%@&phone=%@",MUSIC_THERY_TEST_URL,[LZUserManger authorization],[LZUserManger manager].userModel.mobile] title:@"乐理考级"];
                    }else{
                        [self goWebPageWithUrl:[NSString stringWithFormat:@"%@?token=%@&phone=%@",@"http://yltest.caifulife.cn:12120/djy_yl/mobile/dev_home",[LZUserManger authorization],[LZUserManger manager].userModel.mobile] title:@"乐理考级"];
                    }
                    
                    
                    break;
                default:
                    break;
            }
        }else{
            LoginViewController *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)goWebPageWithUrl:(NSString *)url title:(NSString *)title{
    CFWebViewController *webV = [[CFWebViewController alloc] init];
    webV.url = url;
    webV.titleStr = title;
    webV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webV animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CONTROLLER_FRAME(173);
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
    }
    
    return _tableView;
}


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        
        NSArray * array = @[
        @{
            @"iconName":@"home_item1",
            @"tag":@1,
        },@{
            @"iconName":@"home_item3",
            @"tag":@3,
        }];
        
        NSArray * array1 = @[@{
            @"iconName":@"home_item4",
            @"tag":@4,
        },@{
            @"iconName":@"home_item5",
            @"tag":@5,
        },];
        
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:array];
        [_dataSource addObject:array1];
        
    }
    
    return _dataSource;
}
- (void)loadBanner{
    kWeakSelf;
    [LZHomeNetworkAPI bannerWithBlock:^(LZNetworkResult *result, NSError *error) {
        if (!error) {
            if (result.isSuccess) {
                weakSelf.bannerDataSource = [NSArray yy_modelArrayWithClass:LZBannerModel.class json:result.data[@"list"]];
                NSMutableArray *imagePaths = [NSMutableArray array];
                for (LZBannerModel *bannerModel in weakSelf.bannerDataSource) {
                    [imagePaths addObject:bannerModel.imgUrl];
                }
                weakSelf.cycleScrollView.imageURLStringsGroup = imagePaths;
                
            } else {
                [MBProgressHUD showError:result.msg ToView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
        }
    }];
}
@end
