//
//  UIScrollView+Refresh.h
//  MusicTest
//
//  Created by LZZ on 2020/12/4.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    刷新状态
 */
typedef NS_ENUM(NSInteger,kRefreshStatus) {
    kRefreshNormal = 0,   /**<没有刷新状态*/
    kRefreshHeader,       /**<下拉*/
    kRefreshFooter,       /**<上拉*/
    kRefreshAll,          /**<全部*/
};

NS_ASSUME_NONNULL_BEGIN



@interface UIScrollView (Refresh)

/**
 根据刷新状态停止，配合MJRefresh使用
 
 @param status 刷新状态
 */
- (void)endRefreshing:(kRefreshStatus)status;

/// 设置头刷新
- (void)setRefreshHeaderWithBlock:(MJRefreshComponentAction)refreshingBlock;

/// 设置上拉加载更多
- (void)setRefreshFooter:(BOOL)hide withBlock:(MJRefreshComponentAction)refreshingBlock;

@end

NS_ASSUME_NONNULL_END
