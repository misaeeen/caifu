//
//  TestInfoCache.m
//  MusicTest
//
//  Created by LZZ on 2021/5/30.
//  Copyright © 2021 CF. All rights reserved.
//

#import "TestInfoCache.h"

static NSString *const TESTINFO_CACHE_KEY = @"TESTINFO_CACHE_KEY";  // 缓存Key
static NSString *const TESTINFO_LIST = @"TESTINFO_LIST"; // 考试信息列表
static NSString *const TEST_COUNT = @"TEST_COUNT"; // 考试次数
@implementation TestInfoCache

+ (NSMutableDictionary *)loadAllCache{
    NSMutableDictionary *cache = [[[NSUserDefaults standardUserDefaults] objectForKey:TESTINFO_CACHE_KEY] mutableCopy];
    if (cache == nil) {
        cache = [NSMutableDictionary dictionary];
    }
    return cache;
}
+ (void)saveWithCache:(NSMutableDictionary *)cache{
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:TESTINFO_CACHE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 保存考试信息到缓存
+ (void)saveTestInfoWithModel:(LZTestInfoModel *)model{
    NSMutableDictionary *cache = [TestInfoCache loadAllCache];
    NSMutableDictionary *testInfo = [[cache objectForKey:model.test_id] mutableCopy];
    if (testInfo == nil) {
        testInfo = [NSMutableDictionary dictionary];
    }
    
    [testInfo setObject:@(model.testedCount) forKey:TEST_COUNT];
    NSMutableArray *tests = [[testInfo objectForKey:TESTINFO_LIST] mutableCopy];
    if (tests.count == 0) {
        tests = [NSMutableArray array];
    }
    for (NSInteger i = 0; i < tests.count; i ++) {
        LZTestInfoModel *testModel = [LZTestInfoModel yy_modelWithJSON:tests[i]];
        if (testModel.testedCount == model.testedCount) {
            [tests removeObjectAtIndex:i];
            i --;
        }
    }
    [tests addObject:[model yy_modelToJSONString]];
    [testInfo setObject:tests forKey:TESTINFO_LIST];
    
    [cache setObject:testInfo forKey:model.test_id];
    [TestInfoCache saveWithCache:cache];
}

/// 获取指定的考试信息缓存
+ (NSArray <LZTestInfoModel *> *)loadTestInfoWithId:(NSString *)tid{
    NSMutableDictionary *cache = [TestInfoCache loadAllCache];
    NSMutableDictionary *testInfo = [cache objectForKey:tid];
    if (testInfo != nil) {
        NSMutableArray *tests = [testInfo objectForKey:TESTINFO_LIST];
        if (tests != nil) {
            NSMutableArray *testinfos = [NSMutableArray array];
            for (NSString *json in tests) {
                [testinfos addObject:[LZTestInfoModel yy_modelWithJSON:json]];
            }
            return testinfos.copy;
        }
    }
    return nil;
}

/// 获取指定的考试次数
+ (NSInteger)loadTestCountWithId:(NSString *)tid{
    NSMutableDictionary *cache = [TestInfoCache loadAllCache];
    NSMutableDictionary *testInfo = [cache objectForKey:tid];
    if (testInfo != nil) {
        return [[testInfo objectForKey:TEST_COUNT] integerValue];
    }else{
        return 0;
    }
}

/// 删除指定的考试信息缓存
+ (void)removeCacheWithId:(NSString *)tid{
    NSMutableDictionary *cache = [TestInfoCache loadAllCache];
    NSMutableDictionary *testInfo = [[cache objectForKey:tid] mutableCopy];
    if(testInfo != nil){
        NSMutableArray *testInfos = [testInfo objectForKey:TESTINFO_LIST];
        NSMutableArray <LZTestInfoModel *> *tests = [NSMutableArray array];
        for (NSString *json in testInfos) {
            [tests addObject:[LZTestInfoModel yy_modelWithJSON:json]];
        }
        for(LZTestInfoModel *model in tests){
            if ([[NSFileManager defaultManager] fileExistsAtPath:model.video_path]){
                [[NSFileManager defaultManager] removeItemAtPath:model.video_path error:nil];
            }
        }
        [cache removeObjectForKey:tid];
    }
    [TestInfoCache saveWithCache:cache];
}

/// 删除所有缓存
+ (void)removeAllCache{
    NSMutableDictionary *cache = [TestInfoCache loadAllCache];
    for (NSString *key in cache.allKeys) {
        [TestInfoCache removeCacheWithId:key];
    }
    [cache removeAllObjects];
    [TestInfoCache saveWithCache:cache];
}

@end
