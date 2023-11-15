//
//  NSString+CLString.h
//  CashLoan
//
//  Created by iOSDev on 2017/10/12.
//  Copyright © 2017年 daihoubang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CLObject.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 *  是否是空字符串
 */
extern BOOL const CLIsEmptyString(NSString *str);
/*!
 *  不是空字符串
 */
extern BOOL const CLIsNotEmptyString(NSString *str);
/*!
 *  剔除空字符串
 */
extern NSString * _Nonnull CLNoNilString(id str);
@interface NSString (CLString)

+ (NSString *)md5EncryptWithString:(NSString *)string;

+ (CGFloat)caculateTheHeightWithString:(NSString *)string width:(CGFloat)width;

// 时间搓转换
- (NSString *)timerTransfer;
// 当前时间搓转换
+ (NSString *)getCurrentTimeString;

@end
NS_ASSUME_NONNULL_END
