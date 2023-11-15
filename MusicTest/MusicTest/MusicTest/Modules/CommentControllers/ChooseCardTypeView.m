//
//  ChooseCardView.m
//  kakatrip
//
//  Created by caiming on 16/9/13.
//  Copyright © 2016年 kakatrip. All rights reserved.
//

#import "ChooseCardTypeView.h"

@interface ChooseCardTypeView ()

@property(nonatomic,strong)UILabel *chooseLab;
@property(nonatomic,strong)NSArray *buttons;

@end

@implementation ChooseCardTypeView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        [self initSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)initSubviewsWithArray:(NSArray*)titles
{
   
    UILabel *lineLab = [[UILabel alloc]init];
    lineLab.backgroundColor = ColorWithHex(@"e8e8e8");
    [self addSubview:lineLab];
    
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.height.equalTo(@0.5);
        make.leftMargin.offset(0);
        make.rightMargin.offset(0);
    }];
    
    
    self.chooseLab = [[UILabel alloc]init];
    self.chooseLab.backgroundColor = ColorWithHex(@"#FFCF26");
    [self addSubview:self.chooseLab];
    [self.chooseLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.offset(-0.5);
        make.height.equalTo(@2);
        make.left.offset(10+((SCREEN_WDITH/titles.count-20))/2 - 15);
        make.width.equalTo(@30);
        
    }];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i=0; i<titles.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = FontWithSize(15);
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(SCREEN_WDITH/titles.count));
            make.left.offset(SCREEN_WDITH/titles.count*i);
            make.top.offset(0);
            make.height.equalTo(self);
            
        }];
        
        [array addObject:button];
    }
    self.buttons = array.copy;
    
    [self setSelectIndex:0];
    
}

-(void)setHeadTitleArray:(NSArray *)headTitleArray{

    if (self.buttons) {
        return;
    }
    if (headTitleArray) {
        _headTitleArray=headTitleArray;
        [self initSubviewsWithArray:headTitleArray];
    }
}
- (void)setSelectIndex:(NSUInteger)index
{
    
    if (index<self.buttons.count) {
        
        for (UIButton *button in self.buttons)
        {
            [button setTitleColor:ColorWithHex(@"#999999") forState:UIControlStateNormal];
        }
        
        UIButton *button = self.buttons[index];
        [button setTitleColor:ColorWithHex(@"#333333") forState:UIControlStateNormal];

    }
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
//        self.chooseLab.frame = CGRectMake(10+index*SCREEN_WDITH/self->_headTitleArray.count, self.frame.size.height-2, SCREEN_WDITH/_headTitleArray.count-20, 2);
        
        self.chooseLab.frame = CGRectMake( 10+((SCREEN_WDITH/self.headTitleArray.count-20))/2 - 15 +index * (SCREEN_WDITH/self.headTitleArray.count), self.frame.size.height-2, 30, 2);
        
    } completion:^(BOOL finished) {
        
    }];

    
}

- (void)onButtonAction:(UIButton *)button
{
    [self setSelectIndex:button.tag];
    if ([self.delegate respondsToSelector:@selector(chooseCardTypeView:didSelectIndex:)]) {
        
        [self.delegate chooseCardTypeView:self didSelectIndex:button.tag];
    }
}

@end
