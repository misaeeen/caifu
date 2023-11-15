//
//  ChooseTestCell.h
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LZTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseTestCell : UITableViewCell

- (void)reloadWithModel:(LZTestModel *)model;

@end

NS_ASSUME_NONNULL_END
