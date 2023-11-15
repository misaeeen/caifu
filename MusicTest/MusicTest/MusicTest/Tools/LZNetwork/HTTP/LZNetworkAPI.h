//
//  LZNetworkAPI.h
//  MusicTest
//
//  Created by LZZ on 2020/12/3.
//  Copyright © 2020 CF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZNetworkResult.h"

@class AFHTTPSessionManager;

/// block
typedef void(^LZNetworkBlock)(LZNetworkResult *result,NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface LZNetworkAPI : NSObject

/// 请求session
@property (nonatomic, class, readonly) AFHTTPSessionManager *session;
/// base url
@property (nonatomic, class, readonly) NSString *baseURLString;
/// timeoutInterval
@property (nonatomic, class, readonly) NSTimeInterval baseTimeout;

+ (NSString *)baseURLString;

/**
 POST请求 ，地址后缀，无缓存
 */
+ (NSURLSessionTask *)POST:(NSString *)urlSuffix
                     param:(NSDictionary *)param
                     block:(LZNetworkBlock)block;



/// get请求
+ (NSURLSessionTask *)GET:(NSString *)urlSuffix
                    param:(NSDictionary *)param
                    block:(LZNetworkBlock)block;

/// 图片上传
+ (NSURLSessionTask *)POST:(NSString *)urlSuffix
                     image:(UIImage *)image
                 parmeters:(NSDictionary *)param
                     block:(LZNetworkBlock)block;
                                 

@end

NS_ASSUME_NONNULL_END
