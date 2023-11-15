//
//  CXAlertView.h
//  CITEXContractModule
//
//  Created by 唐彬 on 2020/8/27.
//  Copyright © 2020 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface CXAlertAction : NSObject
/**
 * 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 * 字体
 * 默认 默认 [UIFont systemFontOfSize:14]
 */
@property (nonatomic, copy) UIFont *font;
/**
 * 字体颜色
 * 默认 [UIColor blackColor]
 */
@property (nonatomic, copy) UIColor *textColor;
/**
 * 背景颜色
 * 默认 [UIColor whiteColor]
*/
@property (nonatomic, copy) UIColor *bgColor;
/**
 * 点击回调绑定
 */
@property (nonatomic, copy) void (^eventHeadlerBlock)(CXAlertAction *action);


/**
 * 实例化对象
 * @param title 标题
 * @param headler 点击回调绑定
 * @return 对象
 */
+ (instancetype)alertActionWithTitle:(NSString *)title handler:(void (^)(CXAlertAction *action))headler;

@end


@interface CXAlertCheckBox : NSObject

/**
 * 文本
 */
@property (nonatomic, copy) NSString *text;
/**
 * 文本字体
 * 默认 [UIFont systemFontOfSize:12]
 */
@property (nonatomic, copy) UIFont *font;
/**
 * 文本颜色
 * 默认 [UIColor blackColor]
 */
@property (nonatomic, copy) UIColor *textColor;
/**
 * 未选中图片
 * 默认 kContractIMAGE(@"KLine_chooseNotSelected")
 */
@property (nonatomic, copy) UIImage *image;
/**
 * 选中图片
 * 默认 kContractIMAGE(@"KLine_chooseSelected")
 */
@property (nonatomic, copy) UIImage *selectedImage;
/**
 * 选中状态
 * 默认 NO
 */
@property (nonatomic, assign) BOOL isSelected;

/**
 * 实例化对象
 * @param text 文本
 * @return 对象
 */
+ (instancetype)alertCheckBoxWithText:(NSString *)text;

@end


@interface CXAlertView : UIView
/**
 * 阴影
 * 取值 0.1~1.0
 * 默认 0.6
 */
@property (nonatomic, assign) CGFloat shadow;

/**
 * 背景颜色
 * 默认 [UIColor whiteColor]
 */
@property (nonatomic, copy) UIColor *bgColor;

/**
 * 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 * 标题字体
 * 默认 [UIFont systemFontOfSize:17]
 */
@property (nonatomic, copy) UIFont *titleFont;
/**
 * 标题字体颜色
 * 默认 [UIColor blackColor]
 */
@property (nonatomic, copy) UIColor *titleColor;

/**
 * 自定义标题view
 */
@property (nonatomic, strong) UIView *customTitleView;

/**
 * 消息
 */
@property (nonatomic, copy) NSString *message;
/**
 * 消息字体
 * 默认 [UIFont systemFontOfSize:14]
 */
@property (nonatomic, copy) UIFont *messageFont;
/**
 * 消息字体颜色
 * 默认 [UIColor blackColor]
 */
@property (nonatomic, copy) UIColor *messageColor;
/**
 * 消息字体是否居中
 * 默认 NSTextAlignmentCenter
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/**
 * 需要展示成富文本的文字
 */
@property (nonatomic, copy) NSString *richText;
/**
 * 富文本字体颜色
 * 默认 [UIColor blueColor]
 */
@property (nonatomic, copy) UIColor *richTextColor;
/**
 * 富文本字体
 * 默认 [UIFont systemFontOfSize:14]
 */
@property (nonatomic, copy) UIFont *richTextFont;
/**
 * 点击富文本回调
 */
@property (nonatomic, copy) void (^richTextClickBlock)(void);
/**
 * 自定义消息View
 */
@property (nonatomic, strong) UIView *customMessageView;


/**
 * 线的颜色
 * 默认 [UIColor colorWithHex:0xEFEFF4]
 */
@property (nonatomic, copy) UIColor *lineColor;

/**
 * 选择框
 */
@property (nonatomic, strong) CXAlertCheckBox *checkBox;

@property (nonatomic, readonly, strong) NSArray <CXAlertAction *> *actions;

/**
 * 实例化对象
 * @param title 标题
 * @param message 内容
 * @return 对象
 */
+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)alertView;

/**
 * 添加action
 * @param action action
 */
- (void)addAction:(CXAlertAction *)action;

- (void)showAlertViewWithController:(UIViewController *)controller;
- (void)cancelAlertView;

@end

NS_ASSUME_NONNULL_END
