//
//  OnlineTestConfigCell.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//

#import "OnlineTestConfigCell.h"
#import "RegisterTextView.h"
@interface OnlineTestConfigCell ()
@property(nonatomic,strong)RegisterTextView * textView;
@property(nonatomic,strong)UIView * lineView;
@end

@implementation OnlineTestConfigCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}



-(void)initSubview{
    [self addSubview:self.textView];
    [self addSubview:self.lineView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(-1);
        make.left.offset(16);
        make.right.offset(-16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.bottom.offset(0);
        make.left.offset(16);
        make.height.mas_equalTo(@1);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)reloadWithData:(NSDictionary *)data{
    self.textView.title = data[@"title"];
    self.textView.textField.text = data[@"content"];
    NSString *textColorStr = data[@"textColor"];
    if (textColorStr.length != 0) {
        self.textView.textField.textColor = ColorWithHex(textColorStr);
    }
    
}

-(RegisterTextView *)textView{
    if (!_textView) {
        _textView = [[RegisterTextView alloc]init];
//        _textView.title = @"考生姓名：";
//        _textView.textField.text = @"小军鼓考级教程";
        _textView.textField.textAlignment = NSTextAlignmentLeft;
        _textView.textField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _textView.textField.enabled = NO;
    }
    
    return _textView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        [_lineView setBackgroundColor:ColorWithHex(@"EEEEEE")];
    }
    return _lineView;
}

@end
