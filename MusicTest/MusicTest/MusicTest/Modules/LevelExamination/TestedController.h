//
//  TestedController.h
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSUInteger, LZTestState) {
//    LZTestStateNotTested = 0, /// 未考
//    LZTestStateTested,  /// 已考
//    LZTestStateLackTested /// 缺考
//};

NS_ASSUME_NONNULL_BEGIN

@interface TestedController : UIViewController

@property (nonatomic, assign) LZTestState state;

@end

NS_ASSUME_NONNULL_END
