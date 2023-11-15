//
//  RegisterTextView.h
//  MusicTest
//
//  Created by LZZ on 2020/11/9.
//  Copyright © 2020 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterTextView : UIView
@property(nonatomic,assign)UIKeyboardType keyboardType;
@property(nonatomic,strong)UITextField * textField;
@property(nonatomic,strong)NSString * title;
@end

NS_ASSUME_NONNULL_END
