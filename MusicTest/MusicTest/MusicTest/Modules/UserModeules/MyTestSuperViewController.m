//
//  MyTestSuperViewController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/12.
//  Copyright © 2020 CF. All rights reserved.
//

#import "MyTestSuperViewController.h"
#import "ScrollPageView.h"
#import "TestedController.h"
#import "ChooseCardTypeView.h"
@interface MyTestSuperViewController ()<ScrollPageViewDelegate,ChooseCardTypeViewDelegate>
@property(nonatomic,strong)ScrollPageView * scrollPageView;
@property(nonatomic,strong)NSArray * childViewControllers;
@property(nonatomic,strong)ChooseCardTypeView * chooseCardTypeView;
@end

@implementation MyTestSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的考级";
    [self initSubview];
}

-(void)initSubview{
    [self.view addSubview:self.chooseCardTypeView];
    [self.view addSubview:self.scrollPageView];
    
    
    if(_childViewControllers == nil || _childViewControllers.count == 0){
        
        NSMutableArray * VCArray = [NSMutableArray arrayWithCapacity:3];
        
        for (NSInteger i = 0; i < self.titles.count; i ++) {
            TestedController * VC1 = [[TestedController alloc]init];
            VC1.state = i;
            [self addChildViewController:VC1];
            [self.scrollPageView addPage:VC1.view];
            [VCArray addObject:VC1];
        }
//        TestedController * VC1 = [[TestedController alloc]init];
//        [self addChildViewController:VC1];
//        [self.scrollPageView addPage:VC1.view];
//        [VCArray addObject:VC1];
//
//        TestedController * VC2 = [[TestedController alloc]init];
//        [self addChildViewController:VC2];
//        [self.scrollPageView addPage:VC2.view];
//        [VCArray addObject:VC2];
//        _childViewControllers = VCArray.copy;
    }

}

#pragma mark - ScrollPageViewDelegate,ChooseCardTypeViewDelegate
-(void)scrollPageView:(ScrollPageView *)aView didScrollToPageIndex:(NSInteger)index{

    [self.chooseCardTypeView setSelectIndex:index];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ChangeTestState" object:@{@"index":@(index)}]];
}

-(void)chooseCardTypeView:(ChooseCardTypeView *)aView didSelectIndex:(NSInteger)index{
    
    [self.scrollPageView setSelectPage:index];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ChangeTestState" object:@{@"index":@(index)}]];
}

- (ChooseCardTypeView *)chooseCardTypeView
{
    if (!_chooseCardTypeView) {
        
        _chooseCardTypeView = [[ChooseCardTypeView alloc]initWithFrame:CGRectMake(0, 16, SCREEN_WDITH, 42)];
        [_chooseCardTypeView setHeadTitleArray:self.titles];
        _chooseCardTypeView.delegate = self;
    }
    
    return _chooseCardTypeView;
}

- (NSArray *)titles{
    return @[@"未考",@"已考",@"缺考"];
}

- (ScrollPageView*)scrollPageView
{
    if (!_scrollPageView) {
        
        _scrollPageView = [[ScrollPageView alloc]initWithFrame:CGRectMake(0, 58, SCREEN_WDITH, SCREEN_HEIGHT - StatusBarHeight - 44.0f - 58.0f)];
        _scrollPageView.delagate = self;
        [_scrollPageView scrollEnabled:YES];
        
    }
    return _scrollPageView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ChangeTestState" object:@{@"index":@(-1)}]];
}

@end
