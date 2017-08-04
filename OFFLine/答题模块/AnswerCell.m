//
//  AnswerCell.m
//  MyUnityOniOS
//
//  Created by Apple on 16/8/9.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "AnswerCell.h"
#import "Question.h"


#define Answer_Width [UIApplication sharedApplication].keyWindow.bounds.size.width / 2.0
#define Answer_Height (([UIApplication sharedApplication].keyWindow.bounds.size.height - 45) /100 * 15)
#define Question_Height 80



@implementation AnswerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    self.promptLab = [UILabel labelWithFrame:CGRectMake(0, 80, Answer_Width * 2.0, Answer_Height / 2) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] fontSize:30];
    self.promptLab.text = @"还有    秒显示题目";
    [self addSubview:self.promptLab];
    
    //10秒
    self.questionTimeLab = [UILabel labelWithFrame:CGRectMake(Answer_Width - 70, 0, 50, 50) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter textColor:[UIColor redColor] fontSize:40.0];
    [self.promptLab addSubview:_questionTimeLab];
    
    //5秒
    self.answerTimeLab = [UILabel labelWithFrame:CGRectMake(Answer_Width - 70, 0, 50, 50) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter textColor:[UIColor redColor] fontSize:40.0];
    //    [self.promptLab addSubview:_answerTimeLab];
    
    self.tittleLab = [UILabel labelWithFrame:CGRectMake(0, ([UIApplication sharedApplication].keyWindow.bounds.size.height - 45) /100 * 32.5, Answer_Width * 2.0, 40) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft textColor:[UIColor whiteColor] fontSize:15.0];
    self.tittleLab.numberOfLines = 0;
    
    self.aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_aBtn setImage:[UIImage imageNamed:@"单选按钮未选中.png"] forState:UIControlStateNormal];
    [_aBtn setImage:[UIImage imageNamed:@"单选 按钮.png"] forState:UIControlStateSelected];
    _aBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_aBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    _aBtn.frame = CGRectMake(0, ([UIApplication sharedApplication].keyWindow.bounds.size.height - 45) /100 * 55, Answer_Width, Answer_Height);
    _aBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _aBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_aBtn addTarget:self action:@selector(chooseQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_aBtn];
    
    self.bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bBtn setImage:[UIImage imageNamed:@"单选按钮未选中.png"] forState:UIControlStateNormal];
    [_bBtn setImage:[UIImage imageNamed:@"单选 按钮.png"] forState:UIControlStateSelected];
    _bBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    _bBtn.frame = CGRectMake(Answer_Width, _aBtn.top, Answer_Width, Answer_Height);
    _bBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_bBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_bBtn addTarget:self action:@selector(chooseQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bBtn];
    
    self.cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cBtn setImage:[UIImage imageNamed:@"单选按钮未选中.png"] forState:UIControlStateNormal];
    [_cBtn setImage:[UIImage imageNamed:@"单选 按钮.png"] forState:UIControlStateSelected];
    _cBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    _cBtn.frame = CGRectMake(0, _bBtn.bottom, Answer_Width, Answer_Height);
    _cBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_cBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_cBtn addTarget:self action:@selector(chooseQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cBtn];
    
    self.dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dBtn setImage:[UIImage imageNamed:@"单选按钮未选中.png"] forState:UIControlStateNormal];
    [_dBtn setImage:[UIImage imageNamed:@"单选 按钮.png"] forState:UIControlStateSelected];
    _dBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_dBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    _dBtn.frame = CGRectMake(Answer_Width, _bBtn.bottom, Answer_Width, Answer_Height);
    _dBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_dBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _dBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _dBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_dBtn addTarget:self action:@selector(chooseQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dBtn];
    
//    self.aCardBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, _dBtn.bottom, self.frame.size.width / 5.0 , Answer_Height) backgroundImage:[UIImage imageNamed:@"card1.jpg"] target:self action:@selector(chooseCard:)];
//    [self addSubview:_aCardBtn];
//    
//    self.bCardBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(_aCardBtn.right, _dBtn.bottom, self.frame.size.width / 5.0 , Answer_Height) backgroundImage:[UIImage imageNamed:@"card2.jpg"] target:self action:@selector(chooseCard:)];
//    [self addSubview:_bCardBtn];
//    
//    self.cCardBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(_bCardBtn.right, _dBtn.bottom, self.frame.size.width / 5.0 , Answer_Height) backgroundImage:[UIImage imageNamed:@"card3.jpg"] target:self action:@selector(chooseCard:)];
//    [self addSubview:_cCardBtn];
//    
//    self.dCardBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(_cCardBtn.right, _dBtn.bottom, self.frame.size.width / 5.0 , Answer_Height) backgroundImage:[UIImage imageNamed:@"card4.jpg"] target:self action:@selector(chooseCard:)];
//    [self addSubview:_dCardBtn];
//    
//    self.eCardBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(_dCardBtn.right, _dBtn.bottom, self.frame.size.width / 5.0 , Answer_Height) backgroundImage:[UIImage imageNamed:@"card5.jpg"] target:self action:@selector(chooseCard:)];
//    [self addSubview:_eCardBtn];
    
    
    
}

- (void)tenTimeFireMethod
{
//    NSLog(@"self.secondsCountDown1:  %d", self.secondsCountDown1);
    //倒计时-1
    self.secondsCountDown1--;
    //修改倒计时标签现实内容
    self.promptLab.text = @"还有    秒显示题目";
    self.questionTimeLab.text=[NSString stringWithFormat:@"%d",self.secondsCountDown1];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.secondsCountDown1==0){
        [self.myTimer1 invalidate];
        self.myTimer1 = nil;
        self.questionTimeLab.text = @"";
        [self addSubview:self.tittleLab];
        self.secondsCountDown1 = 5;
        //设置倒计时总时长
        self.secondsCountDown2 = 5;//另一个5秒倒计时
        [self.promptLab addSubview:_answerTimeLab];
        self.promptLab.text = @"还有    秒选择作答";
        [self.myTimer2 invalidate];
        self.myTimer2 = nil;
        //开始倒计时
        self.myTimer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fiveTimeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
        [[NSRunLoop currentRunLoop] addTimer:self.myTimer2 forMode:NSRunLoopCommonModes];
        self.answerTimeLab.text = [NSString stringWithFormat:@"%d",self.secondsCountDown2];
    }

}

//5秒倒计时
- (void)fiveTimeFireMethod
{
    //倒计时-1
    self.secondsCountDown2--;
    //修改倒计时标签现实内容
    self.promptLab.text = @"还有    秒选择作答";
    self.answerTimeLab.text=[NSString stringWithFormat:@"%d",self.secondsCountDown2];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.secondsCountDown2==0){
        [self.myTimer2 invalidate];
        self.myTimer2 = nil;
        [self.answerTimeLab removeFromSuperview];
        self.secondsCountDown2 = -1;
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"answerOverTime" object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }

}

- (void)chooseQuestion:(UIButton *)btn
{
    if (self.secondsCountDown2 >= 0 & self.secondsCountDown2 <= 5) {
        btn.selected = !btn.selected;
        [self.myTimer2 invalidate];//一旦已经开始答题,就将计时器移除
        self.myTimer2 = nil;
        self.secondsCountDown2 = -1;
        [self.answerTimeLab removeFromSuperview];
        if ([[btn.titleLabel.text substringToIndex:1] isEqualToString:self.question.Answer]) {
            //            NSLog(@"答案正确,进入下一页");
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"answerRight" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }else{
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"answerError" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
    }
}

- (void)chooseCard:(UIButton *)btn
{
    NSLog(@"选择卡牌");
}

- (void)setQuestion:(Question *)question
{
    _question = question;
    self.aBtn.selected = NO;
    self.bBtn.selected = NO;
    self.cBtn.selected = NO;
    self.dBtn.selected = NO;
    [self.aBtn setTitle:[NSString stringWithFormat:@"A:%@", question.A] forState:UIControlStateNormal];
    [self.bBtn setTitle:[NSString stringWithFormat:@"B:%@", question.B] forState:UIControlStateNormal];
    [self.cBtn setTitle:[NSString stringWithFormat:@"C:%@", question.C] forState:UIControlStateNormal];
    [self.dBtn setTitle:[NSString stringWithFormat:@"D:%@", question.D] forState:UIControlStateNormal];
    
    //设置倒计时总时长
    self.secondsCountDown1 = 5;//10秒倒计时
    self.secondsCountDown2 = -1;//初始值
    
    [self.myTimer2 invalidate];
    self.myTimer2 = nil;
    //开始倒计时
    [self.myTimer1 invalidate];
    self.myTimer1 = nil;
    self.myTimer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tenTimeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    [[NSRunLoop currentRunLoop] addTimer:self.myTimer1 forMode:NSRunLoopCommonModes];
    self.questionTimeLab.text = [NSString stringWithFormat:@"%d",self.secondsCountDown1];//10秒倒计时
    
    self.answerTimeLab.text = [NSString stringWithFormat:@"%d",self.secondsCountDown2];
    self.tittleLab.text = @"";

    //延时5秒显示的标题
    [self performSelector:@selector(showTittle) withObject:self afterDelay:5];
}

- (void)showTittle
{
    self.tittleLab.text = [NSString stringWithFormat:@" %@",_question.Q];
}


@end
