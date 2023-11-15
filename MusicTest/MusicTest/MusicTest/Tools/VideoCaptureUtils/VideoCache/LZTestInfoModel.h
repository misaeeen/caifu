//
//  LZTestInfoModel.h
//  MusicTest
//
//  Created by LZZ on 2021/5/30.
//  Copyright © 2021 CF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZTestInfoModel : NSObject

@property (nonatomic,strong) NSString *test_id; // 考试编号
@property (nonatomic,strong) NSString *video_path; // 视频地址
@property (nonatomic,assign) NSInteger isFinish; // 是否完成考试
@property (nonatomic,assign) NSInteger testedCount; //第几次考试

@end

NS_ASSUME_NONNULL_END
