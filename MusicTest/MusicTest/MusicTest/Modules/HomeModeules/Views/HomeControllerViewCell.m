//
//  HomeControllerViewCell.m
//  MusicTest
//
//  Created by LZZ on 2020/11/12.
//  Copyright © 2020 CF. All rights reserved.
//

#import "HomeControllerViewCell.h"

@interface HomeControllerViewCell ()
@property(nonatomic,strong)UIButton * itemButton;
@property(nonatomic,strong)UIButton * item1Button;
@end
@implementation HomeControllerViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    
    return self;
}

-(void)reloadDataWithArray:(NSArray *)data{
    
    NSDictionary * dict = data[0];
    [self.itemButton setBackgroundImage:[UIImage imageNamed:dict[@"iconName"]] forState:UIControlStateNormal];
    self.itemButton.tag = [dict[@"tag"] integerValue];
    
    
    NSDictionary * dict1 = data[1];
    [self.item1Button setBackgroundImage:[UIImage imageNamed:dict1[@"iconName"]] forState:UIControlStateNormal];
    self.item1Button.tag =  [dict1[@"tag"] integerValue];
}

-(void)initSubview{
    [self.contentView addSubview:self.itemButton];
    [self.contentView addSubview:self.item1Button];
    
    CGFloat width = (SCREEN_WDITH - 48)/2;
    CGFloat height = CONTROLLER_FRAME(162);
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.left.offset(16);
        make.top.offset(5);
    }];
    
    [self.item1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.right.offset(-16);
        make.top.offset(5);
    }];
    
    __weak typeof(self) weakSelf = self;
    [[self.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSInteger tag = x.tag;
        NSString * index = [NSString stringWithFormat:@"%ld",tag];
        [weakSelf.homeViewCellDidSelectSubject sendNext:index];

    }];
    
    [[self.item1Button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSInteger tag = x.tag;
         NSString * index = [NSString stringWithFormat:@"%ld",tag];
         [weakSelf.homeViewCellDidSelectSubject sendNext:index];

    }];
}

-(UIButton *)itemButton{
    if(!_itemButton){
        _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _itemButton;
}

-(UIButton *)item1Button{
    if(!_item1Button){
        _item1Button = [UIButton buttonWithType:UIButtonTypeCustom];

    }
    return _item1Button;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(RACSubject *)homeViewCellDidSelectSubject{
    if (!_homeViewCellDidSelectSubject) {
        _homeViewCellDidSelectSubject = [RACSubject new];
    }
    
    return _homeViewCellDidSelectSubject;
}


@end
