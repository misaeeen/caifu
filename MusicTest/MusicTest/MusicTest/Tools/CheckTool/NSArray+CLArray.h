//
//  NSArray+CLArray.h
//  CashLoan
//
//  Created by iOSDev on 2017/10/12.
//  Copyright © 2017年 daihoubang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+CLObject.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 *  是否是空数组
 */
extern BOOL CLIsEmptyArray(NSArray *array);

/**
 *  不是空数组
 */
extern BOOL CLIsNotEmptyArray(NSArray *array);

/*!
 *  防止出现空数组
 */
extern NSArray * _Nonnull CLNoNilArray(id array);
@interface NSArray (CLArray)

@end
NS_ASSUME_NONNULL_END
