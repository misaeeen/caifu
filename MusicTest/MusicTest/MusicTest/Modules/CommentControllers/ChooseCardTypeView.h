//
//  ChooseCardView.h
//  kakatrip
//
//  Created by caiming on 16/9/13.
//  Copyright © 2016年 kakatrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseCardTypeView;

@protocol ChooseCardTypeViewDelegate <NSObject>

- (void)chooseCardTypeView:(ChooseCardTypeView *)aView didSelectIndex:(NSInteger)index;

@end

@interface ChooseCardTypeView : UIView

@property(nonatomic, weak)id<ChooseCardTypeViewDelegate> delegate;
@property(nonatomic,strong)NSArray * headTitleArray;
- (void)setSelectIndex:(NSUInteger)index;

@end
