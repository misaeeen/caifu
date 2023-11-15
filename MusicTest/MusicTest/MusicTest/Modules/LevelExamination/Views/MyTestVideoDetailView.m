//
//  MyTestVideoDetailView.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//

#import "MyTestVideoDetailView.h"
#import "OnlineTestConfigCell.h"
#import "MyTestVideoDetailCell.h"

@interface MyTestVideoDetaiHeadView ()
@property(nonatomic,strong)UIImageView * iconImageV;
@property(nonatomic,strong)UILabel * titleLab;
@end

@implementation MyTestVideoDetaiHeadView




-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super  initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        _iconImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_apply_test"]];
        
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = ColorWithHex(@"333333");
        _titleLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleLab.text = @"我的视屏";
        
        [self addSubview:_iconImageV];
        [self addSubview:_titleLab];
        [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(21);
            make.left.offset(16);
            make.top.offset(12);
        }];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(21);
            make.left.equalTo(_iconImageV.mas_right).offset(8);
            make.top.offset(12);
        }];
   
    }
    
    return self;
}

@end


@interface MyTestVideoDetailView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;

@end
@implementation MyTestVideoDetailView

-(instancetype)initWithFrame:(CGRect)frame{
     if (self = [super initWithFrame:frame]) {
            
            [self addSubview:self.tableView];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.offset(0);
            }];
        }
        
        return self;
}

 -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
           static NSString * cellId = @"OnlineTestConfigCell";
              OnlineTestConfigCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
              if (cell == nil) {
                  cell = [[OnlineTestConfigCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
              }
              
              return cell;
        
    }else{
        static NSString * cellId = @"MyTestVideoDetailCell";
        MyTestVideoDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[MyTestVideoDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        return cell;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    static NSString * headVId = @"MyTestVideoDetaiHeadView";
    MyTestVideoDetaiHeadView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headVId];
    if (view == nil) {
        view = [[MyTestVideoDetaiHeadView alloc]initWithReuseIdentifier:headVId];
    }
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 42;
    }
    return 122;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _tableView;
}

@end
