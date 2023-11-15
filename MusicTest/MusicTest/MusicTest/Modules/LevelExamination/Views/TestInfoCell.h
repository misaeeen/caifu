//
//  TestInfoCell.h
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LZTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestInfoCell : UITableViewCell

- (void)reloadWithModel:(LZTestModel *)model state:(LZTestState) state;

@end

NS_ASSUME_NONNULL_END
