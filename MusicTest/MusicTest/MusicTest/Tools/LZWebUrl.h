//
//  LZWebUrl.h
//  MusicTest
//
//  Created by LZZ on 2020/12/23.
//  Copyright © 2020 CF. All rights reserved.
//

#define DIS_BASE_WEB_URL @"https://kaoji.spas.org.cn"
/// 播放视频
#define PLAY_VIDEO_URL [NSString stringWithFormat:@"%@/LevelExamRegister/player",DIS_BASE_WEB_URL]
/// 流程介绍
#define PROCESS_INTRODUCTION_URL [NSString stringWithFormat:@"%@/LevelExamRegister/process_introduction",DIS_BASE_WEB_URL]
/// 备考指南http://te.caifulife.cn:8088/exam_register/shoot_and_description?token="+token:)
#define EXAM_GUIDE_URL [NSString stringWithFormat:@"%@/LevelExamRegister/shoot_and_description",DIS_BASE_WEB_URL]
//@"/LevelExamRegister/exam_guide";

/// 乐理生产地址
#define MUSIC_THERY_TEST_URL @"https://yllx.spas.org.cn:12120/djy_yl/mobile/dev_home"
/// 考前必读
#define BEFORE_EXAMINATION_URL [NSString stringWithFormat:@"%@/LevelExamRegister/before_examination",DIS_BASE_WEB_URL]
/// 拍摄条件
#define SHOOTING_CONDITIONS_URL [NSString stringWithFormat:@"%@/LevelExamRegister/shooting_conditions",DIS_BASE_WEB_URL]
/// 考生承诺书
#define LETTER_OF_COMMITMENT_URL [NSString stringWithFormat:@"%@/LevelExamRegister/letter_of_commitment",DIS_BASE_WEB_URL]
/// 教材推荐
#define TEXT_BOOK_URL [NSString stringWithFormat:@"%@/LevelExamRegister/textbook",DIS_BASE_WEB_URL]
/// 隐私协议
#define PRIVACY_PROTOCOL_URL [NSString stringWithFormat:@"%@/LevelExamRegister/privacy_agreement",DIS_BASE_WEB_URL]

typedef NS_ENUM(NSUInteger, LZTestState) {
    LZTestStateNotTested = 0, /// 未考
    LZTestStateTested,  /// 已考
    LZTestStateLackTested /// 缺考
};
