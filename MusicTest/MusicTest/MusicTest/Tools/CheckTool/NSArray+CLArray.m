//
//  NSArray+CLArray.m
//  CashLoan
//
//  Created by iOSDev on 2017/10/12.
//  Copyright © 2017年 daihoubang. All rights reserved.
//

#import "NSArray+CLArray.h"

@implementation NSArray (CLArray)

BOOL CLIsEmptyArray(NSArray *array) {
    if (CLIsEmpty(array) || NO == [array isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return array.count == 0;
}
BOOL CLIsNotEmptyArray(NSArray *array) {
    return !CLIsEmptyArray(array);
}
NSArray * CLNoNilArray(id array) {
    if (CLIsEmpty(array) || ![array isKindOfClass:[NSArray class]]) {
        return @[];
    }
    return array;
}
@end
