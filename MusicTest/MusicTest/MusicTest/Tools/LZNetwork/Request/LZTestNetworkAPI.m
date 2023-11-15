//
//  LZTestNetworkAPI.m
//  MusicTest
//
//  Created by LZZ on 2020/12/4.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZTestNetworkAPI.h"

static NSInteger const LZPageSize = 10;

@implementation LZTestNetworkAPI

+ (void)loadListWithPage:(NSInteger)page status:(NSInteger)status block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"pageNum":@(page),
        @"pageSize":@(LZPageSize),
        @"status":@(status)
    };
    [self GET:@"/1.0/exam/enrolled/list" param:param block:block];
}

+ (void)loadTestedWithPage:(NSInteger)page block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"pageNum":@(page),
        @"pageSize":@(LZPageSize),
    };
    [self GET:@"/1.0/exam/tested/list" param:param block:block];
}

+ (void)loadTestDetailsWithId:(NSString *)id block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"id":id
    };
    [self GET:@"/1.0/exam/enrolled/details" param:param block:block];
}

+ (void)loadBooksWithExamDataId:(NSString *)examDataId subject:(NSString *)subject level:(NSString *)level block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"examDataId":examDataId,
        @"subject":subject,
        @"level":level
    };
    [self GET:@"/1.0/exam/book" param:param block:block];
}

+ (void)loadSongsWithExamDataId:(NSString *)examDataId subject:(NSString *)subject level:(NSString *)level block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"examDataId":examDataId,
        @"subject":subject,
        @"level":level
    };
    [self GET:@"/1.0/exam/content" param:param block:block];
}

+ (void)saveTestWithId:(NSString *)id book:(NSString *)book chapter:(NSString *)chapter block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"id":id,
        @"book":book,
        @"chapter":chapter
    };
    [self POST:@"/1.0/exam/save" param:param block:block];
}

+ (void)loadUploadIdWithId:(NSString *)vid fileExt:(NSString *)fileExt block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"id":vid,
        @"fileExt":fileExt
    };
    [self GET:@"/1.0/exam/video/upload/auth" param:param block:block];
}

+ (void)refreshUploadIdWithVideoId:(NSString *)videoId block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"videoId":videoId
    };
    [self GET:@"/1.0/exam/video/upload/auth/refresh" param:param block:block];
}

+ (void)videoUploadConfirmWithId:(NSString *)id videoId:(NSString *)videoId block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"id":id,
        @"videoId":videoId
    };
    [self POST:@"/1.0/exam/confirm" param:param block:block];
}
///考级次数计数
/// @param id 考级报名编号
/// @param block 回调
+ (void)testCountWithId:(NSString *)id block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"id":id
    };
    [self POST:@"/1.0/exam/recordTimes/count" param:param block:block];
}

+ (void)testUploadImage:(UIImage *)image block:(LZNetworkBlock)block{
    [self POST:@"/1.0/exam/examinee/photo/upload" image:image parmeters:@{} block:block];
}

+ (void)authWithVideoId:(NSString *)videoId block:(LZNetworkBlock)block{
    NSDictionary *param = @{
        @"videoId":videoId
    };
    [self GET:@"/1.0/exam/video/play/auth" param:param block:block];
}

@end
