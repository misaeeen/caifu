//
//  LZBannerModel.h
//  MusicTest
//
//  Created by LZZ on 2020/12/14.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZNetworkAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZBannerModel : LZNetworkAPI

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *seq;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;

@end

NS_ASSUME_NONNULL_END
