//
//  UILabel+KitCore.m
//  MusicTest
//
//  Created by LZZ on 2020/12/4.
//  Copyright © 2020 CF. All rights reserved.
//

#import "UILabel+KitCore.h"

@implementation UILabel (KitCore)

+ (instancetype)createWithColor:(UIColor *)color font:(UIFont *)font{
    UILabel *label = [[self alloc] init];
    label.textColor = color;
    label.font = font;
    return label;
}

@end
