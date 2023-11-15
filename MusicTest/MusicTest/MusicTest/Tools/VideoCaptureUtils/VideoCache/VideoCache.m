//
//  VideoCache.m
//  MusicTest
//
//  Created by LZZ on 2020/11/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import "VideoCache.h"

@implementation VideoCache

+ (NSArray *)loadVideoURLWithId:(NSString *)id{
    return [[NSUserDefaults standardUserDefaults] objectForKey:id];
}

+ (void)saveVideoURL:(NSString *)videoURL id:(NSString *)id{
    NSMutableArray *urls = [[[NSUserDefaults standardUserDefaults] objectForKey:id] mutableCopy];
    if(!urls){
        urls = [NSMutableArray array];
    }
    [urls addObject:videoURL];
    [[NSUserDefaults standardUserDefaults] setObject:urls.copy forKey:id];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveId:id];
}

+ (void)removeVideoWithId:(NSString *)id{
    NSArray *urls = [[NSUserDefaults standardUserDefaults] objectForKey:id];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:id];
    [[NSUserDefaults standardUserDefaults] synchronize];
    for(NSString *urlStr in urls){
        if ([[NSFileManager defaultManager] fileExistsAtPath:urlStr]){
            [[NSFileManager defaultManager] removeItemAtPath:urlStr error:nil];
        }
    }
    [self removeId:id];
}


+ (NSInteger)loadTestedCountWithId:(NSString *)id{
    return [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_count",id]];
}

+ (void)saveTestedCountWithId:(NSString *)id testedCount:(NSInteger)testedCount{
    [[NSUserDefaults standardUserDefaults] setInteger:testedCount forKey:[NSString stringWithFormat:@"%@_count",id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)removeTestedCountWithId:(NSString *)id{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_count",id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)removeId:(NSString *)id{
    NSMutableArray *ids = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videoAllCacheId"] mutableCopy];
    if(!ids){
        ids = [NSMutableArray array];
    }
    if([ids containsObject:id]){
        [ids removeObject:id];
    }
    [[NSUserDefaults standardUserDefaults] setObject:ids.copy forKey:@"videoAllCacheId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)saveId:(NSString *)id{
    NSMutableArray *ids = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videoAllCacheId"] mutableCopy];
    if(!ids){
        ids = [NSMutableArray array];
    }
    if(![ids containsObject:id]){
        [ids addObject:id];
        [[NSUserDefaults standardUserDefaults] setObject:ids.copy forKey:@"videoAllCacheId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
+ (NSArray *)videoAllCacheId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"videoAllCacheId"];
}

+ (void)removeAllVideoCache{
    NSArray *ids = [[NSUserDefaults standardUserDefaults] objectForKey:@"videoAllCacheId"];
    for (NSString *idt in ids) {
        [self removeVideoWithId:idt];
        [self removeTestedCountWithId:idt];
    }
}


@end
