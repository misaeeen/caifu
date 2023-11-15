//
//  ChooseMusicalController.m
//  MusicTest
//
//  Created by LZZ on 2020/12/14.
//  Copyright © 2020 CF. All rights reserved.
//

#import "ChooseMusicalController.h"
#import "ChooseMusicalItemCell.h"
#import "LZTestDetailsModel.h"
#import "MockTestController.h"

@interface ChooseMusicalController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, strong) UIButton *footerBtn;

@end

@implementation ChooseMusicalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考前模拟";
    [self setupSubviews];
    self.selectedIndex = -1;
}

- (void)setupSubviews{
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT - (SafeHeight + 60.0f) - NavBarHeight, SCREEN_WDITH, SafeHeight + 60.0f)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    self.footerBtn = [UIButton createButtonWithTitleColor:ColorWithHex(@"#333333") font:FontWithSize(13.0f)];
    self.footerBtn.frame = CGRectMake(16.0f, 24.0f, footerView.frame.size.width - 32.0f, 36.0f);
    self.footerBtn.backgroundColor = ColorWithHex(@"#E6E6E6");
    self.footerBtn.layer.cornerRadius = 4.0f;
    [self.footerBtn setTitle:@"开始模拟" forState:UIControlStateNormal];
    [[self.footerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if(self.selectedIndex != -1){
            MockTestController *vc= [MockTestController new];
            vc.model = [self getTestDetailsModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [footerView addSubview:self.footerBtn];
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_offset(0.0f);
        make.bottom.equalTo(footerView.mas_top).mas_offset(0.0f);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChooseMusicalItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseMusicalItemCell" forIndexPath:indexPath];
    [cell reloadWithData:self.dataSource[indexPath.item]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, CONTROLLER_FRAME(148.0f))];
        imgV.image = [UIImage imageNamed:@"banner-1"];
        [headerView addSubview:imgV];
        
        UILabel *titleL = [UILabel createWithColor:ColorWithHex(@"#333333") font:FontWithSize(15.0f)];
        titleL.text = @"请选择要模拟的科目";
        titleL.frame = CGRectMake(29.0f, 148.0f, headerView.frame.size.width - 29.0f, headerView.frame.size.height - 148.0f);
        [headerView addSubview:titleL];
        return headerView;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == indexPath.item) return;
    if(self.selectedIndex != -1){
        NSMutableDictionary *dict = [self.dataSource[self.selectedIndex] mutableCopy];
        dict[@"isSelected"] = @(NO);
        self.dataSource[self.selectedIndex] = dict.copy;
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]]];
    }
    
    self.selectedIndex = indexPath.item;
    NSMutableDictionary *dict1 = [self.dataSource[self.selectedIndex] mutableCopy];
    dict1[@"isSelected"] = @(YES);
    self.dataSource[self.selectedIndex] = dict1.copy;
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]]];
    
    self.footerBtn.backgroundColor = ColorWithHex(@"#FFCF26");
    
}

- (LZTestDetailsModel *)getTestDetailsModel{
    LZTestDetailsModel *detailsModel = [LZTestDetailsModel new];
    LZUserModel *userModel = [LZUserModel new];
    detailsModel.isSimulation = YES;
    detailsModel.id = @"simulation";
    userModel.name = @"模拟考生";
    detailsModel.profile = userModel;
    detailsModel.book = @"《模拟考试教材》";
    detailsModel.subject = self.dataSource[self.selectedIndex][@"title"];
    detailsModel.level = @"模拟级别";
    detailsModel.chapter = @"1.模拟曲目一,2.模拟曲目二,3.模拟曲目三";
    detailsModel.examTime = @"";
    return detailsModel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WDITH / 3.0f, 130.0f);
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        flowLayout.minimumLineSpacing = CGFLOAT_MIN;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WDITH, 43.0f + CONTROLLER_FRAME(148.0f));
//        flowLayout.footerReferenceSize = CGSizeMake(SCREEN_WDITH, 60.0f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ChooseMusicalItemCell class] forCellWithReuseIdentifier:@"ChooseMusicalItemCell"];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    }
    return _collectionView;
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSArray *titles = @[@"小军鼓",@"木琴及马林巴琴",@"定音鼓",@"爵士鼓",@"电爵士鼓",@"非洲鼓",@"拉丁打击乐",@"电吉他",@"电贝司",@"中国鼓"];
        NSArray *imgs = @[@"小军鼓-1",@"马林巴-1",@"定音鼓-1",@"爵士鼓-1",@"电爵士鼓-1",@"非洲鼓-1",@"拉丁打击乐-1",@"电吉他-1",@"电贝司-1",@"中国鼓_默认"];
        NSArray *selectedImgs = @[@"小军鼓_选中",@"马林巴_选中",@"定音鼓_选中",@"爵士鼓_选中",@"电爵士鼓_选中",@"非洲鼓_选中",@"拉丁打击乐_选中",@"电吉他_选中",@"电贝司_选中",@"中国鼓_选中"];
        for (NSInteger i = 0; i < titles.count; i ++) {
            BOOL isSelected = NO;
//            if (i == 0) {
//                isSelected = YES;
//            }
            NSDictionary *dict = @{
                @"title":titles[i],
                @"image":imgs[i],
                @"selectedImage":selectedImgs[i],
                @"isSelected":@(isSelected)
            };
            [_dataSource addObject:dict];
        }
    }
    return _dataSource;
}


@end
