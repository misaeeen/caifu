//
//  VideoCaptureController.h
//  MusicTest
//
//  Created by LZZ on 2020/11/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import "BaseViewController.h"
#import "LZTestDetailsModel.h"

typedef void(^FinishCaptureBlock)(LZTestDetailsModel *model,BOOL finished);

@interface VideoCaptureController : BaseViewController

@property (nonatomic, strong) LZTestDetailsModel *model;
@property (nonatomic, strong) LZTestInfoModel *testinfoModel;

@property (nonatomic, copy) FinishCaptureBlock finishBlock;

@end

