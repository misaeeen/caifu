//
//  UIButton+KitCore.m
//  MusicTest
//
//  Created by LZZ on 2020/12/4.
//  Copyright © 2020 CF. All rights reserved.
//

#import "UIButton+KitCore.h"

@implementation UIButton (KitCore)

+ (instancetype)createButtonWithTitleColor:(UIColor *)color font:(UIFont *)font{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    return btn;
}

@end
