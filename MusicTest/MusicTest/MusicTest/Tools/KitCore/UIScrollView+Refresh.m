//
//  UIScrollView+Refresh.m
//  MusicTest
//
//  Created by LZZ on 2020/12/4.
//  Copyright © 2020 CF. All rights reserved.
//

#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Refresh)

// 根据刷新状态停止
- (void)endRefreshing:(kRefreshStatus)status {
    switch (status) {
        case kRefreshFooter:
            if (self.mj_footer) {
                if (self.mj_footer.isRefreshing) {
                    [self.mj_footer endRefreshing];
                }
            }
            break;
            
        case kRefreshHeader:
            if (self.mj_header.isRefreshing) {
                [self.mj_header endRefreshing];
            }
            break;
            
        case kRefreshAll: {
            if (self.mj_header.isRefreshing) {
                [self.mj_header endRefreshing];
            }
            if (self.mj_footer) {
                if (self.mj_footer.isRefreshing) {
                    [self.mj_footer endRefreshing];
                }
            }
            break;
        }
        default:
            break;
    }
}

/// 设置头刷新
- (void)setRefreshHeaderWithBlock:(MJRefreshComponentAction)refreshingBlock {
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
}

//// 设置上拉更多，
- (void)setRefreshFooter:(BOOL)hide withBlock:(MJRefreshComponentAction)refreshingBlock {
    if (!self.mj_footer) {
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshingBlock];
    }
    self.mj_footer.hidden = hide;
}

@end
