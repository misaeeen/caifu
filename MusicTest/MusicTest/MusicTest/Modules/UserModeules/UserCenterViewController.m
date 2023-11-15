//
//  UserCenterViewController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterCell.h"
#import "TestResultViewController.h"
#import "MyTestSuperViewController.h"
#import "LoginViewController.h"
#import "CFWebViewController.h"
#import "LZUserManger.h"
#import "LZLoginNetworkAPI.h"
#import "Aes.h"
@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSArray *dataSource;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"SPA线上考级";
    [self _setupSubviews];
}

- (void)_setupSubviews{
    [self.view addSubview:self.tableView];
    [self _setupTableHeaderView];
    [self _setupTableFooterView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.offset(0.0f);
    }];
}
- (void)_setupTableHeaderView{
    if ([LZUserManger isLogon]) {
        _tableView.tableHeaderView = [self crateIdLoginHeadView];
    }else{
        _tableView.tableHeaderView = [self createHeadView];
    }
}

- (void)_setupTableFooterView{
    UIView *footerView = nil;
    CGFloat height = SCREEN_HEIGHT - self.tableView.tableHeaderView.frame.size.height - 88.0f - 84.0f - NavBarHeight;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, height)];
    footerView.backgroundColor = [UIColor whiteColor];
    if ([LZUserManger isLogon]) {
       
        
        UIButton *logoutBtn = [UIButton createButtonWithTitleColor:ColorWithHex(@"#333333") font:FontWithSize(13.0f)];
        logoutBtn.backgroundColor = ColorWithHex(@"#FFCF26");
        [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
        logoutBtn.layer.cornerRadius = 4.0f;
        
        [[logoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"提示" message:@"确定要退出登录吗？"];
            
            [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
                
            }]];
            
            CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                [LZUserManger logoutWithPostNotification];
                [TestInfoCache removeAllCache];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [LZLoginNetworkAPI logoutWithBlock:^(LZNetworkResult *result, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (!error) {
                        if (result.isSuccess) {
                            
                        } else {
//                            [MBProgressHUD showError:result.msg ToView:self.view];
                        }
                    } else {
//                        [MBProgressHUD showError:error.localizedDescription ToView:self.view];
                    }
                }];
            }];
            action.bgColor = ColorWithHex(@"FFCF26");
            [alertV addAction:action];
            [alertV showAlertViewWithController:self.tabBarController];
            
            
        }];
        [footerView addSubview:logoutBtn];
        
        [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(16.0f);
                    make.right.offset(-16.0f);
                    make.bottom.offset(-88.0f);
                    make.height.offset(36.0f);
        }];
    }
    
    
    UIButton *protocolBtn = [UIButton createButtonWithTitleColor:ColorWithHex(@"#03DAC5") font:FontWithSize(13.0f)];
    [protocolBtn setTitle:@"点击阅读《用户协议和隐私政策》" forState:UIControlStateNormal];
    [[protocolBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        CFWebViewController *webV = [[CFWebViewController alloc] init];
        webV.url = [NSString stringWithFormat:@"%@",PRIVACY_PROTOCOL_URL];
        webV.titleStr = @"隐私协议";
        webV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webV animated:YES];
    }];
    [footerView addSubview:protocolBtn];
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.offset(16.0f);
//                make.right.offset(-16.0f);
                make.bottom.offset(-36.0f);
                make.height.offset(36.0f);
        make.centerX.equalTo(footerView);
    }];
    
    
    self.tableView.tableFooterView = footerView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *cellID = @"UserCenterCell";
        UserCenterCell *cell = (UserCenterCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell reloadWithModel:self.dataSource[indexPath.row]];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_version"]];
        [cell.contentView addSubview:imageV];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = [UIColor colorWithHexString:@"#333333"];
        titleL.font = FontWithSize(14.0f);
        titleL.text = @"版本号:";
        [cell.contentView addSubview:titleL];
        
        
        UILabel *rightL = [[UILabel alloc] init];
        rightL.textColor = [UIColor colorWithHexString:@"#333333"];
        rightL.font = FontWithSize(14.0f);
        rightL.text = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [cell.contentView addSubview:rightL];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cell.contentView addSubview:line];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(16.0f);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.height.offset(16.0f);
        }];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(imageV.mas_right).offset(12.0f);
        }];
        
        [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(-20.0f);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(16.0f);
            make.bottom.offset(0.0f);
            make.right.offset(-16.0f);
            make.height.offset(0.5f);
        }];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([LZUserManger isLogon]) {
        if (indexPath.row == 0) {
            MyTestSuperViewController * vc = [[MyTestSuperViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
//            TestResultViewController * vc = [[TestResultViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self goLoginPage];
    }
    
}
#pragma mark - getter and setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.rowHeight = 44.0f;
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
                        @{@"image":[UIImage imageNamed:@"user_center_test"],@"title":@"我的考级"},
//                        @{@"image":[UIImage imageNamed:@"achievement_query"],@"title":@"成绩查询"}
        ];
    }
    return _dataSource;
}

//未登录
-(UIView *)createHeadView{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 106)];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, SCREEN_WDITH-32, CONTROLLER_FRAME(74))];
    [imageV setImage:[UIImage imageNamed:@"my_no_login"]];
    [headView addSubview:imageV];
    
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, 0, SCREEN_WDITH, 106);
    [headView addSubview:loginButton];
    
    kWeakSelf;
    [[loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf goLoginPage];
    }];
    return headView;
}

-(UIView *)crateIdLoginHeadView{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 140)];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WDITH/2 - 37, 20, 74, 74)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:[LZUserManger manager].userModel.avatar]];
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = 37.;
    [headView addSubview:imageV];
    
    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, imageV.frame.origin.y + 86, SCREEN_WDITH-32, 15)];
    phoneLabel.text = [Aes AES128Decrypt:[LZUserManger manager].userModel.mobile];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    phoneLabel.textColor = ColorWithHex(@"#333333");
    
    [headView addSubview:phoneLabel];
    return headView;
}

- (void)goLoginPage{
    LoginViewController * vc = [[LoginViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_userLogin{
    [self _setupTableHeaderView];
    [self _setupTableFooterView];
}

- (void)_userLogout{
    [self _setupTableHeaderView];
    [self _setupTableFooterView];
}

@end
