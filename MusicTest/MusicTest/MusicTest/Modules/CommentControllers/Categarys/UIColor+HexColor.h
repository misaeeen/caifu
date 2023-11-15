//
//  UIColor+HexColor.h
//  LGTT1
//
//  Created by dhb on 2018/8/30.
//  Copyright © 2018年 dhb. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ColorWithHex(hex) [UIColor colorWithHexString:hex]

@interface UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
