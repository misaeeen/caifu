//
//  WaitTestDetailViewController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/11.
//  Copyright © 2020 CF. All rights reserved.
// 待考详情页

#import "WaitTestDetailViewController.h"
#import "OnlineTestConfigCell.h"
#import "LZTestDetailsModel.h"
#import "LZTestNetworkAPI.h"
#import "NSString+CLString.h"
#import "TestResultCell.h"
#import "VideoPlayCell.h"
#import "CFWebViewController.h"
#import "LZUserManger.h"
@interface WaitTestDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)LZTestDetailsModel *model;

@property (nonatomic, strong)UIImageView *imgV;

@end

@implementation WaitTestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的考级";
    [self initSubview];
    [self loadTestDetails];
}


-(void)initSubview{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    

    [self.tableView insertSubview:self.imgV aboveSubview:self.tableView];
    [self.tableView bringSubviewToFront:self.imgV];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = self.dataSource[section][@"rows"];
    return rows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *rows = self.dataSource[indexPath.section][@"rows"];
    NSDictionary *dict = rows[indexPath.row];
    NSString *cellNamed = dict[@"cellNamed"];
    if ([cellNamed isEqual:@"OnlineTestConfigCell"]) {
        OnlineTestConfigCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNamed];
        if (cell == nil) {
            cell = [[OnlineTestConfigCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNamed];
        }
        [cell reloadWithData:dict];
        return cell;
    }else if([cellNamed isEqual:@"VideoPlayCell"]){
        VideoPlayCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNamed];
        if (cell == nil) {
            cell = [[VideoPlayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNamed];
        }
        kWeakSelf;
        [cell setLeftBtnClick:^(NSIndexPath *indexPath) {
            [weakSelf goWebPage];
        }];
        [cell setRightBtnClick:^(NSIndexPath *indexPath) {
            [weakSelf goWebPage];
        }];
        [cell reloadWithModel:dict];
        return cell;
    }else{
        return [UITableViewCell new];
    }
}
- (void)goWebPage{
    [LZTestNetworkAPI authWithVideoId:self.model.videoId block:^(LZNetworkResult *result, NSError *error) {
        if (!error) {
            if (result.isSuccess) {
                CFWebViewController *webV = [[CFWebViewController alloc] init];
                if([[LZNetworkAPI baseURLString] isEqual:kURL_BASE_FRONT]){
                    webV.url = [NSString stringWithFormat:@"%@?videoId=%@&token=%@",PLAY_VIDEO_URL,self.model.videoId,[LZUserManger authorization]];
                }else{
                    webV.url = [NSString stringWithFormat:@"http://te.caifulife.cn:8088/exam_register/player?videoId=%@&token=%@",self.model.videoId,[LZUserManger authorization]];
                }
                
                webV.titleStr = @"视频播放";
                [self.navigationController pushViewController:webV animated:YES];
            } else {
                [MBProgressHUD showError:@"视频转码中，请稍后，若长时间仍无法查看，请联系系统管理员" ToView:self.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:self.view];
        }
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *rows = self.dataSource[indexPath.section][@"rows"];
    return [rows[indexPath.row][@"cellHeight"] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self createHeadViewWithData:self.dataSource[section]];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
        _tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
    }
    
    return _tableView;
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WDITH - 63.0f - 48.0f, 8.0f * 43.0f + 12.0f, 63.0f, 50.0f)];
        _imgV.hidden = YES;
    }
    return _imgV;
}


-(UIView *)createHeadViewWithData:(NSDictionary *)data{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 43)];
    UIImageView * iconImageV = [[UIImageView alloc]initWithImage:data[@"image"]];
           
          UILabel * titleLab = [[UILabel alloc]init];
           titleLab.textColor = ColorWithHex(@"333333");
           titleLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
           titleLab.text = data[@"title"];
           
           [view addSubview:iconImageV];
           [view addSubview:titleLab];
           [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
               make.height.width.mas_equalTo(21);
               make.left.offset(16);
               make.top.offset(12);
           }];
           
           [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
               make.height.mas_equalTo(21);
               make.left.equalTo(iconImageV.mas_right).offset(8);
               make.top.offset(12);
           }];
    
    return view;
      
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)loadTestDetails{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    kWeakSelf;
    [LZTestNetworkAPI loadTestDetailsWithId:self.test_id block:^(LZNetworkResult *result, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (!error) {
            if (result.isSuccess) {
                
                weakSelf.model = [LZTestDetailsModel yy_modelWithJSON:result.data];
                
//                weakSelf.tableView.tableHeaderView = [self createHeaderView];
//                [weakSelf.headImageV sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.profile.photoUrl]];
                [weakSelf bindDataSource];
                
                [weakSelf.tableView reloadData];
                
            } else {
                [MBProgressHUD showError:result.msg ToView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
        }
    }];
}

- (void)bindDataSource{
    NSString *examStartTime = [self.model.examStartTime timerTransfer];
    NSString *examEndTime = [self.model.examEndTime timerTransfer];
    NSString *examTime = [NSString stringWithFormat:@"%@--%@",examStartTime,examEndTime];
    
    NSString *level = [self getGradeStr];
    NSString *score = self.model.score.length != 0 ? self.model.score : @"--";
    NSString *textColor = @"";
    NSInteger grade = [self.model.grade integerValue];
    
    if (grade != 0) {
        if (grade == 1) {
            textColor = @"#FF3B30";
        }else{
            textColor= @"#FFAF26";
        }
    }
    
    NSString *comments = self.model.comments.length != 0 ? self.model.comments : @"--";
    
    NSInteger status = [self.model.status integerValue];
    if (status == 4) {
        self.imgV.hidden = NO;
        self.imgV.image = [self getGradeImage];
    } else if(status == 6) {
        self.imgV.hidden = NO;
        self.imgV.image = [UIImage imageNamed:@"icon_result_not"];
    } else {
        self.imgV.hidden = YES;
    }
    if ([self.model.isIssued isEqual:@"0"]) {
        level = @"--";
        score = @"--";
        comments = @"--";
        textColor = @"";
        self.imgV.hidden = YES;
    }
    
    NSMutableArray *rows = @[
        @{@"title":@"考级科目：",@"content":CLNoNilString(self.model.subject),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)},
        @{@"title":@"考级等级：",@"content":CLNoNilString(self.model.level),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)},
        @{@"title":@"考级教材：",@"content":CLNoNilString(self.model.book),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)}].mutableCopy;
    
    NSArray *chapters = [self.model.chapter componentsSeparatedByString:@","];
    for (NSInteger i = 0; i < chapters.count; i ++) {
        [rows addObject:@{@"title":i == 0 ? @"考级曲目：" : @"",@"content":CLNoNilString(chapters[i]),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)}];
    }
    [rows addObject:@{@"title":@"考级时间：",@"content":CLNoNilString(examTime),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)}];
    NSMutableArray *sections = @[
        @{
            @"title":@"报考信息",
            @"image":[UIImage imageNamed:@"icon_apply_test"],
            @"rows":rows
        },
        @{
            @"title":@"我的成绩",
            @"image":[UIImage imageNamed:@"icon_tested_achievement"],
            @"rows":@[
                    @{@"title":@"考级名称：",@"content":CLNoNilString(self.model.title),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)},
                    @{@"title":@"等级：",@"content":CLNoNilString(level),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43),@"textColor":textColor},
                    @{@"title":@"分数：",@"content":CLNoNilString(score),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)},
                    @{@"title":@"评语：",@"content":CLNoNilString(comments),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)},
            ]
        }
    ].mutableCopy;
    
    if (status == 3 || status == 4) {
        [sections addObject: @{
            @"title":@"我的视频",
            @"image":[UIImage imageNamed:@"icon_video"],
            @"rows":@[
                    @{@"image":self.model.videoCover == nil ? @"" : self.model.videoCover ,@"btnTitle":@"查看视频",@"btnIcon":[UIImage imageNamed:@"test_state_not_tested"],@"cellNamed":@"VideoPlayCell",@"cellHeight":@(118)},

            ]
        }];
    }
    
    
    
    
    self.dataSource = sections.mutableCopy;
    
}

- (NSString *)getGradeStr{
    NSString * gradeStr = @"--";
    NSInteger grade = [self.model.grade integerValue];
    //评分等级 1 不及格 2 及格 3 良好 4 优秀
    if (grade == 1) {
        gradeStr = @"不及格";
    }else if (grade == 2) {
        gradeStr = @"及格";
    }else if (grade == 3) {
        gradeStr = @"良好";
    }else if (grade == 4) {
        gradeStr = @"优秀";
    }
    return gradeStr;
}

- (UIImage *)getGradeImage{
    UIImage *gradeImage = nil;
    NSInteger grade = [self.model.grade integerValue];
    //评分等级 1 不及格 2 及格 3 良好 4 优秀
    if (grade == 1) {
        gradeImage = [UIImage imageNamed:@"icon_result_fail"];
    }else {
        gradeImage = [UIImage imageNamed:@"icon_result_success"];
    }
    return gradeImage;
}


@end
