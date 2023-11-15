//
//  TestInfoCell.m
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import "TestInfoCell.h"
#import "RegisterTextView.h"
#import "NSString+CLString.h"

@interface TestInfoCell()

@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)RegisterTextView * subjectView;
@property(nonatomic,strong)RegisterTextView * levelView;
@property(nonatomic,strong)RegisterTextView * timeView;
@property(nonatomic,strong)UIImageView * arrowIconImgV;
@property(nonatomic,strong)UIButton * putVideoButton;
@end

@implementation TestInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    
    return self;
}

-(void)initSubview{
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.subjectView];
    [self.bgView addSubview:self.levelView];
    [self.bgView addSubview:self.timeView];
    [self.bgView addSubview:self.arrowIconImgV];
    [self.bgView addSubview:self.putVideoButton];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        make.top.offset(5);
        make.bottom.offset(-5);
    }];

    [self.putVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.offset(13);
           make.right.offset(-12);
           make.height.mas_equalTo(@33);
           make.width.mas_equalTo(@88);
     }];

    [self.subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(13);
        make.right.equalTo(self.putVideoButton.mas_left).offset(10);
        make.height.mas_equalTo(14);

    }];

    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.offset(10);
           make.top.equalTo(self.subjectView.mas_bottom).offset(12);
           make.right.offset(-10);
           make.height.mas_equalTo(14);

       }];

    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.offset(10);
           make.top.equalTo(self.levelView.mas_bottom).offset(12);
           make.right.offset(-10);
           make.height.mas_equalTo(14);
      }];

    [self.arrowIconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.offset(-10);
          make.height.mas_equalTo(@13);
          make.width.mas_equalTo(@7);
          make.centerY.equalTo(self.timeView);
    }];
    
 
    
}

- (void)reloadWithModel:(LZTestModel *)model state:(LZTestState)state{
    self.subjectView.textField.text = model.subject;
    self.levelView.textField.text = model.level;
    NSString *examStartTime = [model.examStartTime timerTransfer];
    NSString *examEndTime = [model.examEndTime timerTransfer];
    NSString *examTime = [NSString stringWithFormat:@"%@--%@",examStartTime,examEndTime];
    self.timeView.textField.text = examTime;
    [self setupPutVideoButtonStyleWithModel:model state:state];
}

- (void)setupPutVideoButtonStyleWithModel:(LZTestModel *)model state:(LZTestState)state{
    //报名状态: -1 全部 0 待审核 1 待付费 2 待考 3 待评审 4 已完成 5 审核失败 6 缺考
    self.putVideoButton.hidden = NO;
    NSInteger status = [model.status integerValue];
    if (status == 2) {
        [self.putVideoButton setImage:[UIImage imageNamed:@"test_state_not_tested"] forState:UIControlStateNormal];
        [self.putVideoButton setBackgroundColor: ColorWithHex(@"#fdcf2c")];
        [self.putVideoButton setTitle:@"开始考试" forState:UIControlStateNormal];
        
    }else if (status == 3 || status == 4) {
        //是否公布成绩 0 未公布 1已公布 ,
        if ([model.isIssued integerValue] == 0) {
            [self.putVideoButton setImage:[UIImage imageNamed:@"test_state_not_open"] forState:UIControlStateNormal];
            [self.putVideoButton setBackgroundColor: [ColorWithHex(@"#FF3B30") colorWithAlphaComponent:0.2f]];
            [self.putVideoButton setTitle:@"成绩待公布" forState:UIControlStateNormal];
        }else{
            [self.putVideoButton setImage:[UIImage imageNamed:@"test_state_open"] forState:UIControlStateNormal];
            [self.putVideoButton setBackgroundColor: [ColorWithHex(@"#1677FF") colorWithAlphaComponent:0.2f]];
            [self.putVideoButton setTitle:@"成绩已公布" forState:UIControlStateNormal];
        }
    }else if(status == 6){
//        self.putVideoButton.hidden = YES;
//        if (state == LZTestStateNotTested) {
//            self.putVideoButton.hidden = NO;
            [self.putVideoButton setImage:[UIImage imageNamed:@"icon_tested_close"] forState:UIControlStateNormal];
            [self.putVideoButton setBackgroundColor: ColorWithHex(@"#EEEEEE")];
            [self.putVideoButton setTitle:@"考试结束" forState:UIControlStateNormal];
//        }
    }
}

- (void) testClosePutVideoButtonStyle{
    
}

-(RegisterTextView *)subjectView{
    if (!_subjectView) {
        _subjectView = [self registerView];
        _subjectView.title = @"考级科目：";
    }
    return _subjectView;
}


-(RegisterTextView *)levelView{
    if (!_levelView) {
        _levelView = [self registerView];
        _levelView.title = @"考级等级：";
    }
    return _levelView;
}


-(RegisterTextView *)timeView{
    if (!_timeView) {
        _timeView = [self registerView];
        _timeView.title = @"考级时间：";
    }
    return _timeView;
}

-(RegisterTextView *)registerView{
    RegisterTextView * textView = [[RegisterTextView alloc]init];
    textView.textField.enabled = NO;
//    textView.textField.text = @"小军鼓";
    textView.textField.textColor = ColorWithHex(@"#333333");
    textView.textField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    
   
    return textView;
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

-(UIImageView *)arrowIconImgV{
    if (!_arrowIconImgV) {
        _arrowIconImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"repayment_arrow_right"]];
    }
    
    return _arrowIconImgV;
}

-(UIButton *)putVideoButton{
    if (!_putVideoButton) {
        _putVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _putVideoButton.layer.cornerRadius = 17.f;
        [_putVideoButton setTitleColor:ColorWithHex(@"#343434") forState:UIControlStateNormal];
        _putVideoButton.layer.masksToBounds = YES;
//        [_putVideoButton setBackgroundColor: ColorWithHex(@"#fdcf2c")];
//        [_putVideoButton setTitle:@"上传视屏" forState:UIControlStateNormal];
        _putVideoButton.titleLabel.font = FontWithSize(12);
        _putVideoButton.enabled = NO;
    }
    
    return _putVideoButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
