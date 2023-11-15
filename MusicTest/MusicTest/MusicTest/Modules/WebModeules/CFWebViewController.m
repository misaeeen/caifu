//
//  CFWebViewController.m
//  zbt
//
//  Created by 伍鹏 on 2018/3/26.
//  Copyright © 2018年 Caifu. All rights reserved.
//

#import "CFWebViewController.h"
#import "VideoCaptureController.h"
#import "TestFormalViewController.h"
#import "LZTestNetworkAPI.h"
#import "LZUserManger.h"
#import <WebKit/WebKit.h>

@interface CFWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)UIProgressView *progressView;


@property (nonatomic, strong) NSArray *testUrls;
@property (nonatomic, assign) NSInteger testPageIndex;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *agreeProtocolV;
@property (nonatomic, strong) UIButton *agreeProtocolBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation CFWebViewController


- (NSArray *)testUrls{
    if (!_testUrls) {
        _testUrls = @[
            BEFORE_EXAMINATION_URL,
            SHOOTING_CONDITIONS_URL
        ];
    }
    return _testUrls;
}
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor whiteColor];
        _footerView.hidden = YES;
        
        [_footerView addSubview:self.agreeProtocolV];
        [_footerView addSubview:self.confirmBtn];
        [self.agreeProtocolV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0.0f);
            make.height.offset(34.0f);
        }];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-StatusBarHeight + 10.0f);
            make.left.offset(16.0f);
            make.right.offset(-16.0f);
            make.height.offset(36.0f);
        }];
    }
    return _footerView;
}

- (UIView *)agreeProtocolV{
    if (!_agreeProtocolV) {
        _agreeProtocolV = [[UIView alloc] init];
        _agreeProtocolV.hidden = YES;
        [_agreeProtocolV addSubview:self.agreeProtocolBtn];
        
        UIButton *protocolBtn = [UIButton createButtonWithTitleColor:ColorWithHex(@"#333333") font:BoldFontWithSize(13.0f)];
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"考生承诺书"];
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        [protocolBtn setAttributedTitle:tncString forState:UIControlStateNormal];
        [[protocolBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            CFWebViewController *webV = [[CFWebViewController alloc] init];
            webV.url = LETTER_OF_COMMITMENT_URL;
            webV.titleStr = @"考生承诺书";
            [self.navigationController pushViewController:webV animated:YES];
        }];
        [_agreeProtocolV addSubview:protocolBtn];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.font = FontWithSize(13.0f);
        lab.textColor = ColorWithHex(@"#333333");
        lab.text = @"和";
        [_agreeProtocolV addSubview:lab];
        
        UIButton *procedureDescBtn = [UIButton createButtonWithTitleColor:ColorWithHex(@"#333333") font:BoldFontWithSize(13.0f)];
        NSMutableAttributedString* tncString1 = [[NSMutableAttributedString alloc] initWithString:@"流程介绍"];
        [tncString1 addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString1 length]}];
        [procedureDescBtn setAttributedTitle:tncString1 forState:UIControlStateNormal];
        [[procedureDescBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            CFWebViewController *webV = [[CFWebViewController alloc] init];
            webV.url = [NSString stringWithFormat:@"%@?token=%@",PROCESS_INTRODUCTION_URL,[LZUserManger authorization]];
            webV.titleStr = @"流程介绍";
            [self.navigationController pushViewController:webV animated:YES];
        }];
        [_agreeProtocolV addSubview:procedureDescBtn];
        
        [self.agreeProtocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(16.0f);
            make.top.offset(8.0f);
            make.bottom.offset(-8.0f);
        }];
        [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.agreeProtocolBtn.mas_right).offset(5.0f);
            make.centerY.equalTo(self.agreeProtocolBtn.mas_centerY);
        }];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(protocolBtn.mas_right).offset(5.0f);
            make.centerY.equalTo(self.agreeProtocolBtn.mas_centerY);
        }];
        [procedureDescBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab.mas_right).offset(5.0f);
            make.centerY.equalTo(self.agreeProtocolBtn.mas_centerY);
        }];
    }
    return _agreeProtocolV;
}

- (UIButton *)agreeProtocolBtn{
    if (!_agreeProtocolBtn) {
        _agreeProtocolBtn = [UIButton createButtonWithTitleColor:ColorWithHex(@"#333333") font:FontWithSize(13.0f)];
        [_agreeProtocolBtn setImage:[UIImage imageNamed:@"icon_selected_not"] forState:UIControlStateNormal];
        [_agreeProtocolBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
        [_agreeProtocolBtn setTitle:@"  我已阅读并同意" forState:UIControlStateNormal];
        [[_agreeProtocolBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            x.selected = !x.selected;
        }];
    }
    return _agreeProtocolBtn;
}


- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton createButtonWithTitleColor:ColorWithHex(@"#999999") font:FontWithSize(13.0f)];
        _confirmBtn.layer.cornerRadius = 4.0f;
        _confirmBtn.backgroundColor = ColorWithHex(@"#DEDEDE");
        _confirmBtn.userInteractionEnabled = NO;
        [_confirmBtn setTitle:@"开始考级录制" forState:UIControlStateNormal];
//        kWeakSelf;
        [[_confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.testPageIndex == 0) {
                
                if (self.agreeProtocolBtn.selected) {
                    self.titleStr = @"拍摄须知";
                    self.title = self.titleStr;
                    self.testPageIndex = 1;
                    self.footerView.hidden = YES;
                    self.agreeProtocolV.hidden = YES;
                    self.confirmBtn.backgroundColor = ColorWithHex(@"#DEDEDE");
                    [self.confirmBtn setTitleColor:ColorWithHex(@"#999999") forState:UIControlStateNormal];
                    self.confirmBtn.userInteractionEnabled = NO;
                    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.bottom.right.offset(0.0f);
                        make.height.offset(0.0f);
                    }];
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.testUrls[self.testPageIndex]]]];
                }else{
                    [MBProgressHUD showError:@"请先勾选我已阅读并同意 考生承诺书" ToView:self.view];
                }
            }else if (self.testPageIndex == 1) {
                
                if(self.model.isSimulation){
                    [TestInfoCache removeCacheWithId:self.model.id];
                    LZTestInfoModel *testInfoModel = [[LZTestInfoModel alloc] init];
                    testInfoModel.test_id = self.model.id;
                    testInfoModel.testedCount = 1;
                    [TestInfoCache saveTestInfoWithModel:testInfoModel];
                    VideoCaptureController *vc = [[VideoCaptureController alloc] init];
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    self.model.recordCnt = 1;
                    vc.model = self.model;
                    vc.testinfoModel = testInfoModel;
                    kWeakSelf;
                    [vc setFinishBlock:^(LZTestDetailsModel *model, BOOL finished) {
                        
                        NSMutableArray *vcs = weakSelf.navigationController.viewControllers.mutableCopy;
                        
                        for (NSInteger i = 0; i < vcs.count; i ++) {
                            UIViewController *vc = vcs[i];
                            if ([vc isKindOfClass:weakSelf.class]) {
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
                    
                    CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"友情提示" message:@"点击确认将进入考试，并消耗一次考试机会。"];
                    
                    [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
                        
                    }]];
                    
                    CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                        [LZTestNetworkAPI testCountWithId:self.model.id block:^(LZNetworkResult *result, NSError *error) {
                            if (!error) {
                                if (result.isSuccess) {
                                    NSInteger testedCount = [result.data integerValue];
                                    if (testedCount == 0) {
                                        [TestInfoCache removeCacheWithId:self.model.id];
                                    }
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
                                                if ([vc isKindOfClass:TestFormalViewController.class] || [vc isKindOfClass:weakSelf.class]/* ||
                                                    ([vc isKindOfClass: NSClassFromString(@"OnlineTestConfigInfoController")] && model.recordCnt >= 2)*/) {
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
                    }];
                    action.bgColor = ColorWithHex(@"FFCF26");
                    [alertV addAction:action];
                    [alertV showAlertViewWithController:self.navigationController];
                    
                }
            }
        }];
    }
    return _confirmBtn;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    [self setSubviews];
    if (self.model) {
        self.testPageIndex = 0;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.testUrls[self.testPageIndex]]]];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick)];
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
    self.navigationItem.leftBarButtonItems = @[returnBtn,closeBtn];
}
//-(void)returnClick{
//    if (self.webView.canGoBack) {
//        [self.webView goBack];
//    }else{
//        [self closeClick];
//    }
//}
//-(void)closeClick{
//    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)setSubviews{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0.0f);
        make.height.offset(0.0f);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0.0f);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0.0f);
        make.height.offset(2.0f);
    }];

}

- (void)countDown{
    kWeakSelf;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    __block int timeout = 5; //倒计时时间
        if (timeout!=0) {
            dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(timer, ^{
                if(timeout < 1){ //倒计时结束，关闭
                    dispatch_source_cancel(timer);
                    dispatch_async(dispatch_get_main_queue(), ^{ // block 回调
                        if(weakSelf.testPageIndex == 1){
                            [weakSelf.confirmBtn setTitle:@"开始考级" forState:UIControlStateNormal];
                        }else{
                            [weakSelf.confirmBtn setTitle:@"开始考级录制" forState:UIControlStateNormal];
                        }
                        
                        weakSelf.confirmBtn.backgroundColor = ColorWithHex(@"#FFE300");
                        [weakSelf.confirmBtn setTitleColor:ColorWithHex(@"#333333") forState:UIControlStateNormal];
                        weakSelf.confirmBtn.userInteractionEnabled = YES;
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(weakSelf.testPageIndex == 1){
                            [weakSelf.confirmBtn setTitle:[NSString stringWithFormat:@"开始考级 (%d)S",timeout] forState:UIControlStateNormal];
                        }else{
                            [weakSelf.confirmBtn setTitle:[NSString stringWithFormat:@"开始考级录制 (%d)S",timeout] forState:UIControlStateNormal];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(timer);
        }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (self.model) {
        self.footerView.hidden = NO;
        
        if (self.testPageIndex == 0) {
            self.agreeProtocolV.hidden = NO;
            [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.offset(0.0f);
                make.height.offset(StatusBarHeight - 10.0f + 82.0f);
            }];
            [self countDown];
        }else{
            [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.offset(0.0f);
                make.height.offset(StatusBarHeight - 10.0f + 46.0f);
            }];
            [self countDown];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            if(self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }
        else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    else if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView) {
//            self.title = self.webView.title;
        }
        else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"温馨提示" message:message];
    
    [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    
    CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    action.bgColor = ColorWithHex(@"FFCF26");
    [alertV addAction:action];
    [alertV showAlertViewWithController:self.navigationController];
    
    
}
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"温馨提示" message:message];
    
    CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
        completionHandler();
    }];
    action.bgColor = ColorWithHex(@"FFCF26");
    [alertV addAction:action];
    [alertV showAlertViewWithController:self.navigationController];
}
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    completionHandler(defaultText);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


-(WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc]init];
        // 视频页面播放支持
        webViewConfig.allowsInlineMediaPlayback = YES;
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:webViewConfig];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}
-(UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.progress = 0.0f;
        _progressView.progressTintColor = ColorWithHex(@"#FFCF26");
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.alpha = 0.0f;
    }
    return _progressView;
}
-(void)returnClick{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self closeClick];
    }
}
-(void)closeClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.webView loadHTMLString:@"about:blank" baseURL:nil];
}


@end
