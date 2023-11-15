//
//  UIAlertAction+Index.m
//  MusicTest
//
//  Created by LZZ on 2021/5/30.
//  Copyright © 2021 CF. All rights reserved.
//

#import "UIAlertAction+Index.h"
#import <objc/runtime.h>

static NSString *const Index_Key = @"Index_Key";

@implementation UIAlertAction (Index)

- (void)setIndex:(NSInteger)index{
    objc_setAssociatedObject(self, &Index_Key, @(index), OBJC_ASSOCIATION_ASSIGN);
}
 
- (NSInteger)index{
    return [objc_getAssociatedObject(self, &Index_Key) integerValue];
}

@end
