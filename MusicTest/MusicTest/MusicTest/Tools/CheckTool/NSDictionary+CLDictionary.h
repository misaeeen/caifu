//
//  NSDictionary+CLDictionary.h
//  CashLoan
//
//  Created by iOSDev on 2017/10/12.
//  Copyright © 2017年 daihoubang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CLObject.h"
NS_ASSUME_NONNULL_BEGIN
/*!
 *  是否是空字典
 */
extern BOOL CLIsEmptyDictionary(NSDictionary *dict);

/*!
 *  不是空字典
 */
extern BOOL CLIsNotEmptyDictionary(NSDictionary *dict);


extern NSDictionary * const _Nonnull CLNoNilDictionary(NSDictionary * dict);

@interface NSDictionary (CLDictionary)

@end
NS_ASSUME_NONNULL_END
