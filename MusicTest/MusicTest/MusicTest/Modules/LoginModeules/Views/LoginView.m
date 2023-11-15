//
//  LoginView.m
//  MusicTest
//
//  Created by LZZ on 2020/11/2.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LoginView.h"
#import "RegisterTextView.h"
#import "LZLoginNetworkAPI.h"
#import "LZUserManger.h"
#import "Aes.h"

//#define fontSize()
@interface LoginView()


@property(nonatomic,strong)RegisterTextView * phoneNumView;
@property(nonatomic,strong)RegisterTextView * codeNumView;
@property(nonatomic,strong)UIButton * sendCodeButton;
@property(nonatomic,strong)UILabel * desLab;
@property(nonatomic,strong)UIButton * LoginButton;

@property(nonatomic,strong)RACDisposable * disposable;
@property(nonatomic,assign)NSInteger time;
@end

@implementation LoginView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initSubview];
    }
    
    return self;
}

-(void)controlEvent{
    __weak typeof(self) weakSelf = self;
    
    //发送验证码
    [[self.sendCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf startTimer];
        [weakSelf sendCode];
     }];
    
    //、登录按钮事件
    self.loginSubject = [RACSubject new];
    [[self.LoginButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf login];
    }];
}


-(void)startTimer{
    __weak typeof(self) weakSelf = self;
    weakSelf.time = 60;
    
    self.sendCodeButton.enabled = NO;
    [self.sendCodeButton setTitleColor:ColorWithHex(@"#AAAAAA") forState:UIControlStateDisabled];
    [self.sendCodeButton setBackgroundColor:ColorWithHex(@"#EEEEEE")];
    
    [self.sendCodeButton setTitle:[NSString stringWithFormat:@"再次发送(%lds)",_time] forState:UIControlStateNormal];
    _disposable = [[RACSignal interval:1 onScheduler:[RACScheduler scheduler]] subscribeNext:^(id x) {
         weakSelf.time--;
        if ( weakSelf.time>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.sendCodeButton setTitle:[NSString stringWithFormat:@"再次发送(%lds)",  weakSelf.time] forState:UIControlStateNormal];
            });
        }else{
            [weakSelf.disposable dispose];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.sendCodeButton.enabled = YES;
                [weakSelf.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [weakSelf.sendCodeButton setBackgroundColor:ColorWithHex(@"#EEEEEE")]; [weakSelf.sendCodeButton setTitleColor:ColorWithHex(@"343434") forState:UIControlStateNormal];
            });
        }
    }];
}



-(void)initSubview{
    
       [self addSubview:self.phoneNumView];
       [self addSubview:self.codeNumView];
       [self addSubview:self.LoginButton];
       [self addSubview:self.sendCodeButton];
       [self addSubview:self.desLab];
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.mas_equalTo(@38);
    }];
    

    [self.phoneNumView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.offset(27);
           make.top.offset(60);
           make.right.offset(-27);
           make.height.mas_equalTo(32);
       }];
       
       [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.top.equalTo(self.phoneNumView.mas_bottom).offset(16);
                  make.right.offset(-27);
                  make.height.mas_equalTo(@32);
                  make.width.mas_equalTo(CONTROLLER_FRAME(98));
          }];
       
       [self.codeNumView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.offset(27);
           make.top.equalTo(self.phoneNumView.mas_bottom).offset(16);
           make.right.equalTo(self.sendCodeButton.mas_left).offset(-12);
           make.height.mas_equalTo(32);
       }];
    
    
    [self.LoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(27);
        make.right.offset(-27);
        make.height.mas_equalTo(CONTROLLER_FRAME(36));
        make.top.equalTo(self.codeNumView.mas_bottom).offset(57);
    }];
    
    [self controlEvent];
 

}

-(RegisterTextView *)phoneNumView{
    if (!_phoneNumView) {
        _phoneNumView = [self registerView];
        _phoneNumView.title = @"手机号：";
        _phoneNumView.textField.placeholder = @"请输入手机号";
        
    }
     return _phoneNumView;
}

-(RegisterTextView *)codeNumView{
    if (!_codeNumView) {
        _codeNumView = [self registerView];
        _codeNumView.title = @"验证码：";
        _codeNumView.textField.placeholder = @"请输入验证码";
    }
     return _codeNumView;
}

-(RegisterTextView *)registerView{
    RegisterTextView * textView = [[RegisterTextView alloc]init];
    textView.textField.layer.borderWidth = 1.f;
    textView.textField.layer.borderColor = ColorWithHex(@"#eeeeee").CGColor;
    textView.textField.layer.cornerRadius = 2.5f;
    return textView;
}

-(UILabel *)desLab{
    if(!_desLab){
        _desLab = [[UILabel alloc]init];
        _desLab.text = @"请使用报名手机号进行登录";
        _desLab.font = FontWithSize(13);
        _desLab.textColor = ColorWithHex(@"#FF6010");
        _desLab.backgroundColor = ColorWithHex(@"#FFF9ED");
        _desLab.textAlignment = NSTextAlignmentCenter;
    }

    return _desLab;
}



-(UIButton *)sendCodeButton{
    if (!_sendCodeButton) {
        _sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = FontWithSize(13);
        [_sendCodeButton setBackgroundColor: ColorWithHex(@"#fdcf2c")];
        [_sendCodeButton setTitleColor:ColorWithHex(@"#343434") forState:UIControlStateNormal];
        _sendCodeButton.layer.cornerRadius = 2.5f;
        _sendCodeButton.layer.masksToBounds = YES;
    }

    return _sendCodeButton;
}

-(UIButton *)LoginButton{
    if (!_LoginButton) {
        _LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_LoginButton setTitle:@"登录" forState:UIControlStateNormal];
       _LoginButton.titleLabel.font = FontWith14px;
       [_LoginButton setBackgroundColor: ColorWithHex(@"#fdcf2c")];
       _LoginButton.layer.cornerRadius = 2.5f;
       [_LoginButton setTitleColor:ColorWithHex(@"#343434") forState:UIControlStateNormal];

       _LoginButton.layer.masksToBounds = YES;
        
    }
    
    return _LoginButton;
}

- (void)sendCode{
    kWeakSelf;
    [LZLoginNetworkAPI sendCodeWithPhone:[Aes AES128Encrypt:self.phoneNumView.textField.text] block:^(LZNetworkResult *result, NSError *error) {
        
        if (!error) {
            if (result.isSuccess) {
                
            }else{
                [MBProgressHUD showError:result.msg ToView:weakSelf];
            }
        }else{
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf];
        }
    }];
}
- (void)login{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    kWeakSelf;
    [LZLoginNetworkAPI loginWithPhone:[Aes AES128Encrypt:self.phoneNumView.textField.text] smscode:self.codeNumView.textField.text block:^(LZNetworkResult *result, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        if (!error) {
            if (result.isSuccess) {
                [LZUserManger setWithSaveModel:[UserInfoModel yy_modelWithJSON:result.data]];
                [LZUserManger postUserLoginNotification];
                [weakSelf.loginSubject sendNext:@""];
            }else{
                [MBProgressHUD showError:result.msg ToView:weakSelf];
            }
        }else{
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf];
        }
    }];
}

@end
