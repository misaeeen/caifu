//
//  ChooseTestCell.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//

#import "ChooseTestCell.h"

@interface ChooseTestCell ()
@property(nonatomic,strong)UIImageView * bgImgV;
@property(nonatomic,strong)UILabel * testTitleLab;
@property(nonatomic,strong)UILabel * testTimeLab;
@property(nonatomic,strong)UILabel * levelLab;
@end

@implementation ChooseTestCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)initSubview{
    [self addSubview:self.bgImgV];
    [self addSubview:self.testTitleLab];
    [self addSubview:self.testTimeLab];
    [self addSubview:self.levelLab];
    
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        make.top.offset(8);
        make.bottom.offset(-8);
    }];
    
    [self.testTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(28);
        make.top.offset(23);
        make.height.mas_equalTo(@22);
    }];
    
    [self.testTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(28);
        make.bottom.offset(-18.5);
        make.height.mas_equalTo(@13);
    }];
    
    [self.levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-36.5);
        make.top.offset(28);
        make.height.mas_equalTo(41);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)reloadWithModel:(LZTestModel *)model{
    NSString *examStartTime = [model.examStartTime timerTransfer];
    NSString *examEndTime = [model.examEndTime timerTransfer];
    NSString *examTime = [NSString stringWithFormat:@"%@--%@",examStartTime,examEndTime];
    self.testTimeLab.text = [NSString stringWithFormat:@"考级时间：%@",examTime];
    self.testTitleLab.text = model.subject;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:model.level];
    [attrString addAttribute:NSFontAttributeName
    value:FontWithSize(15)
    range:NSMakeRange(model.level.length - 1, 1)];
    [self.levelLab setAttributedText:attrString];
}


-(UILabel *)testTimeLab{
    if (!_testTimeLab) {
        _testTimeLab = [[UILabel alloc]init];
//        _testTimeLab.text = @"考级时间：2020-09-06 08:00-17:00";
        _testTimeLab.font = FontWithSize(12);
        _testTimeLab.textColor = ColorWithHex(@"333333");
    }
    return _testTimeLab;
}

-(UILabel *)testTitleLab{
    if (!_testTitleLab) {
        _testTitleLab = [[UILabel alloc]init];
//        _testTitleLab.text = @"小军鼓水平等级考试";
        _testTitleLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        _testTitleLab.textColor = ColorWithHex(@"333333");

    }
    
    return _testTitleLab;
}

-(UILabel *)levelLab{
    if (!_levelLab) {
        _levelLab = [[UILabel alloc]init];
        _levelLab.font = [UIFont systemFontOfSize:40.0f];
        
    }
    
    return _levelLab;
}

-(UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chooseTestBg"]];
    }
    return _bgImgV;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
