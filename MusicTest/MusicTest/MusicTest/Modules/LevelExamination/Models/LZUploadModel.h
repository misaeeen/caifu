//
//  LZUploadModel.h
//  MusicTest
//
//  Created by LZZ on 2020/12/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZUploadModel : NSObject

@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, strong) NSString *uploadAddress;
@property (nonatomic, strong) NSString *uploadAuth;
@property (nonatomic, strong) NSString *videoId;

@end

NS_ASSUME_NONNULL_END
