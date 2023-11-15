//
//  CFWebViewController.h
//  zbt
//
//  Created by 伍鹏 on 2018/3/26.
//  Copyright © 2018年 Caifu. All rights reserved.
//

#import "BaseViewController.h"

#import "LZTestDetailsModel.h"


@interface CFWebViewController : BaseViewController

@property (nonatomic,copy)NSString *url;

@property (nonatomic,strong)NSString *titleStr;

/// 进入考试
@property (nonatomic, strong)LZTestDetailsModel *model;

@end
