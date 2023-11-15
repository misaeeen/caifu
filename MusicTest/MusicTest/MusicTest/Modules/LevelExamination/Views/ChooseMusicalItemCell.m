//
//  ChooseMusicalItemCell.m
//  MusicTest
//
//  Created by LZZ on 2020/12/14.
//  Copyright © 2020 CF. All rights reserved.
//

#import "ChooseMusicalItemCell.h"

@interface ChooseMusicalItemCell ()

@property (nonatomic, strong)UIImageView *imgV;
@property (nonatomic, strong)UILabel *titleL;

@end

@implementation ChooseMusicalItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.imgV];
    [self.contentView addSubview:self.titleL];
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.offset(8.0f);
        make.width.height.offset(80.0f);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0.0f);
        make.top.equalTo(self.imgV.mas_bottom).offset(12.0f);
    }];
}

- (void)reloadWithData:(NSDictionary *)dict{
    self.titleL.text = dict[@"title"];
    if ([dict[@"isSelected"] boolValue]) {
        self.imgV.image = [UIImage imageNamed:dict[@"selectedImage"]];
    }else{
        self.imgV.image = [UIImage imageNamed:dict[@"image"]];
    }
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc] init];
    }
    return _imgV;
}
- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [UILabel createWithColor:ColorWithHex(@"#333333") font:FontWithSize(13.0f)];
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}

@end
