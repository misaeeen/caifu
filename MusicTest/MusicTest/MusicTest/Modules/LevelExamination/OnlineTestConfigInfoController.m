//
//  OnlineTestConfigInfoController.m
//  MusicTest
//
//  Created by LZZ on 2020/11/10.
//  Copyright © 2020 CF. All rights reserved.
//线上考级信息确认

#import "OnlineTestConfigInfoController.h"
#import "OnlineTestConfigCell.h"
#import "LZTestNetworkAPI.h"
#import "LZTestDetailsModel.h"
#import "NSString+CLString.h"
#import "LZBookModel.h"
#import "UIAlertAction+Index.h"

#import "CFWebViewController.h"


@interface OnlineTestConfigInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * submitButton;
@property(nonatomic,strong)UIImageView * headImageV;

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)LZTestDetailsModel *model;
@property (nonatomic, strong)NSArray <LZBookModel *>*books;
@property (nonatomic, strong)LZBookModel *selectedBookModel;

@property (nonatomic, strong)NSArray <NSString *> *chapterPart1;
@property (nonatomic, strong)NSArray <NSString *> *chapterPart2;
@property (nonatomic, strong)NSString *part1;
@property (nonatomic, strong)NSString *part2;

@property (nonatomic, assign) BOOL isTestFinish;

@end

@implementation OnlineTestConfigInfoController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadTestDetails];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正式考级";
    
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.submitButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 55.0f + 36.0f + 55.0f)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    [footerView addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        make.height.mas_equalTo(36);
        make.bottom.offset(-55);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testFinishNotification) name:@"TestFinishNotification" object:nil];
}
- (void)testFinishNotification{
    self.isTestFinish = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"OnlineTestConfigCell";
    OnlineTestConfigCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[OnlineTestConfigCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell reloadWithData:self.dataSource[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.row];
    if ([dict[@"isTouch"] boolValue]) {
        if ([dict[@"type"] isEqual:@"Book"]) {
            [self showBookAlert];
        }
        if ([dict[@"type"] isEqual:@"Song"]) {
            [self showSongAlertWithIndex:[dict[@"index"] integerValue]];
        }
    }
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        if(@available(iOS 15.0,*)){
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    
    return _tableView;
}

-(UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"确认无误，开始考级" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = FontWith14px;
        [_submitButton setBackgroundColor: ColorWithHex(@"#fdcf2c")];
        _submitButton.layer.cornerRadius = 2.5f;
        [_submitButton setTitleColor:ColorWithHex(@"#343434") forState:UIControlStateNormal];
        [[_submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.isTestFinish == NO) {
                long long startTime = [self.model.examStartTime longLongValue] / 1000;
                long long currentTime = [[self getTimestampSince1970] longLongValue];
                if (startTime <= currentTime) {
                    if (self.selectedBookModel == nil) {
                        [MBProgressHUD showError:@"请选择考级教材" ToView:self.view];
                        return;
                    }
                    if (self.model.examNum == 1 && self.part1.length == 0) {
                        [MBProgressHUD showError:@"请选择考级曲目一" ToView:self.view];
                        return;
                    }
                    if (self.model.examNum == 2) {
                        if(self.part1.length == 0){
                            [MBProgressHUD showError:@"请选择考级曲目一" ToView:self.view];
                            return;
                        }else if(self.part2.length == 0){
                            [MBProgressHUD showError:@"请选择考级曲目二" ToView:self.view];
                            return;
                        }
                    }
                    CXAlertView *alertV = [CXAlertView alertViewWithTitle:@"友情提示" message:@"提交考试信息，确认后不可更改"];
                    
                    [alertV addAction:[CXAlertAction alertActionWithTitle:@"取消" handler:^(CXAlertAction * _Nonnull action) {
                        
                    }]];
                    
                    CXAlertAction *action = [CXAlertAction alertActionWithTitle:@"确认" handler:^(CXAlertAction * _Nonnull action) {
                        
                        NSMutableString *muStr = [NSMutableString string];
                        if (self.model.examNum == 1) {
                            [muStr appendString:self.part1];
                        }
                        if (self.model.examNum == 2) {
                            [muStr appendFormat:@"%@,%@",self.part1,self.part2];
                        }
                        
                        [LZTestNetworkAPI saveTestWithId:self.model.id book:self.selectedBookModel.name chapter:muStr.copy block:^(LZNetworkResult *result, NSError *error) {
                            if (!error) {
                                if (result.isSuccess) {
                                    self.model.book = self.selectedBookModel.name;
                                    self.model.chapter = muStr.copy;
                                    CFWebViewController *webV = [[CFWebViewController alloc] init];
                                    webV.model = self.model;
                                    webV.titleStr = @"考前必读";
                                    [self.navigationController pushViewController:webV animated:YES];
                                } else {
                                    [MBProgressHUD showError:result.msg ToView:self.view];
                                }
                            } else {
                                [MBProgressHUD showError:error.localizedDescription ToView:self.view];
                            }
                        }];

                    }];
                    action.bgColor = ColorWithHex(@"FFCF26");
                    [alertV addAction:action];
                    [alertV showAlertViewWithController:self.navigationController];
                    
                } else {
                    [MBProgressHUD showError:@"考试还未开始" ToView:self.view];
                }
            }else{
                [MBProgressHUD showError:@"当前考试已提交，请勿重复考试。" ToView:self.view];
            }
        }];
        _submitButton.layer.masksToBounds = YES;
        
    }
    
    return _submitButton;
}
//获取当前时间戳字符串 10位
- (NSString *)getTimestampSince1970{
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeInterval interval = [datenow timeIntervalSince1970];//13位的*1000
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",interval];
    return timeSp;
}


-(UIView *)createHeaderView{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WDITH, 150)];
    UILabel * descLab = [[UILabel alloc]init];
    descLab.frame = CGRectMake(16, 150-15, SCREEN_WDITH - 24, 13);
    descLab.text = @"*请确认考生信息是否正确，若有错误，请联系管理员";
    descLab.font = FontWithSize(12);
    descLab.textColor = ColorWithHex(@"#FF3B30");
    [headView addSubview:descLab];
    
    _headImageV = [[UIImageView alloc]init];
    _headImageV.frame = CGRectMake(SCREEN_WDITH/2 - 98/2, 8, 98, 98);
    _headImageV.layer.cornerRadius = 10.0f;
    _headImageV.layer.masksToBounds = YES;
    [headView addSubview:_headImageV];
    return headView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)loadTestDetails{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    kWeakSelf;
    [LZTestNetworkAPI loadTestDetailsWithId:self.test_id block:^(LZNetworkResult *result, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (!error) {
            if (result.isSuccess) {
                
                weakSelf.model = [LZTestDetailsModel yy_modelWithJSON:result.data];
                
                weakSelf.tableView.tableHeaderView = [self createHeaderView];
                [weakSelf.headImageV sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.profile.photoUrl]];
                [weakSelf bindDataSource];
                
                [weakSelf.tableView reloadData];
                
                [weakSelf loadBooksWithShowAlert:NO];
                [weakSelf loadSongsWithShowAlert:NO index:0];
                
            } else {
                [MBProgressHUD showError:result.msg ToView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
        }
    }];
}

- (void)bindDataSource{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@{
        @"title":@"考生姓名：",
        @"content":CLNoNilString(self.model.profile.name),
        @"textColor":@"#333333",
        @"isTouch":@(NO)
    }];
    [arr addObject:@{
        @"title":@"考级备案：",
        @"content":CLNoNilString(self.model.title),
        @"textColor":@"#333333",
        @"isTouch":@(NO)
    }];
    [arr addObject:@{
        @"title":@"考级科目：",
        @"content":CLNoNilString(self.model.subject),
        @"textColor":@"#333333",
        @"isTouch":@(NO)
    }];
    [arr addObject:@{
        @"title":@"考级等级：",
        @"content":CLNoNilString(self.model.level),
        @"textColor":@"#333333",
        @"isTouch":@(NO)
    }];
    
    
    
    if (self.model.book.length != 0) {
        [arr addObject:@{
            @"title":@"考级教材：",
            @"content":self.model.book,
            @"isTouch":@(YES),
            @"type":@"Book"
        }];
        LZBookModel *bookModel = [[LZBookModel alloc] init];
        bookModel.name = self.model.book;
        self.selectedBookModel = bookModel;
    }else{
        [arr addObject:@{
            @"title":@"考级教材：",
            @"content":@"请选择考级教材",
            @"textColor":@"#999999",
            @"isTouch":@(YES),
            @"type":@"Book"
        }];
    }
    
    if (self.model.chapter.length != 0) {
        NSArray *chapters = [self.model.chapter componentsSeparatedByString:@","];
        for (NSInteger i = 0; i < chapters.count; i ++) {
            NSString *title = @"";
            if (i == 0) {
                title = @"考级曲目：";
            }
            if (title.length != 0) {
                self.part1 = chapters[0];
            }else{
                self.part2 = chapters[1];
            }
            [arr addObject:@{
                @"title":title,
                @"content":chapters[i],
                @"isTouch":@(YES),
                @"index":@(i),
                @"type":@"Song"
            }];
        }
    }else{
        for(NSInteger i = 0; i < self.model.examNum; i ++){
            NSString *title = @"";
            if (i == 0) {
                title = @"考级曲目：";
            }
            NSString *text = @"请选择考级曲目";
            if (i == 0) {
                text = [NSString stringWithFormat:@"%@一",text];
            }else if (i == 1){
                text = [NSString stringWithFormat:@"%@二",text];
            }
            [arr addObject:@{
                @"title":title,
                @"content":text,
                @"textColor":@"#999999",
                @"isTouch":@(YES),
                @"index":@(i),
                @"type":@"Song"
            }];
        }
    }
    
    
    NSString *examStartTime = [self.model.examStartTime timerTransfer];
    NSString *examEndTime = [self.model.examEndTime timerTransfer];
    NSString *examTime = [NSString stringWithFormat:@"%@--%@",examStartTime,examEndTime];
    
    [arr addObject:@{
        @"title":@"考级时间：",
        @"content":CLNoNilString(examTime),
        @"textColor":@"#333333",
        @"isTouch":@(NO)
    }];
    [arr addObject:@{
        @"title":@"考级次数：",
        @"content":[NSString stringWithFormat:@"%@",@(self.model.recordCnt > 2 ? 2 : self.model.recordCnt)],
        @"textColor":@"#333333",
        @"isTouch":@(NO)
    }];
    self.dataSource = arr;
}

- (void)showBookAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择教材" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < self.books.count; i ++) {
        LZBookModel *model = self.books[i];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectedBookModel = self.books[action.index];
            NSMutableDictionary *nDict = nil;
            NSInteger index = -1;
            for (NSInteger i = 0; i < self.dataSource.count; i ++) {
                NSDictionary *dict = self.dataSource[i];
                if ([dict[@"isTouch"] boolValue]) {
                    if ([dict[@"type"] isEqual:@"Book"]) {
                        nDict = dict.mutableCopy;
                        index = i;
                        break;
                    }
                }
            }
            if (index != -1) {
                [nDict setObject:@"#333333" forKey:@"textColor"];
                [nDict setObject:self.selectedBookModel.name forKey:@"content"];
                self.dataSource[index] = nDict.copy;
                [self.tableView reloadData];
            }
        }];
        action1.index = i;
        [alert addAction:action1];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
- (void)loadBooksWithShowAlert:(BOOL)showAlert{
    kWeakSelf;
    [LZTestNetworkAPI loadBooksWithExamDataId:self.model.id subject:self.model.subject level:self.model.level block:^(LZNetworkResult *result, NSError *error) {
        if (!error) {
            if (result.isSuccess) {
                self.books = [NSArray yy_modelArrayWithClass:[LZBookModel class] json:result.data[@"books"]];
                if (showAlert) {
                    [self showBookAlert];
                }
            } else {
                [MBProgressHUD showError:result.msg ToView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
        }
    }];
}

- (void)showSongAlertWithIndex:(NSInteger)index{
    NSArray *arr = index == 0 ? self.chapterPart1 : self.chapterPart2;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择曲目" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < arr.count; i ++) {
        NSString *str = arr[i];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *content = @"";
            if (index == 0) {
                self.part1 = arr[action.index];
                content = self.part1;
            }else{
                self.part2 = arr[action.index];
                content = self.part2;
            }
            NSMutableDictionary *nDict = nil;
            NSInteger aIndex = -1;
            for (NSInteger i = 0; i < self.dataSource.count; i ++) {
                NSDictionary *dict = self.dataSource[i];
                if ([dict[@"isTouch"] boolValue]) {
                    if ([dict[@"type"] isEqual:@"Song"] && [dict[@"index"] integerValue] == index) {
                        nDict = dict.mutableCopy;
                        aIndex = i;
                        break;
                    }
                }
            }
            if (aIndex != -1) {
                [nDict setObject:@"#333333" forKey:@"textColor"];
                [nDict setObject:content forKey:@"content"];
                self.dataSource[aIndex] = nDict.copy;
                [self.tableView reloadData];
            }
        }];
        action1.index = i;
        [alert addAction:action1];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)loadSongsWithShowAlert:(BOOL)showAlert index:(NSInteger)index{
    kWeakSelf;
    [LZTestNetworkAPI loadSongsWithExamDataId:self.model.id subject:self.model.subject level:self.model.level block:^(LZNetworkResult *result, NSError *error) {
        if (!error) {
            if (result.isSuccess) {
                self.chapterPart1 = result.data[@"chapters"];
                self.chapterPart2 = result.data[@"chapters"];
                if (showAlert) {
                    [self showSongAlertWithIndex:index];
                }
            } else {
                [MBProgressHUD showError:result.msg ToView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showError:error.localizedDescription ToView:weakSelf.view];
        }
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
