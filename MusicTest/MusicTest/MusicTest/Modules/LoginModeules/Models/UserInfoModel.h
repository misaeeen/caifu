//
//  UserInfoModel.h
//  MusicTest
//
//  Created by LZZ on 2020/11/22.
//  Copyright © 2020 CF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END
