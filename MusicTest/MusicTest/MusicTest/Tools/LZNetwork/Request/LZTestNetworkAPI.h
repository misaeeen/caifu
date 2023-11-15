//
//  LZTestNetworkAPI.h
//  MusicTest
//
//  Created by LZZ on 2020/12/4.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZNetworkAPI.h"

NS_ASSUME_NONNULL_BEGIN


/// 考试API
@interface LZTestNetworkAPI : LZNetworkAPI


/// 获取考级列表
/// @param page 页数
/// @param status 报名状态: -1 全部 0 待审核 1 待付费 2 待考 3 待评审 4 已完成 5 审核失败 6 缺考
/// @param block 回调
+ (void)loadListWithPage:(NSInteger)page status:(NSInteger)status block:(LZNetworkBlock)block;

/// 查询已考列表
/// @param page 页数
/// @param block 回调
+ (void)loadTestedWithPage:(NSInteger)page block:(LZNetworkBlock)block;

/// 获取报名详情
/// @param id 报名id
/// @param block 回调
+ (void)loadTestDetailsWithId:(NSString *)id block:(LZNetworkBlock)block;


/// 获取考级教材
/// @param examDataId 考级报名编号
/// @param subject 考试科目
/// @param level 考试级别
/// @param block 回调
+ (void)loadBooksWithExamDataId:(NSString *)examDataId subject:(NSString *)subject level:(NSString *)level block:(LZNetworkBlock)block;


/// 获取考级曲目
/// @param examDataId 考级报名编号
/// @param subject 考试科目
/// @param level 考试级别
/// @param block 回调
+ (void)loadSongsWithExamDataId:(NSString *)examDataId subject:(NSString *)subject level:(NSString *)level block:(LZNetworkBlock)block;

/// 获取考级曲目
/// @param id 考级报名编号
/// @param book 考试教材
/// @param chapter 考试曲目
/// @param block 回调
+ (void)saveTestWithId:(NSString *)id book:(NSString *)book chapter:(NSString *)chapter block:(LZNetworkBlock)block;

/// 获取视频上传标识
/// @param vid 考级报名编号
/// @param fileExt 文件扩展名，如mp4等
/// @param block 回调
+ (void)loadUploadIdWithId:(NSString *)vid fileExt:(NSString *)fileExt block:(LZNetworkBlock)block;

/// 刷新视频上传标识
/// @param videoId 视频Id
/// @param block 回调
+ (void)refreshUploadIdWithVideoId:(NSString *)videoId block:(LZNetworkBlock)block;

///考级提交确认
/// @param id 考级报名编号
/// @param videoId 视频Id
/// @param block 回调
+ (void)videoUploadConfirmWithId:(NSString *)id videoId:(NSString *)videoId block:(LZNetworkBlock)block;
///考级次数计数
/// @param id 考级报名编号
/// @param block 回调
+ (void)testCountWithId:(NSString *)id block:(LZNetworkBlock)block;

///  上传图片
+ (void)testUploadImage:(UIImage *)image block:(LZNetworkBlock)block;

+ (void)authWithVideoId:(NSString *)videoId block:(LZNetworkBlock)block;
@end

NS_ASSUME_NONNULL_END
