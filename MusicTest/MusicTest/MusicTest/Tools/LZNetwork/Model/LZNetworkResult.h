//
//  LZNetworkResult.h
//  MusicTest
//
//  Created by LZZ on 2020/12/3.
//  Copyright © 2020 CF. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 请求状态枚举
typedef NS_ENUM(NSInteger, LZNetworkStatus) {
    LZNetworkStatusSuccess                 = 200,  /// 成功
};

@interface LZNetworkResult : NSObject

/// 请求返回msg
@property (nonatomic, copy) NSString *msg;
/// code
@property (nonatomic) LZNetworkStatus code;
/// data数据
@property (nonatomic, copy) id data;
/// 请求是否成功
@property (nonatomic, readonly) BOOL isSuccess;

@end

