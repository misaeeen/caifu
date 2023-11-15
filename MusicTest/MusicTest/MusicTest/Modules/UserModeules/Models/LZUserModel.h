//
//  LZUserModel.h
//  MusicTest
//
//  Created by LZZ on 2020/12/7.
//  Copyright © 2020 CF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZUserModel : NSObject

@property (nonatomic,strong) NSString *address; // 详细地址 ,
@property (nonatomic,strong) NSString *birthday;// 生日 ,
@property (nonatomic,strong) NSString *city;// 城市 ,
@property (nonatomic,strong) NSString *country;//国家 ,
@property (nonatomic,strong) NSString *idCard;//证件号码 ,
@property (nonatomic,strong) NSString *idType;// 证件类型，枚举值， 1 身份证 2 士兵证 3军官证 4 警官证 5 护照 6港澳台居住证 7港澳台身份证 8其他 ,
@property (nonatomic,strong) NSString *mobile;// 手机号码 ,
@property (nonatomic,strong) NSString *name;// 姓名 ,
@property (nonatomic,strong) NSString *nation;// 民族 ,
@property (nonatomic,strong) NSString *photoUrl;//用户照片 ,
@property (nonatomic,strong) NSString *province;// 省份 ,
@property (nonatomic,strong) NSString *sex;//性别 1男 2女

@end

NS_ASSUME_NONNULL_END
