//
//  LZTestDetailsModel.h
//  MusicTest
//
//  Created by LZZ on 2020/12/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LZUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LZTestDetailsModel : NSObject

@property (nonatomic, strong) NSString * book; //考级教材
@property (nonatomic, strong) NSString * chapter; //考级曲目
@property (nonatomic, strong) NSString * comments; //评语
@property (nonatomic, strong) NSString * examEndTime; //考试结束时间
@property (nonatomic, strong) NSString * examStartTime; //考试开始时间
@property (nonatomic, strong) NSString * examNo; //准考证号
@property (nonatomic, strong) NSString * examTime; //考试时间
@property (nonatomic, strong) NSString * grade; //评分等级 1 不及格 2 及格 3 良好 4 优秀
@property (nonatomic, strong) NSString * id; //考级报名编号
@property (nonatomic, strong) NSString * level; //考级级别
@property (nonatomic, strong) LZUserModel * profile; //用户资料
@property (nonatomic, strong) NSString * playAuth; //考试视频播放凭证
@property (nonatomic, strong) NSString * score; //分数
@property (nonatomic, strong) NSString * status; //考级状态 0 待审核 1 待付费 2 待考 3 待评审 4 已完成 5 审核失败 6 缺考
@property (nonatomic, assign) NSInteger examNum; //应考曲目数量
@property (nonatomic, assign) NSInteger recordCnt; //录制次数
@property (nonatomic, assign) NSInteger resetTimes; // 可重置次数

@property (nonatomic, strong) NSString * subject; //考级科目
@property (nonatomic, strong) NSString * title; //考级备案标题
@property (nonatomic, strong) NSString * videoCover; //考试视频封面
@property (nonatomic, strong) NSString * videoDuration; //考试视频时长
@property (nonatomic, strong) NSString * videoId; //考试视频编号
@property (nonatomic, strong) NSString * isIssued; //考试是否公布成绩 0 未公布 1已公布 ,

//@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, assign) BOOL isSimulation; // 是否是模拟



@end

NS_ASSUME_NONNULL_END
