//
//  HomeControllerViewCell.h
//  MusicTest
//
//  Created by LZZ on 2020/11/12.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeControllerViewCell : UITableViewCell
@property(nonatomic,strong)RACSubject * homeViewCellDidSelectSubject;
-(void)reloadDataWithArray:(NSArray *)data;
@end

NS_ASSUME_NONNULL_END
