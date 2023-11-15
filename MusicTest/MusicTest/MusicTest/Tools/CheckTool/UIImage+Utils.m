//
//  UIImage+Utils.m
//  MusicTest
//
//  Created by LZZ on 2020/12/2.
//  Copyright © 2020 CF. All rights reserved.
//

#import "UIImage+Utils.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Utils)

+(UIImage *)getThumbnailImage:(NSURL *)videoURL size:(CGSize)size{

    if (videoURL) {
        // 获取视频第一帧
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        generator.appliesPreferredTrackTransform = YES;
        generator.maximumSize = CGSizeMake(size.width, size.height);
        NSError *error = nil;
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(3, 5) actualTime:NULL error:&error];
        int index = 2;
        while (error && index < 10) {
            error = nil;
            index ++;
            img = [generator copyCGImageAtTime:CMTimeMake(index, 5) actualTime:NULL error:&error];
        }
        {
            return [UIImage imageWithCGImage:img];
        }
        return nil;
    } else {

        UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];

        return placeHoldImg;

    }
}

@end
