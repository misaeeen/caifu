//
//  NSObject+CLObject.h
//  CashLoan
//
//  Created by iOSDev on 2017/10/12.
//  Copyright © 2017年 daihoubang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 *  是否是空对象
 */
extern BOOL CLIsEmpty(id obj);

/*!
 *  不是空对象
 */
extern BOOL CLIsNotEmpty(id obj);

@interface NSObject (CLObject)

#pragma mark - 类型判断
- (BOOL)cl_isNSDictionary;
- (BOOL)cl_isNSArray;
- (BOOL)cl_isNSString;
- (BOOL)cl_isNSNumber;
- (BOOL)cl_isNSNumberBool;
- (BOOL)cl_isNSDate;
- (BOOL)cl_isNSNull;

@end
NS_ASSUME_NONNULL_END
