//
//  OnlineTestCell.m
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import "OnlineTestCell.h"

@interface OnlineTestCell ()

@property (nonatomic, strong)UIView *bgV;
@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)UILabel *titleL;
@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation OnlineTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setupSubviews];
    }
    return self;
}

-(void)_setupSubviews{
    [self.contentView addSubview:self.bgV];
    [self.bgV addSubview:self.imageV];
    [self.bgV addSubview:self.titleL];
    [self.bgV addSubview:self.rightIcon];
    
    [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(16.0f);
        make.right.offset(-16.0f);
        make.bottom.offset(-4.0f);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(32.0f);
        make.centerY.equalTo(self.bgV.mas_centerY);
        make.width.offset(62.0f);
        make.height.offset(58.0f);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgV.mas_centerY);
        make.centerX.equalTo(self.bgV.mas_centerX);
    }];
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgV.mas_centerY);
        make.right.offset(-20.0f);
        make.width.height.offset(20.0f);
    }];
}

- (void)reloadWithModel:(NSDictionary *)model{
    self.imageV.image = model[@"image"];
    self.titleL.text = model[@"title"];
}

- (UIView *)bgV{
    if (!_bgV) {
        _bgV = [[UIView alloc] init];
        _bgV.backgroundColor = [UIColor whiteColor];
        _bgV.layer.cornerRadius = 5;
        _bgV.layer.shadowColor = ColorWithHex(@"#999999").CGColor;
        _bgV.layer.shadowOffset = CGSizeMake(1, 1);
        _bgV.layer.shadowOpacity = 0.3;
        _bgV.layer.shadowRadius = 2;
    }
    return _bgV;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleL.font = FontWithSize(14.0f);
    }
    return _titleL;
}
- (UIImageView *)rightIcon{
    if(!_rightIcon){
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = [UIImage imageNamed:@"right_icon"];
    }
    return _rightIcon;
}

@end
