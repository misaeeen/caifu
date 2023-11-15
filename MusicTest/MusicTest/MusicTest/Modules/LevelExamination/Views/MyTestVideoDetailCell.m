//
//  MyTestVideoDetailCell.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//

#import "MyTestVideoDetailCell.h"

@interface MyTestVideoDetailCell ()
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIButton * playVideoButton;
@property(nonatomic,strong)UIButton * postVideoButton;
@end
@implementation MyTestVideoDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    
    return self;
}

-(void)initSubview{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.postVideoButton];
    [self.bgView addSubview:self.playVideoButton];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(8);
        make.right.offset(-16);
        make.bottom.offset(-8);
        make.left.offset(16);
    }];
    
    [self.playVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.top.offset(8);
        make.width.mas_equalTo(@136);
        make.height.mas_equalTo(@90);
    }];
    
    [self.postVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-53);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self);
    }];
}

-(UIButton *)postVideoButton{
    if (!_postVideoButton) {
        _postVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postVideoButton setBackgroundColor: ColorWithHex(@"#fdcf2c")];
        _postVideoButton.layer.cornerRadius = 17.f;
        [_postVideoButton setTitleColor:ColorWithHex(@"#343434") forState:UIControlStateNormal];
        _postVideoButton.layer.masksToBounds = YES;
        [_postVideoButton setTitle:@"上传视屏" forState:UIControlStateNormal];
        _postVideoButton.titleLabel.font = FontWithSize(12);
    }
    
    return _postVideoButton;
}
-(UIButton *)playVideoButton{
    if (!_playVideoButton) {
        _playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playVideoButton setBackgroundColor:[UIColor redColor]];
        _playVideoButton.layer.cornerRadius = 17.f;
         _playVideoButton.layer.masksToBounds = YES;
    }
    
    return _playVideoButton;
}



-(UIView *)bgView{
   
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
         _bgView.layer.cornerRadius = 5;
          _bgView.layer.shadowColor = ColorWithHex(@"#999999").CGColor;
          _bgView.layer.shadowOffset = CGSizeMake(1, 1);
          _bgView.layer.shadowOpacity = 0.3;
          _bgView.layer.shadowRadius = 2;

    }
    
    return _bgView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
