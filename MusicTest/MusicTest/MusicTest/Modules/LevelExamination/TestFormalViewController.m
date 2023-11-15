//
//  TestFormalViewController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/11.
//  Copyright © 2020 CF. All rights reserved.
//
//正式考级
#import "TestFormalViewController.h"
#import "OnlineTestConfigCell.h"
#import "MyTestSuperViewController.h"
#import "WaitTestDetailViewController.h"
#import "CFWebViewController.h"
#import <AVKit/AVKit.h>
#import "UIImage+Utils.h"
#import "LZTestNetworkAPI.h"
#import "LZUploadModel.h"
#import "VideoSubmitCell.h"
//#import "OnlineTestConfigInfoController.h"
#import "ChooseTestController.h"
#import "VideoCaptureController.h"

#import <VODUpload/VODUploadClient.h>
#import <VODUpload/VODUploadModel.h>



@interface TestFormalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIImageView * videoImageV;
@property(nonatomic,strong)UIButton * videoPlayButton;

@property(nonatomic,strong)UIButton * saveVideoButton;
@property(nonatomic,strong)UIButton * postVideoButton;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong) VODUploadClient *uploader;
@property (nonatomic, strong) LZUploadModel *uploadModel;

@property (nonatomic, assign) NSInteger videoIndex;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, assign) NSInteger count;

@end

@implementation TestFormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.model.isSimulation){
        self.title = @"模拟考试";
    }else{
        self.title = @"正式考试";
    }
    self.count = 0;
    self.videoIndex = 0;
    [self initSubview];
    
    [self bindDataSource];
    [self.tableView reloadData];
    if(!self.model.isSimulation){
        [self loadUploadIdWithFileInfo:nil];
    }
    if(!self.model.isSimulation){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backPage)];
    }
}


- (void)backPage{
    CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"请确认" message:@"您尚未上传视频，是否退出？\n退出后，在考试时间截止前，仍可进入本场考试进行视频提交"];
    
    [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
        
    }]];
    
    CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    action.bgColor = ColorWithHex(@"FFCF26");
    [alertV addAction:action];
    [alertV showAlertViewWithController:self.navigationController];
    
}


- (void)setupUploader{
    
    self.hud = [MBProgressHUD showProgressToView:nil ProgressModel:MBProgressHUDModeDeterminate Text:@"视频解析中，请稍后"];

    
    self.uploader = [VODUploadClient new];
    //weakself
    kWeakSelf;
    //setup callback
    OnUploadFinishedListener FinishCallbackFunc = ^(UploadFileInfo* fileInfo, VodUploadResult* result){
        NSLog(@"upload finished callback videoid:%@, imageurl:%@&amp;quot;", result.videoId, result.imageUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 通知主线程刷新
//            [weakSelf.hud hideAnimated:YES];
            [weakSelf performSelector:@selector(videoUploadConfim) withObject:nil afterDelay:3.0f];
        });
    };
    OnUploadFailedListener FailedCallbackFunc = ^(UploadFileInfo* fileInfo, NSString *code, NSString* message){
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通知主线程刷新
            [weakSelf.hud hideAnimated:YES];
            [MBProgressHUD showError:@"上传失败，请重新上传" ToView:weakSelf.view];
        });
        
    };
    OnUploadProgressListener ProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
        NSLog(@"upload progress callback uploadedSize : %li, totalSize : %li", uploadedSize, totalSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通知主线程刷新
            weakSelf.hud.progress = ([@(uploadedSize) doubleValue] / [@(totalSize) doubleValue]);
        });
    };
    OnUploadTokenExpiredListener TokenExpiredCallbackFunc = ^{
        NSLog(@"upload token expired callback");
        //token过期，设置新的上传凭证，继续上传
        [weakSelf refreshUploadId];
    };
    OnUploadRertyListener RetryCallbackFunc = ^{
        NSLog(@"upload retry begin callback.");
    };
    OnUploadRertyResumeListener RetryResumeCallbackFunc = ^{
        NSLog(@"upload retry end callback.");
    };
    OnUploadStartedListener UploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
        NSLog(@"upload upload started callback.");
//        [weakSelf loadUploadIdWithFileInfo:fileInfo];
        //设置上传地址和上传凭证
        if(weakSelf.uploadModel){
            [weakSelf.uploader setUploadAuthAndAddress:fileInfo uploadAuth:weakSelf.uploadModel.uploadAuth uploadAddress:weakSelf.uploadModel.uploadAddress];
        }
    };
    VODUploadListener *listener = [[VODUploadListener alloc] init];
    listener.finish = FinishCallbackFunc;
    listener.failure = FailedCallbackFunc;
    listener.progress = ProgressCallbackFunc;
    listener.expire = TokenExpiredCallbackFunc;
    listener.retry = RetryCallbackFunc;
    listener.retryResume = RetryResumeCallbackFunc;
    listener.started = UploadStartedCallbackFunc;
    //init with upload address and upload auth
    
    [self.uploader init:listener];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.testedCount < 2 && self.isFromCaptruePage) {
        return 2;
    }
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.testedCount < 2 && self.isFromCaptruePage) {
        if (section == 0) {
            return self.dataSource.count;
        }else{
            return 0;
        }
    }else{
        NSArray *rows = self.dataSource[section][@"rows"];
        return rows.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellNamed;
    NSDictionary *dict;
    if (self.testedCount < 2 && self.isFromCaptruePage) {
        dict = self.dataSource[indexPath.row];
        cellNamed = @"OnlineTestConfigCell";
    }else{
        NSArray *rows = self.dataSource[indexPath.section][@"rows"];
        dict = rows[indexPath.row];
        cellNamed = dict[@"cellNamed"];
    }
    
    if ([cellNamed isEqual:@"OnlineTestConfigCell"]) {
        OnlineTestConfigCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNamed];
        if (cell == nil) {
            cell = [[OnlineTestConfigCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNamed];
        }
        [cell reloadWithData:dict];
        return cell;
    }else if([cellNamed isEqual:@"VideoPlayCell"]){
        VideoSubmitCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNamed];
        if (cell == nil) {
            cell = [[VideoSubmitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNamed];
        }
        cell.indexPath = indexPath;
        LZTestInfoModel *testModel = dict[@"model"];
        [cell reloadWithModel:testModel];
        kWeakSelf;
        [cell setLeftBtnClick:^(NSIndexPath *indexPath) {
            weakSelf.videoIndex = indexPath.row;
            [weakSelf palyVideo];
        }];
        [cell setRightBtnClick:^(NSIndexPath *indexPath) {
            CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"请确认" message:@"是否确认提交视频？\n提交后，将完成本次考试。"];
            
            [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
                
            }]];
            
            CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                weakSelf.videoIndex = indexPath.row;
                [weakSelf startUploadVideo];
            }];
            action.bgColor = ColorWithHex(@"FFCF26");
            [alertV addAction:action];
            [alertV showAlertViewWithController:self.navigationController];
        }];
        return cell;
    }else{
        return [UITableViewCell new];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.testedCount < 2 && self.isFromCaptruePage) {
        return 43.0f;
    }
    NSArray *rows = self.dataSource[indexPath.section][@"rows"];
    return [rows[indexPath.row][@"cellHeight"] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.testedCount < 2 && self.isFromCaptruePage) {
        NSArray <LZTestInfoModel *>*tests = self.testinfos;
        if (tests.count != 0 && section == 1) {
            LZTestInfoModel *model = tests[0];
            return model.isFinish == 1 ? CGFLOAT_MIN : 25.0f;
        }else{
            if (tests.count == 0) {
                return 25.0f;
            }
            return CGFLOAT_MIN;
        }
        
    }
    if(section == 0){
        return 43.0f;
    }else{
        return 43.0f + 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.testedCount < 2 && self.isFromCaptruePage) {
        NSArray <LZTestInfoModel *>*tests = self.testinfos;
        if (tests.count == 0) {
            UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 25)];
            UILabel *detailsL = [[UILabel alloc] initWithFrame:CGRectMake(16, 0.0f, SCREEN_WDITH - 32.0f, 25)];
            detailsL.font = FontWith14px;
            detailsL.textColor = [UIColor redColor];
            detailsL.numberOfLines = 1;
            detailsL.text = @"视频录制中断，该视频不完整";
            [bgV addSubview:detailsL];
            return bgV;
        }
        if (tests.count != 0 && section == 1) {
            LZTestInfoModel *model = tests[0];
            if (model.isFinish == 1) {
                return nil;
            }else{
                UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 25)];
                UILabel *detailsL = [[UILabel alloc] initWithFrame:CGRectMake(16, 0.0f, SCREEN_WDITH - 32.0f, 25)];
                detailsL.font = FontWith14px;
                detailsL.textColor = [UIColor redColor];
                detailsL.numberOfLines = 1;
                detailsL.text = @"视频录制中断，该视频不完整";
                [bgV addSubview:detailsL];
                return bgV;
            }
        }else{
            
            return nil;
        }
        
    }
    UIView *view = [self createHeadViewWithData:self.dataSource[section]];
    if(section == 0){
        return view;
    }else{
        
        UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 43.0f + 40)];
        [bgV addSubview:view];
        
        UILabel *detailsL = [[UILabel alloc] initWithFrame:CGRectMake(16, 43.0f, SCREEN_WDITH - 32.0f, 40)];
        detailsL.font = FontWith14px;
        detailsL.textColor = [UIColor redColor];
        detailsL.numberOfLines = 0;
        detailsL.text = @"每次考试仅允许提交一个视频，可在下方预览并提交视频";
        
        NSArray <LZTestInfoModel *>*tests = self.testinfos;
        if (tests.count == 0) {
            detailsL.text = @"由于考试过程中存在中断现象，故视频录制未完成";
        }else{
            BOOL isFinish = NO;
            for (LZTestInfoModel *model in tests) {
                if (model.isFinish == 1) {
                    isFinish = YES;
                    break;
                }
            }
            
            if (isFinish) {
                detailsL.text = @"每次考试仅允许提交一个视频，可在下方预览并提交视频";
            }else{
                detailsL.text = @"由于考试过程中存在中断现象，故视频录制未完成";
            }
        }
        
        
        [bgV addSubview:detailsL];
        return bgV;
    }
    
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

-(void)initSubview{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    if (self.testedCount < 2) {
        if (!self.model.isSimulation) {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 56.0f * 2.0f + 36.0f * 2.0f + 16.0f)];
            footerView.backgroundColor = [UIColor whiteColor];
            self.tableView.tableFooterView = footerView;
            
            [footerView addSubview:self.saveVideoButton];
            [footerView addSubview:self.postVideoButton];
            NSArray <LZTestInfoModel *>*tests = self.testinfos;
            if (tests.count != 0) {
                LZTestInfoModel *model = tests[0];
                if (model.isFinish != 1) {
                    self.postVideoButton.hidden = YES;
                }
            }
            if (!self.isFromCaptruePage) {
                self.postVideoButton.hidden = YES;
            }
            if (self.postVideoButton.hidden) {
                self.saveVideoButton.backgroundColor = ColorWithHex(@"FFCF26");
                self.saveVideoButton.layer.borderWidth = 0.0f;
            }
            [self.postVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(16);
                make.right.offset(-16);
                make.bottom.offset(-56);
                make.height.mas_equalTo(@36);
            }];
            
            [self.saveVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(16);
               make.right.offset(-16);
               make.bottom.equalTo(self.postVideoButton.mas_top).offset(-12);
               make.height.mas_equalTo(@36);
            }];
        }else{
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 56.0f * 2.0f + 36.0f * 2.0f + 16.0f)];
            footerView.backgroundColor = [UIColor whiteColor];
            self.tableView.tableFooterView = footerView;
            [footerView addSubview:self.postVideoButton];
            [self.postVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(16);
                make.right.offset(-16);
                make.bottom.offset(-56);
                make.height.mas_equalTo(@36);
            }];
        }
        if (self.isFromCaptruePage) {
            UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 176)];
            self.videoImageV.frame = CGRectMake(16, 8, SCREEN_WDITH-32, 160);
            self.videoPlayButton.frame = CGRectMake(SCREEN_WDITH/2 - 22, 66, 44, 44);
            [headView addSubview:self.videoImageV];
            [headView addSubview:self.videoPlayButton];
            self.tableView.tableHeaderView = headView;
        }
    }
    
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

-(UIImageView *)videoImageV{
    if (!_videoImageV) {
        _videoImageV = [[UIImageView alloc]init];
        _videoImageV.layer.cornerRadius = 3;
        _videoImageV.layer.masksToBounds = YES;
        _videoImageV.image = [UIImage imageNamed:@"ic_video_not_default"];
        NSArray <LZTestInfoModel *>*tests = self.testinfos;
        if (tests.count > self.videoIndex) {
            LZTestInfoModel *testModel = tests[self.videoIndex];
            NSString *path = testModel.video_path;
            if (path.length != 0) {
                NSURL *url = [NSURL fileURLWithPath:path];
                UIImage *image = [self firstFrameWithVideoURL:url size:CGSizeMake(SCREEN_WDITH-32, 160)];
                if (image == nil) {
                    image = [UIImage imageNamed:@"ic_video_not_default"];
                }
                _videoImageV.image = image;
                self.videoPlayButton.hidden = NO;
            }else{
                self.videoPlayButton.hidden = YES;
                _videoImageV.image = [UIImage imageNamed:@"ic_video_not_default"];
            }
        }else{
            self.videoPlayButton.hidden = YES;
            _videoImageV.image = [UIImage imageNamed:@"ic_video_not_default"];
        }
    }
    
    return _videoImageV;
}

-(UIButton *)videoPlayButton{
    if (!_videoPlayButton) {
        _videoPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoPlayButton setBackgroundImage:[UIImage imageNamed:@"video_play_icon"] forState:UIControlStateNormal];
        [[_videoPlayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self palyVideo];
        }];
    }
    
    return _videoPlayButton;
}
- (void)palyVideo{
    
    NSArray <LZTestInfoModel *>*tests = [TestInfoCache loadTestInfoWithId:self.model.id];
//    if (tests.count > self.videoIndex) {
    LZTestInfoModel *testModel = nil;
    for (LZTestInfoModel *f_testModel in tests) {
        if (f_testModel.testedCount == self.videoIndex + 1) {
            testModel = f_testModel;
        }
    }
    if (testModel == nil) {
        return;
    }
    NSString *path = testModel.video_path;
    if (path.length != 0) {
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        NSURL *url = [NSURL fileURLWithPath:path];
        playerVC.player= [[AVPlayer alloc]initWithURL:url];
        [self presentViewController:playerVC animated:YES completion:nil];
    }
//    }
}

-(UIButton *)saveVideoButton{
    if (!_saveVideoButton) {
        _saveVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveVideoButton setTitle:@"返回录制第二次考试视频" forState:UIControlStateNormal];
        _saveVideoButton.titleLabel.font = FontWithSize(13);
        _saveVideoButton.layer.masksToBounds = YES;
        _saveVideoButton.layer.cornerRadius = 4;
        _saveVideoButton.layer.borderWidth = 0.5f;
        _saveVideoButton.layer.borderColor = ColorWithHex(@"#CCCCCC").CGColor;
        [_saveVideoButton setTitleColor:ColorWithHex(@"#333333") forState:UIControlStateNormal];
        kWeakSelf;
        [[_saveVideoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"友情提示！" message:@"点击确认将进入考试，并消耗一次考试机会。"];
            
            [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
                
            }]];
            
            CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                [weakSelf secondTested];
            }];
            action.bgColor = ColorWithHex(@"FFCF26");
            [alertV addAction:action];
            [alertV showAlertViewWithController:self.navigationController];
           
        }];
    }
    
    return _saveVideoButton;
}

- (void)secondTested{
    [LZTestNetworkAPI testCountWithId:self.model.id block:^(LZNetworkResult *result, NSError *error) {
        if (!error) {
            if (result.isSuccess) {
                NSInteger testedCount = [result.data integerValue];
                if(testedCount <= 2){
                    LZTestInfoModel *testInfoModel = [[LZTestInfoModel alloc] init];
                    testInfoModel.test_id = self.model.id;
                    testInfoModel.testedCount = testedCount;
                    [TestInfoCache saveTestInfoWithModel:testInfoModel];
                    VideoCaptureController *vc = [[VideoCaptureController alloc] init];
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    self.model.recordCnt = testedCount;
                    vc.model = self.model;
                    vc.testinfoModel = testInfoModel;
                    kWeakSelf;
                    [vc setFinishBlock:^(LZTestDetailsModel *model, BOOL finished) {
                        TestFormalViewController *controller = [[TestFormalViewController alloc] init];
                        controller.model = model;
                        controller.isFromCaptruePage = YES;
                        
                        NSMutableArray *vcs = weakSelf.navigationController.viewControllers.mutableCopy;
                        
                        for (NSInteger i = 0; i < vcs.count; i ++) {
                            UIViewController *vc = vcs[i];
                            if ([vc isKindOfClass:TestFormalViewController.class] || [vc isKindOfClass:weakSelf.class] ||
                                [vc isKindOfClass: NSClassFromString(@"OnlineTestConfigInfoController")]) {
                                [vcs removeObject:vc];
                                i --;
                            }
                        }
                        if([TestInfoCache loadTestCountWithId:model.id] >= 2){
                            finished = YES;
                        }
                        if (finished) {
                            TestFormalViewController *controller = [[TestFormalViewController alloc] init];
                            controller.model = model;
                            controller.isFromCaptruePage = YES;
                            [vcs addObject:controller];
                        }
                        [weakSelf.navigationController setViewControllers:vcs.copy animated:YES];
                    }];
                    [self presentViewController:vc animated:NO completion:nil];
                }else{
                    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
                    
                    if ([vcs containsObject:self]) {
                        [vcs removeObject:self];
                    }
                    
                    TestFormalViewController *controller = [[TestFormalViewController alloc] init];
                    self.model.recordCnt = testedCount;
                    controller.model = self.model;
                    controller.isFromCaptruePage = YES;
                    [vcs addObject:controller];
                   
                    [self.navigationController setViewControllers:vcs.copy animated:YES];

                }
            } else {
                [MBProgressHUD showError:result.msg ToView:self.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:self.view];
        }
        
    }];
}

-(UIButton *)postVideoButton{
    if (!_postVideoButton) {
        _postVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.model.isSimulation) {
            [_postVideoButton setTitle:@"返回" forState:UIControlStateNormal];
        }else{
            [_postVideoButton setTitle:@"提交考试" forState:UIControlStateNormal];
        }
        
        _postVideoButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _postVideoButton.layer.masksToBounds = YES;
        _postVideoButton.layer.cornerRadius = 4;
        [_postVideoButton setBackgroundColor:ColorWithHex(@"#FFCF26")];
         [_postVideoButton setTitleColor:ColorWithHex(@"#333333") forState:UIControlStateNormal];
        [[_postVideoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(self.model.isSimulation){
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"请确认" message:@"是否确认提交视频？\n提交后，将完成本次考试。"];
            
            [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
                
            }]];
            
            CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                [self startUploadVideo];
            }];
            action.bgColor = ColorWithHex(@"FFCF26");
            [alertV addAction:action];
            [alertV showAlertViewWithController:self.navigationController];
            
        }];
    }
    
    return _postVideoButton;
}

- (void)startUploadVideo{
    [LZTestNetworkAPI loadTestDetailsWithId:self.model.id block:^(LZNetworkResult *result, NSError *error) {
        if (!error) {
            if (result.isSuccess) {
                LZTestDetailsModel *model = [LZTestDetailsModel yy_modelWithJSON:result.data];
                if (model.resetTimes < 2 && model.recordCnt == 0) {
                    [TestInfoCache removeCacheWithId:model.id];
                    CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"请确认" message:@"此场考试已重置，请返回首页重新考试"];
                    CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    action.bgColor = ColorWithHex(@"FFCF26");
                    [alertV addAction:action];
                    [alertV showAlertViewWithController:self.navigationController];
                }else{
                    NSArray <LZTestInfoModel *>*tests = [TestInfoCache loadTestInfoWithId:self.model.id];
            //    if (tests.count > self.videoIndex) {
                    LZTestInfoModel *testModel = nil;
                    for (LZTestInfoModel *f_testModel in tests) {
                        if (f_testModel.testedCount == self.videoIndex + 1) {
                            testModel = f_testModel;
                        }
                    }
                    if (testModel == nil) {
                        return;
                    }
                    NSString *path = testModel.video_path;
                    if (path.length != 0) {
                        VodInfo *vodInfo = [[VodInfo alloc] init];
                        vodInfo.title = @"标题";
                        vodInfo.desc = @"描述";
                        vodInfo.cateId = @(19);
                        [self setupUploader];
                        [self.uploader addFile:path vodInfo:vodInfo];
                        [self.uploader start];
                    }
                    NSURL *url = [NSURL fileURLWithPath:path];
                    UIImage *image = [UIImage getThumbnailImage:url size:CGSizeMake(SCREEN_WDITH, SCREEN_HEIGHT)];
                    if (image != nil) {
                        [LZTestNetworkAPI testUploadImage:image block:^(LZNetworkResult *result, NSError *error) {
                        
                            
                        }];
                    }
                    
            //    }
                }
            } else {
                [MBProgressHUD showError:result.msg ToView:self.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:self.view];
        }
    }];
    
        
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)bindDataSource{
    NSString *examStartTime = [self.model.examStartTime timerTransfer];
    NSString *examEndTime = [self.model.examEndTime timerTransfer];
    NSString *examTime = [NSString stringWithFormat:@"%@--%@",examStartTime,examEndTime];
    if(self.model.isSimulation){
        examTime = self.model.examTime;
    }
    if (self.testedCount < 2 && self.isFromCaptruePage) {
        NSMutableArray *titles = @[
            @"考生姓名：",@"考级科目：",@"考级等级：",@"考级教材："].mutableCopy;
        NSArray *chapters = [self.model.chapter componentsSeparatedByString:@","];
        
        NSMutableArray *contents = @[
            CLNoNilString(self.model.profile.name),
            CLNoNilString(self.model.subject),
            CLNoNilString(self.model.level),
            CLNoNilString(self.model.book)].mutableCopy;
        for (NSInteger i = 0; i < chapters.count; i ++) {
            if (i == 0) {
                [titles addObject:@"考级曲目："];
            }else{
                [titles addObject:@""];
            }
            [contents addObject:CLNoNilString(chapters[i])];
        }
        [titles addObject:@"考级时间："];
        [contents addObject:CLNoNilString(examTime)];
//        if (!self.isFromCaptruePage) {
//            [titles addObject:@"考试次数："];
//            [contents addObject:[NSString stringWithFormat:@"%@",@(self.model.recordCnt > 2 ? 2 : self.model.recordCnt)]];
//        }
        
        
       
        
        for (NSInteger i = 0; i < titles.count; i ++) {
            [self.dataSource addObject:@{
                        @"title":titles[i],
                        @"content":contents[i]
            }];
        }
        
    }else{
        NSMutableArray *srows = @[@{@"title":@"考生姓名：",@"content":CLNoNilString(self.model.profile.name),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)},
                                 @{@"title":@"考级科目：",@"content":CLNoNilString(self.model.subject),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)},
                                 @{@"title":@"考级等级：",@"content":CLNoNilString(self.model.level),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)},
                                 @{@"title":@"考级教材：",@"content":CLNoNilString(self.model.book),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)}].mutableCopy;
        NSArray *chapters = [self.model.chapter componentsSeparatedByString:@","];
        for (NSInteger i = 0; i < chapters.count; i ++) {
            [srows addObject:@{@"title":i == 0 ? @"考级曲目：" : @"",@"content":CLNoNilString(chapters[i]),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)}];
        }
        
        [srows addObjectsFromArray:@[@{@"title":@"考级时间：",@"content":CLNoNilString(examTime),@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)},
                                    @{@"title":@"考试次数：",@"content":[NSString stringWithFormat:@"%@",@(self.model.recordCnt > 2 ? 2 : self.model.recordCnt)],@"cellNamed":@"OnlineTestConfigCell",@"cellHeight":@(43)}]];
        NSMutableArray *sections = @[
            @{
                @"title":@"报考信息",
                @"image":[UIImage imageNamed:@"icon_apply_test"],
                @"rows":srows
            }
        ].mutableCopy;
        NSMutableArray *rows = [NSMutableArray array];
        NSArray *tests = [TestInfoCache loadTestInfoWithId:self.model.id];
        NSInteger count = self.testedCount > 2 ? 2 : self.testedCount;
        for (NSInteger i = 0; i < count; i ++) {
            LZTestInfoModel *testModel = nil;
            for (NSInteger j = 0; j < tests.count; j ++) {
                LZTestInfoModel *testModel1 = tests[j];
                if (testModel1.testedCount == i + 1) {
                    testModel = testModel1;
                }
            }
            if (testModel == nil) {
                testModel = [[LZTestInfoModel alloc] init];
                testModel.test_id = self.model.id;
                testModel.testedCount = i + 1;
            }
            [rows addObject: @{@"cellNamed":@"VideoPlayCell",@"cellHeight":@(118),@"model":testModel}];
        }
        [sections addObject: @{
            @"title":@"我的视频",
            @"image":[UIImage imageNamed:@"icon_video"],
            @"rows":rows.copy
        }];
        
        self.dataSource = sections;
    }
}

- (void)loadUploadIdWithFileInfo:(UploadFileInfo *)fileInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    kWeakSelf;
    [LZTestNetworkAPI loadUploadIdWithId:self.model.id fileExt:@"mov" block:^(LZNetworkResult *result, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (!error) {
            if (result.isSuccess) {
                weakSelf.uploadModel = [LZUploadModel yy_modelWithJSON:result.data];
            } else {
                [MBProgressHUD showError:result.msg ToView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
        }
    }];
}
- (void)refreshUploadId{
    kWeakSelf;
    [LZTestNetworkAPI refreshUploadIdWithVideoId:self.uploadModel.videoId block:^(LZNetworkResult *result, NSError *error) {
        if (!error) {
            if (result.isSuccess) {
                weakSelf.uploadModel = [LZUploadModel yy_modelWithJSON:result.data];
                [weakSelf.uploader resumeWithAuth:weakSelf.uploadModel.uploadAuth];
            } else {
                [MBProgressHUD showError:result.msg ToView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
        }
    }];
}

- (void)videoUploadConfim{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    kWeakSelf;
    [LZTestNetworkAPI videoUploadConfirmWithId:self.model.id videoId:self.uploadModel.videoId block:^(LZNetworkResult *result, NSError *error) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (!error) {
            if (result.isSuccess) {
                [weakSelf.hud hideAnimated:YES];
                [MBProgressHUD showError:@"上传完成" ToView:weakSelf.view];
                
                [TestInfoCache removeCacheWithId:weakSelf.model.id];
                
                [weakSelf goTestedDetailsPage];
            } else {
                if(self.count < 5){
                    self.count ++;
                    [weakSelf performSelector:@selector(videoUploadConfim) withObject:nil afterDelay:5.0f];
                }else{
                    [weakSelf.hud hideAnimated:YES];
                    [MBProgressHUD showError:result.msg ToView:weakSelf.view];
                }
                
            }
        } else {
            if(self.count < 5){
                self.count ++;
                [weakSelf performSelector:@selector(videoUploadConfim) withObject:nil afterDelay:5.0f];
            }else{
                [weakSelf.hud hideAnimated:YES];
                [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
            }
            
        }
    }];
}

- (void)goTestedDetailsPage{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"TestFinishNotification" object:nil]];
    
    NSArray *vcs = self.navigationController.viewControllers;
    
    NSMutableArray *newVcs = [NSMutableArray array];
    
    for (NSInteger i = 0; i < vcs.count; i++) {
        UIViewController *vc = vcs[i];
        [newVcs addObject:vc];
        if ([vc isKindOfClass:[ChooseTestController class]]
            || [vc isKindOfClass:NSClassFromString(@"MyTestSuperViewController")]) {
            break;
        }
    }

    WaitTestDetailViewController * detailsVc = [WaitTestDetailViewController new];
    detailsVc.test_id = self.model.id;
    [newVcs addObject:detailsVc];
    
    [self.navigationController setViewControllers:newVcs.copy animated:YES];
}

- (NSInteger)testedCount{
    return self.model.recordCnt;//[TestInfoCache loadTestCountWithId:self.model.id];
}

- (NSArray <LZTestInfoModel *>*)testinfos{
    return [TestInfoCache loadTestInfoWithId:self.model.id];
}

- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, 5) actualTime:NULL error:&error];
    int index = 2;
    while (error && index < 10) {
        error = nil;
        index ++;
        img = [generator copyCGImageAtTime:CMTimeMake(index, 5) actualTime:NULL error:&error];
    }
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

@end
