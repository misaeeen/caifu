//
//  TestFormalViewController.h
//  MusicTest
//
//  Created by LZZ on 2020/11/11.
//  Copyright © 2020 CF. All rights reserved.
//

#import "BaseViewController.h"
#import "LZTestDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestFormalViewController : BaseViewController

@property (nonatomic, strong) LZTestDetailsModel *model;
@property (nonatomic, assign) BOOL isFromCaptruePage;

@end

NS_ASSUME_NONNULL_END
