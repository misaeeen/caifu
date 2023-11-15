//
//  ScrollPageView.h
//  kakatrip
//
//  Created by caiming on 16/9/14.
//  Copyright © 2016年 kakatrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollPageView;

@protocol ScrollPageViewDelegate <NSObject>

@optional

- (void)scrollPageView:(ScrollPageView*)aView didScrollToPageIndex:(NSInteger)index;
- (void)scrollPageView:(ScrollPageView*)aView didScrollOffset:(CGPoint)offset;

@end

@interface ScrollPageView : UIView

@property(nonatomic,weak) id<ScrollPageViewDelegate> delagate;
@property(nonatomic,assign)BOOL showPageControl;//default NO;
- (void)addPage:(UIView*)page;
- (void)setSelectPage:(NSInteger)index;
- (void)removeAllPages;

- (void)scrollEnabled:(BOOL)enabled;//default NO;


@end
