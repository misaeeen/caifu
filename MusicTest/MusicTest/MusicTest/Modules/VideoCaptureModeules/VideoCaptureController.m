//
//  VideoCaptureController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import "VideoCaptureController.h"
#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"
#import "UIDevice+CFDevice.h"
#import "LZAuthorityManager.h"

typedef NS_ENUM(NSUInteger, LZTipsAlignment) { // 提示语位置
    LZTipsAlignmentCenter,
    LZTipsAlignmentLeft,
};

typedef NS_ENUM(NSUInteger, LZConfirmBtnState) { // 确认按钮状态
    LZConfirmBtnStateStart, //开始考试
    LZConfirmBtnStateNextStep, //下一步
    LZConfirmBtnStateReady, //已就位
    LZConfirmBtnStateCaptureReady, // 开始拍摄，播放请考生就位
    LZConfirmBtnStateCaptureStart, // 开始拍摄，开始考试
    LZConfirmBtnStateNext, //下一首
    LZConfirmBtnStateFinish, //考试完成
    LZConfirmBtnStateNone, //不展示
};

static NSString *const PERSON_TIPS_TEXT = @"准备拍摄考生正面视频";
static NSString *const PERSON_TIPS_TEXT1 = @"考生必须保持在画面之内";
//static NSString *const PERSON_TIPS_TEXT2 = @"请考生就演奏位";

//static NSString *const PERSON_TIPS_PLAY_TEXT = @"请考生对准白色引导框就位";
//static NSString *const PERSON_TIPS_PLAY_TEXT1 = @"请考生将乐器对准白色引导框就位";
//static NSString *const PERSON_TIPS_PLAY_TEXT2 = @"请考生就位";
//static NSString *const PERSON_TIPS_PLAY_TEXT3 = @"开始考试";
//static NSString *const PERSON_TIPS_PLAY_TEXT4 = @"考试曲目已切换，请考生注意";


static NSString *const PERSON_TIPS_PLAY_TEXT = @"请考生正对摄像头";
static NSString *const PERSON_TIPS_PLAY_TEXT1 = @"人像已拍摄完毕，点击下一步进行考试视频录制";
static NSString *const PERSON_TIPS_PLAY_TEXT2 = @"请考生参考线框图摆放乐器，并确保考生在拍摄画面内";
static NSString *const PERSON_TIPS_PLAY_TEXT3 = @"考生已就位，开始考试";
static NSString *const PERSON_TIPS_PLAY_TEXT4 = @"开始考试";
static NSString *const PERSON_TIPS_PLAY_TEXT5 = @"请注意，考试曲目已切换，请开始演奏当前曲目";



//请考生对准白色引导框就位    请考生将乐器对准白色引导框就位   请考生就位  开始考试    考试曲目以切换，请考生注意

static CGFloat VIDEO_WIDTH = 1280.0f;
static CGFloat VIDEO_HEIGHT = 720.0f;

@interface VideoCaptureController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,AVSpeechSynthesizerDelegate>


@property (nonatomic, strong) AVCaptureSession     *captureSession;//服务Session

//拍照
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;//设备输入
@property (nonatomic, strong) AVCaptureStillImageOutput  *captureStillImageOutput;//照片输出流
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;//相机拍摄预览图层
//摄像
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;//视频文件输出
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInputAudio;//设备音频输入
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;//音频输出


//写入数据相关
@property (nonatomic, strong) NSURL *videoUrl;//写入文件文件本地URL
@property (nonatomic, strong) AVAssetWriter *writer;//媒体写入对象
@property (nonatomic, strong) AVAssetWriterInput *videoInput;//视频写入
@property (nonatomic, strong) AVAssetWriterInput *audioInput;//音频写入

@property (nonatomic, strong) AVSpeechSynthesizer *avSpeaker; //文本播放

@property (nonatomic, strong) AVSpeechUtterance *utterance;

@property (nonatomic, assign) BOOL isStart;

@property (nonatomic, strong) UIImageView *centerImgV;
@property (nonatomic, strong) UILabel *tipsL;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) LZConfirmBtnState confirmBtnState;

@property (nonatomic, strong) UIView *testInfoBgV;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *subjectL;
@property (nonatomic, strong) UILabel *levelL;
@property (nonatomic, strong) UILabel *songL;
@property (nonatomic, strong) UILabel *timeAndStartL; // 倒计时或者开始考试按钮
@property (nonatomic, strong) UILabel *countDownL;

@property (nonatomic, strong) NSArray *songInfos; //曲目信息

@property (nonatomic, assign) NSInteger index; //曲目下标

@property (nonatomic, strong) UILabel *nextTipsL; // 切换到下一首提示

@property (nonatomic, strong) UIImageView *bgImgV; // 背景图

@property (nonatomic, assign) BOOL isCapture; // 是不是开始了拍摄

//@property (nonatomic, strong) UIImage *userImage; // 用户图片



@end

@implementation VideoCaptureController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(self.avSpeaker.isSpeaking){
        [self.avSpeaker  stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}

// 进入后台状态
- (void)didEnterBackground{
    [self stopRunning];
    self.testinfoModel.isFinish = 0;
    [TestInfoCache saveTestInfoWithModel:self.testinfoModel];
    CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"友情提示" message:@"检测到APP后台运行，为保证公平性，系统自动结束考试"];
    [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
        self.testinfoModel.isFinish = 0;
        [TestInfoCache saveTestInfoWithModel:self.testinfoModel];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = NO;
        [self dismissViewControllerAnimated:NO completion:nil];
    }]];
    
    CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
        if (self.finishBlock != nil) {
            
            self.testinfoModel.isFinish = 0;
            self.testinfoModel.video_path = self.videoUrl.resourceSpecifier;
            [TestInfoCache saveTestInfoWithModel:self.testinfoModel];
            self.finishBlock(self.model,YES);
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.allowRotation = NO;
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
    action.bgColor = ColorWithHex(@"FFCF26");
    [alertV addAction:action];
    [alertV showAlertViewWithController:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupSubviews];

    [self startCaptrue];
    
    [LZAuthorityManager cameraAuthority:^{
        
    } denied:^{
        [self showAlertTitle:@"请在iphone的“设置－隐私－相机”选项中，允许APP访问您的相机。" url:UIApplicationOpenSettingsURLString];
    }];
    [LZAuthorityManager microPhoneAuthority:^{
        
    } denied:^{
        [self showAlertTitle:@"请在iphone的“设置－隐私－麦克风”选项中，允许APP访问您的麦克风。" url:UIApplicationOpenSettingsURLString];
    }];
    
    //进入后台UIApplicationDidEnterBackgroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches  anyObject] locationInView:self.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point {
    
    if ([self.captureDeviceInput.device isFocusPointOfInterestSupported] && [self.captureDeviceInput.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {//用于判断设备是否支持设置区域焦距调节的功能和设备能否实现对自动变焦到合适的焦距（手机前置摄像头是没有焦距调节的）
        
        NSError *error;
//        point = [self.layer captureDevicePointOfInterestForPoint:point];   //转化手指点击区域坐标，设备（摄像头等）的坐标系统和屏幕坐标系统是不一样的，得将屏幕坐标位置做响应改变
        if ([self.captureDeviceInput.device lockForConfiguration:&error]) {  //锁定设备，类似于线程锁一样，是设备只能被一个访问。没有此步，任何对设备的改变都是无法进行的，此方法可以设置，设置成功后返回一个bool值
            
            self.captureDeviceInput.device.focusPointOfInterest = point;    //指定变焦区域
            self.captureDeviceInput.device.focusMode = AVCaptureFocusModeAutoFocus;//设置变焦方式为自动变焦
            [self.captureDeviceInput.device unlockForConfiguration];      //当对设备设置完毕后，需要接触设备锁定
//            NSLog(@"tocus");
        }else {
            
            NSLog(@"%@",[error localizedDescription]);
        }
    }
}
- (void)startCaptrue{
    [self.captureSession startRunning];
    self.confirmBtnState = LZConfirmBtnStateStart;
}
- (void)showAlertTitle:(NSString *)title url:(NSString *)url{
    CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"" message:title];
    
    [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
       
    }]];
    
    CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }
        else
        {
            // 去系统设置页面
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        }
    }];
    action.bgColor = ColorWithHex(@"FFCF26");
    [alertV addAction:action];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertV showAlertViewWithController:self.navigationController];
    });
}

- (void)captureTimeout{
    self.countDownL.hidden = NO;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    __block int timeout = 30 * 60 - 1; //倒计时时间
        if (timeout!=0) {
            dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(timer, ^{
                if(timeout < 1){ //倒计时结束，关闭
                    dispatch_source_cancel(timer);
                    dispatch_async(dispatch_get_main_queue(), ^{ // block 回调
                        [self stopRunning];
                        CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"提示" message:@"您的考试时间已超时"];
                        
                        CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                            
                            
                            self.testinfoModel.isFinish = 1;
                            self.testinfoModel.video_path = self.videoUrl.resourceSpecifier;
                            [TestInfoCache saveTestInfoWithModel:self.testinfoModel];
                            self.finishBlock(self.model,YES);
                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            appDelegate.allowRotation = NO;
                            [self dismissViewControllerAnimated:NO completion:nil];
                        }];
                        action.bgColor = ColorWithHex(@"FFCF26");
                        [alertV addAction:action];
                        [alertV showAlertViewWithController:self];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //分钟
                        NSInteger minute = timeout / 60;
                        NSInteger second = timeout % 60;
                
                        self.countDownL.text = [NSString stringWithFormat:@"考试剩余时间:%zd分%zd秒",minute,second];
                    });
                    timeout--;
                }
            });
            dispatch_resume(timer);
        }
}
- (void)_setupSubviews{
    [self.view.layer addSublayer:self.previewLayer];

    UIImageView *centerImgV = [[UIImageView alloc] init];
    centerImgV.image = [UIImage imageNamed:@"person_border"];
    [self.view addSubview:centerImgV];
    self.centerImgV = centerImgV;

    UILabel *tipsL = [[UILabel alloc] init];
    tipsL.textColor = ColorWithHex(@"#FFCF26");
    tipsL.font = FontWithSize(12.0f);
    [self.view addSubview:tipsL];
    self.tipsL = tipsL;

    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    stopBtn.layer.borderWidth = 0.5f;
    stopBtn.layer.cornerRadius = 12.0f;
    [stopBtn setTitle:@"放弃本次录制" forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    stopBtn.titleLabel.font = FontWithSize(12.0f);
    [stopBtn addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    self.stopBtn = stopBtn;

    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitleColor:ColorWithHex(@"#333333") forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 40.0f;
    confirmBtn.backgroundColor = ColorWithHex(@"#FFCF26");
    confirmBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    confirmBtn.titleLabel.font = FontWithSize(12.0f);
    confirmBtn.layer.borderWidth = 5.0f;
    [self.view addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    
    
    UIView *testInfoBgV = [[UIView alloc] init];
    testInfoBgV.hidden = YES;
    testInfoBgV.layer.cornerRadius = 4.0f;
    testInfoBgV.backgroundColor = [ColorWithHex(@"#464646") colorWithAlphaComponent:0.6f];
    [self.view addSubview:testInfoBgV];
    self.testInfoBgV = testInfoBgV;
    
    UILabel *nameL = [UILabel createWithColor:[UIColor whiteColor] font:FontWithSize(12.0f)];
    [testInfoBgV addSubview:nameL];
    self.nameL = nameL;
    
    UILabel *subjectL = [UILabel createWithColor:[UIColor whiteColor] font:FontWithSize(12.0f)];
    [testInfoBgV addSubview:subjectL];
    self.subjectL = subjectL;
    
    UILabel *levelL = [UILabel createWithColor:[UIColor whiteColor] font:FontWithSize(12.0f)];
    [testInfoBgV addSubview:levelL];
    self.levelL = levelL;
    
    UILabel *songL = [UILabel createWithColor:ColorWithHex(@"#FFCF26") font:FontWithSize(12.0f)];
    songL.numberOfLines = 0;
    [testInfoBgV addSubview:songL];
    self.songL = songL;
    
    UILabel *timeAndStartL = [UILabel createWithColor:ColorWithHex(@"#FFCF26") font:FontWithSize(20.0f)];
    timeAndStartL.hidden = YES;
    [self.view addSubview:timeAndStartL];
    self.timeAndStartL = timeAndStartL;
    
    UILabel *nextTipsL = [UILabel createWithColor:ColorWithHex(@"#333333") font:FontWithSize(15.0f)];
    nextTipsL.backgroundColor = ColorWithHex(@"#FFF183");
    nextTipsL.text = @"当前曲目已变更，请提示考生当前曲目名";
    nextTipsL.textAlignment = NSTextAlignmentCenter;
    nextTipsL.hidden = YES;
    [self.view addSubview:nextTipsL];
    self.nextTipsL = nextTipsL;
    
    UILabel *countDownL = [UILabel createWithColor:ColorWithHex(@"#FFCF26") font:FontWithSize(12.0f)];
    countDownL.text = @"考试剩余时间:29分59秒";
    countDownL.hidden = YES;
    [self.view addSubview:countDownL];
    self.countDownL = countDownL;
    
    
    [countDownL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(28.0f);
    }];
    
    [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24.0f);
        make.right.offset(-16.0f);
        make.height.offset(24.0f);
        make.width.offset(95.0f);
    }];

    [centerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.offset(185.0f);
        make.height.offset(313.0f);
    }];

    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(80.0f);
            make.right.offset(-23.5f);
            make.bottom.offset(-32.5f);
    }];
    
    [testInfoBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16.0f);
        make.width.offset(166.0f);
        make.centerY.equalTo(self.view);
    }];
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.0f);
        make.top.offset(13.0f);
        make.right.offset(-14.0f);
    }];
    
    [subjectL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.0f);
        make.top.equalTo(nameL.mas_bottom).offset(8.0f);
        make.right.offset(-14.0f);
    }];
    
    [levelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.0f);
        make.top.equalTo(subjectL.mas_bottom).offset(8.0f);
        make.right.offset(-14.0f);
    }];
    
    [songL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.0f);
        make.top.equalTo(levelL.mas_bottom).offset(8.0f);
        make.right.offset(-14.0f);
        make.bottom.offset(-13.0f);
    }];
    
    [timeAndStartL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsL.mas_bottom).offset(28.0f);
        make.centerX.equalTo(self.view);
    }];
    
    [nextTipsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0.0f);
        make.height.offset(38.0f);
    }];
    
//    UIImage *image = [self getBackgoundImage];
//    if (image != nil) {
//        UIImageView *bgImgV = [[UIImageView alloc] init];
//        bgImgV.userInteractionEnabled = YES;
//        bgImgV.image = image;
//        [self.view addSubview:bgImgV];
//        self.bgImgV = bgImgV;
//
//        [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.bottom.offset(0.0f);
//        }];
//        UIButton *hideBgImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [hideBgImgBtn addTarget:self action:@selector(hideBgImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [hideBgImgBtn setTitleColor:ColorWithHex(@"#333333") forState:UIControlStateNormal];
//        [hideBgImgBtn setTitle:@"下一步" forState:UIControlStateNormal];
//        hideBgImgBtn.layer.cornerRadius = 40.0f;
//        hideBgImgBtn.backgroundColor = ColorWithHex(@"#FFCF26");
//        hideBgImgBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        hideBgImgBtn.titleLabel.font = FontWithSize(12.0f);
//        hideBgImgBtn.layer.borderWidth = 5.0f;
//        [bgImgV addSubview:hideBgImgBtn];
//        [hideBgImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.offset(80.0f);
//            make.right.offset(-23.5f);
//            make.bottom.offset(-32.5f);
//        }];
//    }else{
//        [self startRunning];
//    }
}
- (void)hideBgImgBtnClick{
    [self.bgImgV removeFromSuperview];
    self.bgImgV = nil;
    
    [self startRunning];
}
- (UIImage *)getBackgoundImage{
    NSString *imageNamed;
    if ([self.model.subject isEqual:@"木琴及马林巴琴"]) {
        imageNamed = @"马林巴_背景";
    }else if ([self.model.subject isEqual:@"爵士鼓"]) {
        imageNamed = @"爵士鼓_背景";
    }else if ([self.model.subject isEqual:@"电爵士鼓"]) {
        imageNamed = @"爵士鼓_背景";
    }else if ([self.model.subject isEqual:@"小军鼓"]) {
        imageNamed = @"小军鼓_背景";
    }
    return [UIImage imageNamed:imageNamed];
}



- (void)confirmBtnClick{
    switch (self.confirmBtnState) {
        case LZConfirmBtnStateStart:
            self.confirmBtnState = LZConfirmBtnStateNextStep;
            break;
        case LZConfirmBtnStateNextStep:
            self.confirmBtnState = LZConfirmBtnStateReady;
            break;
        case LZConfirmBtnStateReady:
            self.confirmBtnState = LZConfirmBtnStateCaptureReady;
            break;
        case LZConfirmBtnStateCaptureReady:
            self.confirmBtnState = LZConfirmBtnStateCaptureStart;
            break;
        case LZConfirmBtnStateCaptureStart:
            self.confirmBtnState = LZConfirmBtnStateNext;
            break;
        case LZConfirmBtnStateNext:
        {
            if (self.index == self.songInfos.count - 1) {
                self.confirmBtnState = LZConfirmBtnStateFinish;
            }else{
                self.confirmBtnState = LZConfirmBtnStateNext;
                if(self.avSpeaker.isSpeaking){
                    [self.avSpeaker stopSpeakingAtBoundary:AVSpeechBoundaryWord];
                }
                [self.avSpeaker speakUtterance:[self getSpeechUtteranceWithText:PERSON_TIPS_PLAY_TEXT5]];
                self.nextTipsL.hidden = NO;
                [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(hideNextTipsL) userInfo:nil repeats:NO];
            }
        }
            break;
        case LZConfirmBtnStateFinish:{
            NSString *title = @"是否确认已完成本次机会的所有考试曲目？确认后，将完成本次考试机会.";
            CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"" message:title];
            
            [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
               
            }]];
            
            CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                if (self.finishBlock != nil) {
                    
                    
                    self.testinfoModel.isFinish = 1;
                    self.testinfoModel.video_path = self.videoUrl.resourceSpecifier;
                    [TestInfoCache saveTestInfoWithModel:self.testinfoModel];
                    
                    self.finishBlock(self.model,YES);
                    [self stopRunning];
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    appDelegate.allowRotation = NO;
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
            }];
            action.bgColor = ColorWithHex(@"FFCF26");
            [alertV addAction:action];
            [alertV showAlertViewWithController:self];
        }
            break;
        default:
            break;
    }
}


- (void)hideNextTipsL{
    self.nextTipsL.hidden = YES;
}

- (void)backPage{
    kWeakSelf;
    CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"友情提示！" message:@"您尚未完成考试，退出将消耗一次考试机会，是否确认退出？"];
    
    [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
       
    }]];
    
    CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
        
        self.testinfoModel.isFinish = 0;
        if(self.isStart){
            self.testinfoModel.video_path = self.videoUrl.resourceSpecifier;
        }
        [TestInfoCache saveTestInfoWithModel:self.testinfoModel];
        weakSelf.finishBlock(weakSelf.model,YES);
        [weakSelf stopRunning];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = NO;
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    action.bgColor = ColorWithHex(@"FFCF26");
    [alertV addAction:action];
    [alertV showAlertViewWithController:self];
}
//启动
- (void)startRunning{
    self.isStart = YES;
    self.isCapture = YES;
}

//关闭
- (void)stopRunning{

    if(self.isStart){
        self.isStart = NO;
        if (self.captureSession) {
                [self.captureSession stopRunning];
            }
            [self.videoInput markAsFinished];
            [self.audioInput markAsFinished];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.writer finishWritingWithCompletionHandler:^{
                    self.writer = nil;
                }];
            });
    }
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
//    CMSampleBufferRef sampleBuffer1 = NULL;
    if (captureOutput == self.videoOutput) {

        AVCaptureConnection *videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        
        if ([videoConnection isVideoOrientationSupported]){

            [videoConnection setVideoOrientation:(AVCaptureVideoOrientation)[UIApplication sharedApplication].statusBarOrientation];
        }
        //代理
        //        if ([self.cameraToolDelegate respondsToSelector:@selector(getVideoImage:)]&&self.isGetImage==YES) {
        if(self.isStart){
//            sampleBuffer1 = [self imageFromSampleBuffer:sampleBuffer];

            dispatch_async(dispatch_get_main_queue(), ^{

                //                [self.cameraToolDelegate getVideoImage:image];
            });
        }

        //        }
    }
    static int frame = 0;

    @synchronized(self) {

        if( frame == 0 && self.writer.status == AVAssetWriterStatusUnknown && self.isStart == YES)
        {
            AVCaptureConnection *videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];

            NSDictionary *settings;

            if ([videoConnection isVideoOrientationSupported]){

                [videoConnection setVideoOrientation:(AVCaptureVideoOrientation)[UIApplication sharedApplication].statusBarOrientation];
            }
//            if (videoConnection.videoOrientation == AVCaptureVideoOrientationPortrait) {

                settings = [NSDictionary dictionaryWithObjectsAndKeys:
                            AVVideoCodecH264, AVVideoCodecKey,
                            [NSNumber numberWithInteger: VIDEO_WIDTH], AVVideoWidthKey,
                            [NSNumber numberWithInteger: VIDEO_HEIGHT], AVVideoHeightKey,
                            nil];
//            }
//            else{
//
//                settings = [NSDictionary dictionaryWithObjectsAndKeys:
//                            AVVideoCodecH264, AVVideoCodecKey,
//                            [NSNumber numberWithInteger: VIDEO_HEIGHT], AVVideoWidthKey,
//                            [NSNumber numberWithInteger: VIDEO_WIDTH], AVVideoHeightKey,
//                            nil];
//            }
            self.videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
            
            self.videoInput.expectsMediaDataInRealTime = YES;

            [self.captureSession beginConfiguration];

            //视频数据输入
            if ([self.writer canAddInput:self.videoInput]) {

                [self.writer addInput:self.videoInput];
            }
            //音频数据输入
            if ([self.writer canAddInput:self.audioInput]) {

                [self.writer addInput:self.audioInput];
            }
            [self.captureSession commitConfiguration];

            CMTime lastSampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);

            [self.writer startWriting];

            [self.writer startSessionAtSourceTime:lastSampleTime];

            NSLog(@"写入数据");
        }
        //写入失败
        if (self.writer.status == AVAssetWriterStatusFailed) {

            NSLog(@"%@",self.writer.error.localizedDescription);
        }
        if (self.isStart == YES) {
            if (captureOutput == self.videoOutput) {

                if ([self.videoInput isReadyForMoreMediaData]) {
                    NSLog(@"视频拼接");
                    //拼接视频数据
                    [self.videoInput appendSampleBuffer:sampleBuffer];
//                    [self cameraBackgroundDidChangeZoom];
                }
            }
            if (captureOutput == self.audioOutput) {

                if ([self.audioInput isReadyForMoreMediaData]){
                    NSLog(@"--音频拼接");
                    //拼接音频数据
                    [self.audioInput appendSampleBuffer:sampleBuffer];
                }
            }
        }
    }
    
}





/*管理拍照和视频会话*/
- (AVCaptureSession *)captureSession{
    
    if (!_captureSession) {
        
        _captureSession = [[AVCaptureSession alloc]init];
        
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;//默认输出分辨率
        
        //摄像头设备输入
        if ([_captureSession canAddInput:self.captureDeviceInput]) {
            
            [_captureSession addInput:self.captureDeviceInput];
        }
        //麦克风音频设备输入
        if ([_captureSession canAddInput:self.captureDeviceInputAudio]) {
            
            [_captureSession addInput:self.captureDeviceInputAudio];
        }
        //视频数据输出
        if ([_captureSession canAddOutput:self.videoOutput]) {
            [_captureSession addOutput:self.videoOutput];
        }
        //音频数据输出
        if ([_captureSession canAddOutput:self.audioOutput]) {
            [_captureSession addOutput:self.audioOutput];
        }
        
    }
    return _captureSession;
}

/*设备输入类*/
- (AVCaptureDeviceInput *)captureDeviceInput{
    
    if (!_captureDeviceInput) {
        
//        AVCaptureDevice *captureDevice =[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
        int frameRate = 60;
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            for(AVCaptureDeviceFormat *vFormat in [captureDevice formats] ) {
                CMFormatDescriptionRef description= vFormat.formatDescription;
                float maxRate = ((AVFrameRateRange*) [vFormat.videoSupportedFrameRateRanges objectAtIndex:0]).maxFrameRate;
                if (maxRate > frameRate - 1 &&
                    CMFormatDescriptionGetMediaSubType(description)==kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
                    if ([captureDevice lockForConfiguration:nil]) {
//                        NSLog(@"%@-----%@",@(maxRate),@(frameRate));
                        captureDevice.activeFormat = vFormat;
                        [captureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, frameRate)];
                        [captureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1, frameRate)];
                        [captureDevice unlockForConfiguration];
                        break;
                    }
                }
            }
        
        
        _captureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:nil];
        
    }
    return _captureDeviceInput;
}

/*音频设备输入*/
- (AVCaptureDeviceInput *)captureDeviceInputAudio{
    
    if (!_captureDeviceInputAudio) {
        
        AVCaptureDevice *deviceAudio = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        
        _captureDeviceInputAudio = [AVCaptureDeviceInput deviceInputWithDevice:deviceAudio error:nil];
    }
    return _captureDeviceInputAudio;
}

/*视频数据输出*/
- (AVCaptureVideoDataOutput *)videoOutput{
   
    if (!_videoOutput) {
        
        _videoOutput = [[AVCaptureVideoDataOutput alloc]init];
        
        _videoOutput.alwaysDiscardsLateVideoFrames = YES;
      
        [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        _videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA],kCVPixelBufferPixelFormatTypeKey,nil];
    }
    return _videoOutput;
}

/*音频写入类*/
- (AVAssetWriterInput *)audioInput{
    
    if (!_audioInput) {
        
        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                  [ NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                  [ NSNumber numberWithFloat: 44100], AVSampleRateKey,
                                  [ NSNumber numberWithInt: 128000], AVEncoderBitRateKey,
                                  nil];
        _audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
        
        _audioInput.expectsMediaDataInRealTime = YES;
    }
    return _audioInput;
}
/*音频数据数据输出*/
- (AVCaptureAudioDataOutput *)audioOutput{
    
    if (!_audioOutput) {
        
        _audioOutput = [[AVCaptureAudioDataOutput alloc]init];
        
        [_audioOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    }
    return _audioOutput;
}

/*视频写入类*/
- (AVAssetWriter *)writer{
    
    if (!_writer) {
        
        _writer = [AVAssetWriter assetWriterWithURL:self.videoUrl fileType:AVFileTypeQuickTimeMovie error:nil];
        
        _writer.shouldOptimizeForNetworkUse = YES;
    }
    
    return _writer;
}

/*视频本地url路径*/
- (NSURL *)videoUrl{
    if (!_videoUrl) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *filePath = [NSString stringWithFormat:@"%@.mov",[self getNowTimeTimestamp]];
        NSString *videooPath = [path stringByAppendingPathComponent:filePath];
        _videoUrl = [NSURL fileURLWithPath:videooPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:videooPath]){
            [[NSFileManager defaultManager] removeItemAtPath:videooPath error:nil];
        }
    }
    return _videoUrl;
}

// 获取当前时间戳
- (NSString *)getNowTimeTimestamp{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
/** 后置摄像头*/
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if(!_previewLayer){
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    }
    return _previewLayer;
}

- (AVSpeechSynthesizer *)avSpeaker{
    if (!_avSpeaker) {
        _avSpeaker = [[AVSpeechSynthesizer alloc] init];
        _avSpeaker.delegate = self;
    }
    return _avSpeaker;
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    self.previewLayer.frame = CGRectMake( 0, 0, SCREEN_HEIGHT, SCREEN_WDITH);
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI_2);
    self.previewLayer.affineTransform = transform;//旋转
    self.previewLayer.frame = CGRectMake( 0, 0, SCREEN_WDITH, SCREEN_HEIGHT);
}

- (AVSpeechUtterance *)getSpeechUtteranceWithText:(NSString *)text{
    self.utterance = [[AVSpeechUtterance alloc] initWithString:text];
    //设置语速
    self.utterance.rate = 0.51f;
    self.utterance.volume = 1;
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    self.utterance.voice = voice;
    return self.utterance;
}


- (void)setConfirmBtnState:(LZConfirmBtnState)confirmBtnState{
    LZTipsAlignment alignment = LZTipsAlignmentLeft;
    _confirmBtnState = confirmBtnState;
    switch (confirmBtnState) {
        case LZConfirmBtnStateStart:
        {
            self.confirmBtn.hidden = NO;
            [self.confirmBtn setTitle:@"开始考试" forState:UIControlStateNormal];
            alignment = LZTipsAlignmentCenter;
            self.tipsL.text = PERSON_TIPS_TEXT;
        }
            break;
        case LZConfirmBtnStateNextStep:
        {
            [self startRunning];
            self.confirmBtn.hidden = YES;
            [self.confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
            alignment = LZTipsAlignmentCenter;
            self.tipsL.text = PERSON_TIPS_TEXT;
            [self.avSpeaker speakUtterance:[self getSpeechUtteranceWithText:PERSON_TIPS_PLAY_TEXT]];
            
            [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(capturePortrait) userInfo:nil repeats:NO];
        }
            break;
        case LZConfirmBtnStateReady:
        {
            self.confirmBtn.hidden = NO;
            [self.confirmBtn setTitle:@"已就位" forState:UIControlStateNormal];
            alignment = LZTipsAlignmentLeft;
            self.tipsL.text = PERSON_TIPS_TEXT1;
            UIImage *image =  [self musicalImage];
            self.centerImgV.image = image;
            if ([self.model.subject isEqual:@"小军鼓"] || [self.model.subject isEqual:@"中国鼓"]) {
                [self.centerImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.view);
                    make.width.offset(image.size.width * 0.5f);
                    make.height.offset(image.size.height * 0.5f);
                    make.bottom.offset(-20.0f);
                }];
            }else{
                [self.centerImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.view);
                    make.width.offset(image.size.width * 0.5f);
                    make.height.offset(image.size.height * 0.5f);
                }];
            }
            
            
            if(self.avSpeaker.isSpeaking){
                [self.avSpeaker stopSpeakingAtBoundary:AVSpeechBoundaryWord];
            }
            [self.avSpeaker speakUtterance:[self getSpeechUtteranceWithText:PERSON_TIPS_PLAY_TEXT2]];
        }
            break;
        case LZConfirmBtnStateCaptureReady:
        {
            self.confirmBtn.hidden = YES;
            alignment = LZTipsAlignmentCenter;
            self.tipsL.text = PERSON_TIPS_TEXT;
            if(self.avSpeaker.isSpeaking){
                [self.avSpeaker stopSpeakingAtBoundary:AVSpeechBoundaryWord];
            }
            self.timeAndStartL.hidden = NO;
            
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
            
        }
            break;
        case LZConfirmBtnStateCaptureStart:
        {
            [self testedStart];
            alignment = LZTipsAlignmentLeft;
            self.tipsL.text = PERSON_TIPS_TEXT1;
            if(self.avSpeaker.isSpeaking){
                [self.avSpeaker stopSpeakingAtBoundary:AVSpeechBoundaryWord];
            }
            self.timeAndStartL.text = @"开始演奏!";
            [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(hideTimeAndStartL) userInfo:nil repeats:NO];
            self.testInfoBgV.hidden = NO;
            [self.avSpeaker speakUtterance:[self getSpeechUtteranceWithText:PERSON_TIPS_PLAY_TEXT4]];
        }
            break;
        case LZConfirmBtnStateNext:
        {
            alignment = LZTipsAlignmentLeft;
            self.tipsL.text = PERSON_TIPS_TEXT1;
            [self testedNext];
        }
            break;
        case LZConfirmBtnStateFinish:
        {
            self.confirmBtn.hidden = NO;
            [self.confirmBtn setTitle:@"考试完成" forState:UIControlStateNormal];
        }
            break;
        case LZConfirmBtnStateNone:
        {
            self.confirmBtn.hidden = YES;
            [self.confirmBtn setTitle:@"" forState:UIControlStateNormal];
        }
            break;

        default:
            break;
    }


    if (alignment == LZTipsAlignmentCenter) {
        [self.tipsL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.offset(28.0f);
        }];
    }else if(alignment == LZTipsAlignmentLeft){
        [self.tipsL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(16.0f);
            make.top.offset(28.0f);
        }];
    }
}

/// 截图用户正面完成
- (void)capturePortrait{
    [self.avSpeaker speakUtterance:[self getSpeechUtteranceWithText:PERSON_TIPS_PLAY_TEXT1]];
    self.confirmBtn.hidden = NO;
}

- (void)delayMethod{
    [self countDown];
    [self.avSpeaker speakUtterance:[self getSpeechUtteranceWithText:PERSON_TIPS_PLAY_TEXT3]];
}

- (void)testedStart{
    self.index = -1;
    if (self.songInfos.count == 1) {
        self.confirmBtnState = LZConfirmBtnStateFinish;
    }else{
        self.confirmBtnState = LZConfirmBtnStateNext;
    }
    self.nameL.text = [NSString stringWithFormat:@"考生姓名：%@",self.model.profile.name];
    self.subjectL.text = [NSString stringWithFormat:@"科目：%@",self.model.subject];
    self.levelL.text = [NSString stringWithFormat:@"级别：%@",self.model.level];
}
- (void)testedNext{
    self.index ++;
    if(self.index == self.songInfos.count - 1){
        self.confirmBtnState = LZConfirmBtnStateFinish;
    }else{
        self.confirmBtn.hidden = NO;
        [self.confirmBtn setTitle:@"下一首" forState:UIControlStateNormal];
    }
    self.songL.text = [NSString stringWithFormat:@"当前曲目：\n%@",self.songInfos[self.index]];
}

- (NSArray *)songInfos{
    if (!_songInfos) {
        _songInfos = [self.model.chapter componentsSeparatedByString:@","];
    }
    return _songInfos;
}

- (void)hideTimeAndStartL{
    self.timeAndStartL.hidden = YES;
    [self captureTimeout];
}
// 开始考试之前倒计时10秒
- (void)countDown{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    __block int timeout = 5; //倒计时时间
        if (timeout!=0) {
            dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(timer, ^{
                if(timeout < 1){ //倒计时结束，关闭
                    dispatch_source_cancel(timer);
                    dispatch_async(dispatch_get_main_queue(), ^{ // block 回调
                        self.confirmBtnState = LZConfirmBtnStateCaptureStart;
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.timeAndStartL.text = [NSString stringWithFormat:@"%d秒",timeout];
                    });
                    timeout--;
                }
            });
            dispatch_resume(timer);
        }
}

- (UIImage *)musicalImage{
    NSString *imageNamed;
    if ([self.model.subject isEqual:@"电贝司"]) {
        imageNamed = @"电贝司";
    }else if ([self.model.subject isEqual:@"电吉他"]) {
        imageNamed = @"电吉他";
    }else if ([self.model.subject isEqual:@"定音鼓"]) {
        imageNamed = @"定音鼓";
    }else if ([self.model.subject isEqual:@"木琴及马林巴琴"]) {
        imageNamed = @"马林巴";
    }else if ([self.model.subject isEqual:@"非洲鼓"]) {
        imageNamed = @"非洲鼓";
    }else if ([self.model.subject isEqual:@"爵士鼓"]) {
        imageNamed = @"电爵士鼓";
    }else if ([self.model.subject isEqual:@"拉丁打击乐"]) {
        imageNamed = @"拉丁打击乐";
    }else if ([self.model.subject isEqual:@"电爵士鼓"]) {
        imageNamed = @"电爵士鼓";
    }else if ([self.model.subject isEqual:@"小军鼓"]) {
        imageNamed = @"小军鼓";
    }else if ([self.model.subject isEqual:@"中国鼓"]) {
        imageNamed = @"中国鼓";
    }
    return [UIImage imageNamed:imageNamed];
}


#pragma mark - - orientation
//设置是否允许自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}

//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskLandscapeLeft;
}
//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationLandscapeLeft;
}


@end

