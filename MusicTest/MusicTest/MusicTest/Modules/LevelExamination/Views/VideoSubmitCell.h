//
//  VideoSubmitCell.h
//  MusicTest
//
//  Created by LZZ on 2021/5/30.
//  Copyright © 2021 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickBlock)(NSIndexPath *indexPath);
NS_ASSUME_NONNULL_BEGIN

@interface VideoSubmitCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic,copy) ClickBlock leftBtnClick;
@property (nonatomic,copy) ClickBlock rightBtnClick;

- (void)reloadWithModel:(LZTestInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
