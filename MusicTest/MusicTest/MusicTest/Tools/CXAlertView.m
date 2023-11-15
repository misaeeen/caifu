//
//  CXAlertView.m
//  CITEXContractModule
//
//  Created by 唐彬 on 2020/8/27.
//  Copyright © 2020 Aaron. All rights reserved.
//

#import "CXAlertView.h"

@implementation CXAlertAction

+ (instancetype)alertActionWithTitle:(NSString *)title handler:(void (^)(CXAlertAction * _Nonnull))headler{
    return [[self alloc] initWithTitle:title handler:headler];
}

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(CXAlertAction * _Nonnull))headler{
    if (self = [super init]) {
        self.title = title;
        self.eventHeadlerBlock = headler;
        
        [self _initialValue];
    }
    return self;
}

#pragma mark - 初始值
- (void)_initialValue{
    self.font = [UIFont systemFontOfSize:14];
    self.textColor = [UIColor blackColor];
    self.bgColor = [UIColor whiteColor];
}

@end

@implementation CXAlertCheckBox

+ (instancetype)alertCheckBoxWithText:(NSString *)text{
    return [[self alloc] initWithText:text];
}

- (instancetype)initWithText:(NSString *)text{
    if (self = [super init]) {
        self.text = text;
        
        [self _initialValue];
    }
    return self;
}

#pragma mark - 初始值
- (void)_initialValue{
    self.font = [UIFont systemFontOfSize:12];
    self.textColor = [UIColor blackColor];
    self.image = [UIImage imageNamed:@""];
    self.selectedImage = [UIImage imageNamed:@""];
    self.isSelected = NO;
}

@end


#define kBgVWidth (SCREEN_WDITH > SCREEN_HEIGHT ? SCREEN_HEIGHT : SCREEN_WDITH  * 0.8f) //背景View宽度
#define kMessageLMaxHeight (SCREEN_HEIGHT * 0.4f) //消息背景ScollView最大高度
static NSString *const kRichTextClickId = @"kRichTextClickId";

@interface CXAlertView()

@property (nonatomic, strong) UIView *bgView; // 内容背景View

@property (nonatomic, strong) NSMutableArray <UIButton *>*actionBtns; // 按钮数组

@property (nonatomic, readwrite, strong) NSArray <CXAlertAction *> *actions;
@property (nonatomic, strong) NSMutableArray <CXAlertAction *>* muActions;

@end

@implementation CXAlertView

+ (instancetype)alertView{
    return [[CXAlertView alloc] initWithTitle:nil message:nil];
}
+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    return [[CXAlertView alloc] initWithTitle:title message:message];
}
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.title = title;
        self.message = message;
        [self _initialValue];
    }
    return self;
}

#pragma mark - 初始值
- (void)_initialValue{
    self.shadow = 0.6f;
    self.bgColor = [UIColor whiteColor];
    self.titleFont = [UIFont boldSystemFontOfSize:17];
    self.titleColor = [UIColor blackColor];
    self.messageFont = [UIFont systemFontOfSize:14];
    self.messageColor = [UIColor blackColor];
    self.textAlignment = kCTTextAlignmentCenter;
    self.richTextColor = [UIColor blueColor];
    self.richTextFont = [UIFont systemFontOfSize:14];
    self.lineColor = ColorWithHex(@"#EFEFF4");
}

/**
 * 添加action
 * @param action action
 */
- (void)addAction:(CXAlertAction *)action{
    [self.muActions addObject:action];
    [self.actionBtns addObject:[self _createBtnWithAlertAction:action]];
}
/**
 * 显示alertView
 */
- (void)showAlertViewWithController:(UIViewController *)controller{
    [self _setupUI];
    [controller.view addSubview:self];
    [self _showAnimation];
}
/**
 * 取消alertView
 */
- (void)cancelAlertView{
    [self removeFromSuperview];
}


#pragma mark - event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.actionBtns.count == 0) { // 当没有Action的时候，点击阴影部分隐藏AlertView
        UITouch *touch = [touches.allObjects lastObject];
        if (self == touch.view && ![self.subviews containsObject:touch.view]) {
            [self cancelAlertView];
        }
    }
}
#pragma mark alertAction click
- (void)alertActionClick:(UIButton *)sender{
    CXAlertAction *action = self.muActions[sender.tag];
    if (action.eventHeadlerBlock != nil) {
        action.eventHeadlerBlock(action);
    }
    [self cancelAlertView];
}
#pragma mark alertCheckBox click
-(void)checkboxBtnClick:(UIButton *)sender{
    self.checkBox.isSelected = !self.checkBox.isSelected;
    UIImage *image = self.checkBox.isSelected == YES ? self.checkBox.selectedImage : self.checkBox.image;
    [sender setImage:image forState:UIControlStateNormal];
    [sender setImage:image forState:UIControlStateHighlighted];
}

#pragma mark - private method
#pragma mark 创建按钮
- (UIButton *)_createBtnWithAlertAction:(CXAlertAction *)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:action.title forState:UIControlStateNormal];
    [btn setTitleColor:action.textColor forState:UIControlStateNormal];
    [btn setTitleColor:action.textColor forState:UIControlStateHighlighted];
    [btn setBackgroundColor:action.bgColor];
    btn.titleLabel.font = action.font;
    btn.tag = self.actionBtns.count;
    [btn addTarget:self action:@selector(alertActionClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark TYAttributedLabel
- (UILabel *)_createAttributedLabel{
    CGFloat maxWidth = kBgVWidth - 30.0f;
    UILabel *messageL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 1.0f)];
    messageL.numberOfLines = 0;
    messageL.text = self.message;
    [messageL sizeToFit];
    messageL.frame = CGRectMake(0, 0, maxWidth, messageL.frame.size.height);
    
    return messageL;
}

#pragma mark 显示动画
- (void)_showAnimation{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.25f;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.bgView.layer addAnimation:popAnimation forKey:nil];
}

#pragma mark - setup UI
- (void)_setupUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.shadow];
    // 背景View
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = self.bgColor;
    bgView.layer.cornerRadius = 5.0f;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    self.bgView = bgView;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.offset(kBgVWidth);
    }];
    
    // 按钮背景View
    UIView *btnsBgV = [[UIView alloc] init];
    if (self.actionBtns.count != 1) {
        btnsBgV.backgroundColor = self.lineColor;
    }else{
        self.actionBtns[0].layer.cornerRadius = 2.0f;
    }
    [bgView addSubview:btnsBgV];
    [btnsBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0.0f);
        if (self.actionBtns.count == 0) {
            make.height.offset(0.0f);
        }else if(self.actionBtns.count == 1){
            make.height.offset(55.0f);
        }else{
            make.height.offset(44.0f);
        }
    }];
    
    // 把按钮添加到btnsBgV
    for (UIButton *btn in self.actionBtns) {
        [btnsBgV addSubview:btn];
    }
    // 给btn设置约束
    if (self.actionBtns.count > 1) {
        // 实现masonry水平固定间隔方法
        [self.actionBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.5f leadSpacing:0.0f tailSpacing:0.0f];
        // 设置array的垂直方向的约束
        [self.actionBtns mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.bottom.offset(0);
        }];
    }else{
        if (self.actionBtns.count != 0) {
            [self.actionBtns[0] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0.0f);
                make.left.offset(15.0f);
                make.bottom.right.offset(-15.0f);
            }];
        }
    }
    
    // 水平分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = self.lineColor;
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0.0f);
        make.bottom.equalTo(btnsBgV.mas_top).offset(0.0f);
        make.height.offset(0.5f);
    }];
    
    UIButton *checkboxBtn = nil;
    if (self.checkBox != nil) {
        checkboxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkboxBtn setTitle:self.checkBox.text forState:UIControlStateNormal];
        [checkboxBtn setTitleColor:self.checkBox.textColor forState:UIControlStateNormal];
        [checkboxBtn setTitleColor:self.checkBox.textColor forState:UIControlStateHighlighted];
        checkboxBtn.titleLabel.font = self.checkBox.font;
        UIImage *image = self.checkBox.isSelected == YES ? self.checkBox.selectedImage : self.checkBox.image;
        [checkboxBtn setImage:image forState:UIControlStateNormal];
        [checkboxBtn setImage:image forState:UIControlStateHighlighted];
        [checkboxBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -8, 0.0, 0.0)];
        [checkboxBtn addTarget:self action:@selector(checkboxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:checkboxBtn];
        [checkboxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(23.0f);
            make.bottom.equalTo(line.mas_top).offset(-15.0f);
        }];
    }
    
    UIView *layoutV = checkboxBtn == nil ? line : checkboxBtn;

    UIScrollView *messageScrollView;
    UIScrollView *scrollView = nil;
    // 消息View
    if (self.customMessageView != nil) { // 设置了自定义的messageView，优先使用自定义的messageView
        
        messageScrollView = [[UIScrollView alloc] init];
        messageScrollView.showsVerticalScrollIndicator = NO;
        messageScrollView.showsHorizontalScrollIndicator = NO;
        [bgView addSubview:messageScrollView];
        [messageScrollView addSubview:self.customMessageView];
        
        [self.customMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(0);
            make.width.offset(kBgVWidth - 30.0f);
        }];
        [bgView layoutIfNeeded];
    
        if (self.customMessageView.frame.size.height > kMessageLMaxHeight) {
            messageScrollView.contentSize = CGSizeMake(0, self.customMessageView.frame.size.height);
            [self.customMessageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.offset(0);
                make.width.offset(kBgVWidth - 30.0f);
            }];
        }
        CGFloat height = self.customMessageView.frame.size.height > kMessageLMaxHeight ? kMessageLMaxHeight : self.customMessageView.frame.size.height;
        [messageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15.0f);
            make.right.offset(-15.0f);
            make.height.offset(height);
            make.bottom.equalTo(layoutV.mas_top).offset(-15.0f);
        }];
    }else{ // 没有设置自定义的messageView
        scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [bgView addSubview:scrollView];

        UILabel *messageL = [self _createAttributedLabel];
//        messageL.textAlignment = self.textAlignment;
        [scrollView addSubview:messageL];
        
        scrollView.contentSize = CGSizeMake(kBgVWidth - 30.0f, messageL.frame.size.height);
        CGFloat maxHeight = messageL.frame.size.height > kMessageLMaxHeight ? kMessageLMaxHeight :  messageL.frame.size.height;
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15.0f);
            make.right.offset(-15.0f);
            make.bottom.equalTo(layoutV.mas_top).offset(-15.0f);
            make.height.offset(maxHeight);
        }];
        
//        [messageL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.offset(0.0f);
//        }];
    }

    // 标题View
    if (self.customTitleView != nil) { // 设置了自定义的titleView，优先使用自定义的titleView
        [bgView addSubview:self.customTitleView];
        [self.customTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(0.0f);
            make.right.offset(0.0f);
            make.bottom.equalTo(messageScrollView != nil ? messageScrollView.mas_top : scrollView.mas_top).offset(-15.0f);
        }];
    }else{ //没有设置自定义的titleView
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = self.title;
        titleL.textColor = self.titleColor;
        titleL.font = self.titleFont;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.numberOfLines = 2;
        [bgView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(15.0f);
            make.right.offset(-15.0f);
            make.bottom.equalTo(messageScrollView != nil ? messageScrollView.mas_top : scrollView.mas_top).offset(-15.0f);
        }];
    }
    
}

#pragma mark - getter and setter
- (NSMutableArray<UIButton *> *)actionBtns{
    if (_actionBtns == nil) {
        _actionBtns = [NSMutableArray array];
    }
    return _actionBtns;
}
- (NSMutableArray<CXAlertAction *> *)muActions{
    if (_muActions == nil) {
        _muActions = [NSMutableArray array];
    }
    return _muActions;
}
- (NSArray<CXAlertAction *> *)actions{
    return self.muActions.copy;
}


@end
