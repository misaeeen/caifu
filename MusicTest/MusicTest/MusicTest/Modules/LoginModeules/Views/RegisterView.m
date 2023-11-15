//
//  RegisterView.m
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import "RegisterView.h"
#import "RegisterTextView.h"

@interface RegisterView()

@property(nonatomic,strong)RegisterTextView * phoneNumView;
@property(nonatomic,strong)RegisterTextView * codeNumView;
@property(nonatomic,strong)RegisterTextView * passwordView;
@property(nonatomic,strong)RegisterTextView * configPasswordView;
@property(nonatomic,strong)UIButton * submitButton;
@property(nonatomic,strong)UIButton * loginButton;
@property(nonatomic,strong)UIButton * sendCodeButton;


@end

@implementation RegisterView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initSubview];
    }
    
    return self;
}

-(void)initSubview{
    
    [self addSubview:self.phoneNumView];
    [self addSubview:self.codeNumView];
    [self addSubview:self.passwordView];
    [self addSubview:self.configPasswordView];
    [self addSubview:self.submitButton];
    [self addSubview:self.loginButton];
    [self addSubview:self.sendCodeButton];
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
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(27);
        make.top.equalTo(self.codeNumView.mas_bottom).offset(16);
        make.right.offset(-27);
        make.height.mas_equalTo(32);
    }];
    [self.configPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(27);
        make.top.equalTo(self.passwordView.mas_bottom).offset(16);
        make.right.offset(-27);
        make.height.mas_equalTo(32);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(27);
        make.top.equalTo(self.configPasswordView.mas_bottom).offset(28);
        make.right.offset(-27);
        make.height.mas_equalTo(36);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(16);
          make.top.equalTo(self.submitButton.mas_bottom).offset(16);
          make.centerX.equalTo(self);
      }];
    
   
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
-(RegisterTextView *)passwordView{
    if (!_passwordView) {
        _passwordView = [self registerView];
        _passwordView.title = @"密码：";
        _passwordView.textField.placeholder = @"请输入密码";
    }
     return _passwordView;
}
-(RegisterTextView *)configPasswordView{
    if (!_configPasswordView) {
        _configPasswordView = [self registerView];
        _configPasswordView.title = @"确认密码：";
        _configPasswordView.textField.placeholder = @"请再次输入密码";
    }
     return _configPasswordView;
}

-(RegisterTextView *)registerView{
    RegisterTextView * textView = [[RegisterTextView alloc]init];
    textView.textField.layer.borderWidth = 1.f;
    textView.textField.layer.borderColor = ColorWithHex(@"#eeeeee").CGColor;
    textView.textField.layer.cornerRadius = 2.5f;
    return textView;
}


-(UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"注册" forState:UIControlStateNormal];
       _submitButton.titleLabel.font = FontWithSize(13);
       [_submitButton setBackgroundColor: ColorWithHex(@"#fdcf2c")];
       _submitButton.layer.cornerRadius = 2.5f;
       [_submitButton setTitleColor:ColorWithHex(@"#343434") forState:UIControlStateNormal];

       _submitButton.layer.masksToBounds = YES;
        
    }
    
    return _submitButton;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
          _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
          [_loginButton setTitle:@"用户登录" forState:UIControlStateNormal];
          [_loginButton setTitleColor:ColorWithHex(@"#333333") forState:UIControlStateNormal];
          _loginButton.titleLabel.font = FontWithSize(13);
          
      }
    
    return _loginButton;
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
@end
