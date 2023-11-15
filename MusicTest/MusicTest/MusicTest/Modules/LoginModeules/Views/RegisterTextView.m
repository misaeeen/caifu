//
//  RegisterTextView.m
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import "RegisterTextView.h"


@interface RegisterTextView()
@property(nonatomic,strong)UILabel * titleLab;
@end
@implementation RegisterTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubview];
    }
    
    return self;
}

-(void)setTitle:(NSString *)title{
    
    self.titleLab.text = title;
}

-(void)initSubview{
    
    [self addSubview:self.titleLab];
    [self addSubview:self.textField];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.mas_equalTo(@84);

    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.left.equalTo(self.titleLab.mas_right);
    }];
}


-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
//        _textField.placeholder = @"请输入手机号";
        _textField.font = FontWithSize(12);
        _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
    }
    
    return _textField;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
//        _titleLab.text = @"手机号：";
        _titleLab.textColor = ColorWithHex(@"#333333");
        _titleLab.font = FontWithSize(12);
    }
    
    return _titleLab;
}
@end
