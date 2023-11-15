//
//  NSNumber+CLNumber.m
//  CashLoan
//
//  Created by iOSDev on 2017/10/12.
//  Copyright © 2017年 daihoubang. All rights reserved.
//

#import "NSNumber+CLNumber.h"

@implementation NSNumber (CLNumber)
NSNumber * const CLNoNilNumber(NSNumber *number) {
    if (CLIsEmpty(number)) {
        return @0;
    }
    return number;
}
@end

