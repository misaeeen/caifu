//
//  VideoPlayCell.h
//  MusicTest
//
//  Created by LZZ on 2020/12/8.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^BtnClickBlock)(NSIndexPath *indexPath);


NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic,copy) BtnClickBlock leftBtnClick;
@property (nonatomic,copy) BtnClickBlock rightBtnClick;

- (void)reloadWithModel:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
