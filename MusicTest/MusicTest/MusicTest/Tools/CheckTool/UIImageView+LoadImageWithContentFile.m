//
//  UIImageView+LoadImageWithContentFile.m
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import "UIImageView+LoadImageWithContentFile.h"


@implementation UIImageView (LoadImageWithContentFile)
+(UIImage *)loadImageWithImageName:(NSString *)imageName{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}
@end
