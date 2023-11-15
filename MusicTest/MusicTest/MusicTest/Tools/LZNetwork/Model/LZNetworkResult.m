//
//  LZNetworkResult.m
//  MusicTest
//
//  Created by LZZ on 2020/12/3.
//  Copyright © 2020 CF. All rights reserved.
//

#import "LZNetworkResult.h"




@implementation LZNetworkResult

- (BOOL)isSuccess {
    return self.code == LZNetworkStatusSuccess;
}

@end
