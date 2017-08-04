//
//  AnswerCell.h
//  MyUnityOniOS
//
//  Created by Apple on 16/8/9.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Question;
@interface AnswerCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView * iconImageview;
@property (nonatomic, strong)UILabel * aLab;//答案A
@property (nonatomic, strong)UILabel * bLab;//答案B
@property (nonatomic, strong)UILabel * cLab;//答案C
@property (nonatomic, strong)UILabel * dLab;//答案D

@property (nonatomic, strong)UILabel * tittleLab;//题目
@property (nonatomic, strong)UIButton * aBtn;//选择A
@property (nonatomic, strong)UIButton * bBtn;//选择B
@property (nonatomic, strong)UIButton * cBtn;//选择C
@property (nonatomic, strong)UIButton * dBtn;//选择D

@property (nonatomic, strong)UILabel * promptLab;//提示
@property (nonatomic, strong)UILabel * answerTimeLab;//最终选择答案5秒倒计时
@property (nonatomic, strong)UILabel * questionTimeLab;//先查看四个答案10秒倒计时

@property (nonatomic, strong)UIButton * aCardBtn;//卡牌A,B,C,D,E
@property (nonatomic, strong)UIButton * bCardBtn;
@property (nonatomic, strong)UIButton * cCardBtn;
@property (nonatomic, strong)UIButton * dCardBtn;
@property (nonatomic, strong)UIButton * eCardBtn;

@property (nonatomic, assign)int secondsCountDown1;//10秒倒计时总时长
@property (nonatomic, assign)int secondsCountDown2;//5秒倒计时总时长
@property (nonatomic, strong)NSTimer *myTimer1;//计时器10秒
@property (nonatomic, strong)NSTimer *myTimer2;//计时器5秒

@property (nonatomic, strong)Question * question;

@end
