//
//  ScrollPageView.m
//  kakatrip
//
//  Created by caiming on 16/9/14.
//  Copyright © 2016年 kakatrip. All rights reserved.
//

#import "ScrollPageView.h"
//#import "KKPageControl.h"

@interface ScrollPageView ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, assign)NSUInteger pageSize;
@property(nonatomic, assign)NSInteger currentDisplayIndex;
@property(nonatomic, strong)NSMutableArray *pages;
//@property(nonatomic, strong)KKPageControl *pageControl;

@end

@implementation ScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

- (void)removeAllPages
{
    for (UIView *view in self.pages) {
        
        [view removeFromSuperview];
        view.hidden = YES;
        _pageSize = 0;

    }
    
    [self.pages removeAllObjects];
}

- (void)scrollEnabled:(BOOL)enabled
{
    self.scrollView.scrollEnabled = enabled;
}

- (void)addPage:(UIView*)page
{
    
    CGFloat frame_height = self.frame.size.height;
    CGFloat frame_width = self.frame.size.width;
    if (page)
    {
        page.frame = CGRectMake(_pageSize* frame_width, 0, frame_width, frame_height);
        [self.scrollView addSubview:page];
        [self.pages addObject:page];
        _pageSize+=1;
        self.scrollView.contentSize = CGSizeMake(frame_width*_pageSize, frame_height);
    }
    
    if (self.pages.count>1 && self.showPageControl) {
        
//        self.pageControl.hidden = NO;
//        self.pageControl.numberOfPages = self.pages.count;

    }else
    {
//        self.pageControl.hidden = YES;
    }
    

}

- (void)setSelectPage:(NSInteger)index
{
    
    CGFloat frame_width = self.frame.size.width;

    CGPoint point = CGPointMake(index * frame_width,0);
    _currentDisplayIndex = index;
    [self.scrollView setContentOffset:point animated:NO];
}

- (void)initSubviews
{
    [self addSubview:self.scrollView];
//    [self addSubview:self.pageControl];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@",scrollView);
    if ([self.delagate respondsToSelector:@selector(scrollPageView:didScrollOffset:)]) {
        [self.delagate scrollPageView:self didScrollOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat frame_width = self.frame.size.width;
    NSInteger currentIndex = scrollView.contentOffset.x/frame_width;
    _currentDisplayIndex = currentIndex;
//    self.pageControl.currentPage = _currentDisplayIndex;
    if ([self.delagate respondsToSelector:@selector(scrollPageView:didScrollToPageIndex:)])
    {
        [self.delagate scrollPageView:self didScrollToPageIndex:currentIndex];
    }
}




- (UIScrollView *)scrollView
{
    if (_scrollView) {
        
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = NO;
    return _scrollView;
}

- (NSMutableArray *)pages
{
    if (!_pages) {
        
        _pages = [NSMutableArray array];
    }
    
    return _pages;
}

//- (KKPageControl *)pageControl
//{
//    if (!_pageControl) {
//
//        _pageControl = [[KKPageControl alloc]initWithFrame:CGRectMake(0, self.frame_height-23, self.frame_width, 23)];
//        _pageControl.backgroundColor = [UIColor clearColor];
//
//    }
//
//    return _pageControl;
//}


@end




