//
//  NSString+CLString.m
//  CashLoan
//
//  Created by iOSDev on 2017/10/12.
//  Copyright © 2017年 daihoubang. All rights reserved.
//

#import "NSString+CLString.h"
#import <CommonCrypto/CommonDigest.h>
static NSString * const key = @"fnsc";
@implementation NSString (CLString)
/*!
 *  是否是空字符串
 */
BOOL const CLIsEmptyString(NSString *str) {
    return !CLIsNotEmptyString(str);
}
/*!
 *  不是空字符串
 */
BOOL const CLIsNotEmptyString(NSString *str) {
    return CLIsNotEmpty(str) && [str isKindOfClass:[NSString class]] && str.length > 0;
}
/*!
 *  剔除空字符串
 */
NSString * _Nonnull CLNoNilString(id str) {
    if (CLIsEmpty(str)) {
        return @"";
    }else{
       return [NSString stringWithFormat:@"%@",str];
    }
}

+ (NSString *)md5EncryptWithString:(NSString *)string{
    return [self MD5WithString:[NSString stringWithFormat:@"%@%@", key, string]];
}

+ (NSString *)MD5WithString:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}

+ (CGFloat)caculateTheHeightWithString:(NSString *)string width:(CGFloat)width{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]} context:nil];
    if (rect.size.height > 0) {
        return rect.size.height;
    }
    return 0;
}

-(NSString *)timerTransfer{
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    long long time = [self longLongValue] / 1000;

    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString*timeString=[formatter stringFromDate:date];

    return timeString;
}

+ (NSString *)getCurrentTimeString{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    return dateTime;
}


@end
