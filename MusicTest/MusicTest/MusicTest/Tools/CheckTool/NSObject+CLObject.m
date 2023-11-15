//
//  NSObject+CLObject.m
//  CashLoan
//
//  Created by iOSDev on 2017/10/12.
//  Copyright © 2017年 daihoubang. All rights reserved.
//

#import "NSObject+CLObject.h"

@implementation NSObject (CLObject)
BOOL CLIsEmpty(id obj) {
    return ((obj) == nil || [(obj) isEqual:[NSNull null]]);
}

BOOL CLIsNotEmpty(id obj) {
    return !CLIsEmpty(obj);
}

- (BOOL)cl_isNSDictionary {
    return [self isKindOfClass:[NSDictionary class]];
}
- (BOOL)cl_isNSArray {
    return [self isKindOfClass:[NSArray class]];
}
- (BOOL)cl_isNSString {
    return [self isKindOfClass:[NSString class]];
}
- (BOOL)cl_isNSNumber {
    return [self isKindOfClass:[NSNumber class]];
}
- (BOOL)cl_isNSNumberBool {
    if (self == (id)kCFBooleanFalse || self == (id)kCFBooleanTrue) {
        return YES;
    }
    return NO;
}
- (BOOL)cl_isNSDate {
    return [self isKindOfClass:[NSDate class]];
}
- (BOOL)cl_isNSNull {
    return [self isKindOfClass:[NSNull class]];
}

@end
