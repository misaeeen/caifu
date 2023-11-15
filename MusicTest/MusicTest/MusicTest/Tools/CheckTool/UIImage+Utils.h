//
//  UIImage+Utils.h
//  MusicTest
//
//  Created by LZZ on 2020/12/2.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)

+(UIImage *)getThumbnailImage:(NSURL *)videoURL size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
