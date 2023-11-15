//
//  UserCenterCell.m
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import "UserCenterCell.h"
@interface UserCenterCell()

@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)UILabel *titleL;
@property (nonatomic, strong)UIImageView *rightIcon;
@property (nonatomic, strong)UIView *line;

@end
@implementation UserCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setupSubviews];
    }
    return self;
}

-(void)_setupSubviews{
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.rightIcon];
    [self.contentView addSubview:self.line];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.offset(16.0f);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.imageV.mas_right).offset(12.0f);
    }];
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.offset(-20.0f);
        make.height.width.offset(16.0f);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16.0f);
        make.bottom.offset(0.0f);
        make.right.offset(-16.0f);
        make.height.offset(0.5f);
    }];
}

- (void)reloadWithModel:(NSDictionary *)model{
    self.imageV.image = model[@"image"];
    self.titleL.text = model[@"title"];
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
        _rightIcon.image = [UIImage imageNamed:@"right_arrow"];
    }
    return _rightIcon;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
    return _line;
}

@end
