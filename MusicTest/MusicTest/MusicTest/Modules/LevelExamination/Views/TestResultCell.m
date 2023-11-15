//
//  TestResultCell.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//

#import "TestResultCell.h"
#import "RegisterTextView.h"

@interface  TestResultCell()
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)RegisterTextView * testTypeView;
@property(nonatomic,strong)RegisterTextView * testLevelView;
@property(nonatomic,strong)RegisterTextView * testResultView;
@property(nonatomic,strong)RegisterTextView * testScoreView;
@property(nonatomic,strong)RegisterTextView * testCommentView;
@property(nonatomic,strong)UIImageView * resultImageV;
@end
@implementation TestResultCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    return self;
}

-(void)initSubview{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.testTypeView];
    [self.bgView addSubview:self.testResultView];
    [self.bgView addSubview:self.testCommentView];
    [self.bgView addSubview:self.testLevelView];
    [self.bgView addSubview:self.testScoreView];
    [self.bgView addSubview:self.resultImageV];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        make.top.offset(8);
        make.bottom.offset(-8);
    }];
    
    [self.testTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.offset(13);
       make.top.offset(12);
       make.height.mas_equalTo(20);
       make.right.offset(-20);
    }];
    
    [self.testLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.top.equalTo(self.testTypeView.mas_bottom).offset(12);   make.height.mas_equalTo(20);
        make.right.offset(-20);
    }];
    [self.testResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.top.equalTo(self.testLevelView.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
        make.right.offset(-20);
    }];
    [self.testScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.top.equalTo(self.testResultView.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
        make.right.offset(-20);
    }];
    [self.testCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.top.equalTo(self.testScoreView.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
        make.right.offset(-20);
    }];
    
    [self.resultImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(63);
        make.height.mas_equalTo(49.5);
        make.right.offset(-42);
        make.top.offset(43);
    }];
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(RegisterTextView *)testTypeView{
    if (!_testTypeView) {
        _testTypeView = [self registerView];
        _testTypeView.title = @"考级科目：";
    }
    
    return _testTypeView;
}

-(RegisterTextView *)testLevelView{
    if (!_testLevelView) {
        _testLevelView = [self registerView];
        _testLevelView.title = @"考级等级：";
    }
    
    return _testLevelView;
}
-(RegisterTextView *)testScoreView{
    if (!_testScoreView) {
        _testScoreView = [self registerView];
        _testScoreView.title = @"分数：";
    }
    
    return _testScoreView;
}
-(RegisterTextView *)testCommentView{
    if (!_testCommentView) {
        _testCommentView = [self registerView];
        _testCommentView.title = @"评语：";
    }
    
    return _testCommentView;
}

-(RegisterTextView *)testResultView{
    if (!_testResultView) {
        _testResultView = [self registerView];
        _testResultView.title = @"考级：";
        _testResultView.textField.textColor = ColorWithHex(@"#FF3B30");
        
    }
    
    return _testResultView;
}

-(UIImageView *)resultImageV{
    if (!_resultImageV) {
        _resultImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_result_success"]];
    }
    
    return _resultImageV;
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

-(RegisterTextView *)registerView{
    RegisterTextView * textView = [[RegisterTextView alloc]init];
    textView.textField.enabled = NO;
    textView.textField.text = @"不及格";
    
    return textView;
}
@end
