//
//  TestInfoCache.h
//  MusicTest
//
//  Created by LZZ on 2021/5/30.
//  Copyright © 2021 CF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZTestInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 考试信息缓存
@interface TestInfoCache : NSObject
/// 保存考试信息到缓存
+ (void)saveTestInfoWithModel:(LZTestInfoModel *)model;

/// 获取指定的考试信息缓存
+ (NSArray <LZTestInfoModel *> *)loadTestInfoWithId:(NSString *)tid;
/// 获取指定的考试次数
+ (NSInteger)loadTestCountWithId:(NSString *)tid;

/// 删除指定的考试信息缓存
+ (void)removeCacheWithId:(NSString *)tid;

/// 删除所有缓存
+ (void)removeAllCache;

@end

NS_ASSUME_NONNULL_END
