//
//  VideoSubmitCell.m
//  MusicTest
//
//  Created by LZZ on 2021/5/30.
//  Copyright © 2021 CF. All rights reserved.
//

#import "VideoSubmitCell.h"
#import "UIImage+Utils.h"
#import <AVKit/AVKit.h>

@interface VideoSubmitCell ()

@property (nonatomic, strong) UIView *bgV;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIImageView *playImgV;
@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UILabel *subTitleL;
@property (nonatomic, strong) UILabel *errorL;

@end

@implementation VideoSubmitCell

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
    [self.contentView addSubview:self.errorL];
    
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
    
    [self.errorL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgBtn.mas_right).offset(16.0f);
        make.top.equalTo(self.subTitleL.mas_bottom).offset(-5.0f);
        make.right.offset(-16.0f);
    }];
}

- (void)reloadWithModel:(LZTestInfoModel *)model{
    
    if (model.isFinish == 1) {
        self.playImgV.hidden = NO;
        self.playBtn.hidden = NO;
        self.errorL.hidden = YES;
        UIImage *image = [self firstFrameWithVideoURL:[NSURL fileURLWithPath:model.video_path] size:CGSizeMake(136.0f, 90.0f)];
        if(image == nil){
            image = [UIImage imageNamed:@"ic_video_not_default"];
        }
        [self.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
        
    }else{
        self.playBtn.hidden = YES;
        self.errorL.hidden = NO;
        
        if (model.video_path.length == 0) {
            self.playImgV.hidden = YES;
            self.errorL.text = @"视频录制中断，暂无视频";
            UIImage *image = [UIImage imageNamed:@"ic_video_not_default"];
            [self.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            self.playImgV.hidden = NO;
            self.errorL.text = @"视频录制中断，视频不完整";
            UIImage *image = [UIImage getThumbnailImage:[NSURL fileURLWithPath:model.video_path] size:CGSizeMake(136.0f, 90.0f)];
            if(image == nil){
                image = [UIImage imageNamed:@"ic_video_not_default"];
            }
            [self.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    self.subTitleL.text = [NSString stringWithFormat:@"第%ld次录制视频",model.testedCount];
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
        [_playBtn setTitle:@"提交考试" forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"icon_video_min"] forState:UIControlStateNormal];
        
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
    }
    return _subTitleL;
}

- (UILabel *)errorL {
    if (_errorL == nil) {
        _errorL = [[UILabel alloc] init];
        _errorL.font = FontWithSize(10.0f);
        _errorL.textColor = ColorWithHex(@"999999");
        _errorL.hidden = YES;
    }
    return _errorL;
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
