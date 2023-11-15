//
//  NSDictionary+CLDictionary.m
//  CashLoan
//
//  Created by iOSDev on 2017/10/12.
//  Copyright © 2017年 daihoubang. All rights reserved.
//

#import "NSDictionary+CLDictionary.h"

@implementation NSDictionary (CLDictionary)

/*!
 *  是否是空字典
 */
BOOL CLIsEmptyDictionary(NSDictionary *dict) {
    if (CLIsEmpty(dict)) {
        return YES;
    }
    return dict.count <= 0;
}

/*!
 *  不是空字典
 */
BOOL CLIsNotEmptyDictionary(NSDictionary *dict) {
    return !CLIsEmptyDictionary(dict);
}


NSDictionary * const _Nonnull CLNoNilDictionary(NSDictionary * dict) {
    if (CLIsEmpty(dict)) {
        return @{};
    }
    return dict;
}
@end
