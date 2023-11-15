//
//  Aes.h
//  MusicTest
//
//  Created by LZZ on 2021/1/31.
//  Copyright © 2021 CF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Aes : NSObject

/// 加密
+ (NSString*)AES128Encrypt:(NSString *)plainText;
/// 解密
+ (NSString*)AES128Decrypt:(NSString *)encryptText;

@end

NS_ASSUME_NONNULL_END
