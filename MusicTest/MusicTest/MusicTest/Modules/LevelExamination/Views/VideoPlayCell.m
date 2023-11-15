//
//  VideoPlayCell.m
//  MusicTest
//
//  Created by LZZ on 2020/12/8.
//  Copyright © 2020 CF. All rights reserved.
//

#import "VideoPlayCell.h"

@interface VideoPlayCell()

@property (nonatomic, strong) UIView *bgV;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIImageView *playImgV;
@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UILabel *subTitleL;

@end

@implementation VideoPlayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.bgV];
    [self.bgV addSubview:self.imgBtn];
    [self.imgBtn addSubview:self.playImgV];
    [self.contentView addSubview:self.playBtn];
    [self.contentView addSubview:self.subTitleL];
    
    [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16.0f);
        make.right.offset(-16.0f);
        make.top.offset(12.0f);
        make.bottom.offset(0.0f);
    }];
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12.0f);
        make.top.offset(8.0f);
        make.height.offset(90.0f);
        make.width.offset(136.0f);
    }];
    [self.playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imgBtn);
        make.width.height.offset(44.0f);
    }];
//    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bgV);
//        make.centerX.equalTo(self.bgV.mas_centerX).offset(136.0f/2);
//        make.height.mas_equalTo(@33);
//        make.width.mas_equalTo(@88);
//    }];
}

- (void)reloadWithModel:(NSDictionary *)model{
    id image = model[@"image"];
    if([image isKindOfClass:[UIImage class]]){
        [self.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
    }else if ([image isKindOfClass:[NSString class]]){
        [self.imgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_video_not_default"]];
    }
    [self.playBtn setTitle:model[@"btnTitle"] forState:UIControlStateNormal];
    [self.playBtn setImage:model[@"btnIcon"] forState:UIControlStateNormal];
    NSString *indexTitle = model[@"indexTitle"];
    if (indexTitle.length != 0) {
        self.subTitleL.hidden = NO;
        self.subTitleL.text = indexTitle;
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imgBtn.mas_bottom).offset(-6);
            make.left.equalTo(self.imgBtn.mas_right).offset(16.0f);
            make.height.offset(33);
            make.width.offset(88);
        }];
        [self.subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgBtn.mas_right).offset(16.0f);
            make.top.equalTo(self.imgBtn.mas_top);
            make.right.offset(-16.0f);
            make.height.offset(45.0f);
        }];
    }else{
        self.subTitleL.hidden = YES;
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgV);
            make.centerX.equalTo(self.bgV.mas_centerX).offset(136.0f/2);
            make.height.offset(33);
            make.width.offset(88);
        }];
    }
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

- (UIButton *)imgBtn{
    if (!_imgBtn) {
        _imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [[_imgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.leftBtnClick != nil) {
                self.leftBtnClick(self.indexPath);
            }
        }];
    }
    return _imgBtn;
}

- (UIImageView *)playImgV{
    if (!_playImgV) {
        _playImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_play_icon"]];
    }
    return _playImgV;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.layer.cornerRadius = 17.f;
        [_playBtn setTitleColor:ColorWithHex(@"#343434") forState:UIControlStateNormal];
        _playBtn.layer.masksToBounds = YES;
        [_playBtn setBackgroundColor: ColorWithHex(@"#fdcf2c")];
        _playBtn.titleLabel.font = FontWithSize(12);
//        _playBtn.enabled = NO;
        [[_playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.rightBtnClick != nil) {
                self.rightBtnClick(self.indexPath);
            }
        }];
    }
    return _playBtn;
}

- (UILabel *)subTitleL {
    if (_subTitleL == nil) {
        _subTitleL = [[UILabel alloc] init];
        _subTitleL.font = FontWith14px;
        _subTitleL.textColor = ColorWithHex(@"222222");
        _subTitleL.hidden = YES;
    }
    return _subTitleL;
}

@end
