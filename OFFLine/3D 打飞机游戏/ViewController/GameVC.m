//
//  GameVC.m
//  SkyFighting
//
//  Created by 孙昕 on 15/12/27.
//  Copyright © 2015年 孙昕. All rights reserved.
//

#import "GameVC.h"
#import "GameView.h"
#import "Header.h"
#import "IntroView.h"
#import "FinishController.h"
#import "StartChipController.h"
#import "AnswerController.h"

@interface GameVC ()<GameViewDelegate>
{
    GameView *viewGame;
    NSDate *date;
    NSInteger level;
    NSInteger type;
}
@end

@implementation GameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    date=[NSDate date];
    viewGame=(GameView*)self.view;
    if(type==0)
    {
        LevelInfo *info=[[UserDefaults sharedInstance] levelInfo:level];
        [viewGame setup:info.count PlayerBlood:info.bloodPlayer EnemyBlood:info.bloodEnemy DispalyGap:info.displayGap FireGap:info.fireGap BulletCount:info.bulletCount BombCount:info.bombCount LaserCount:info.laserCount ProtectCount:info.protectCount];
    }
    else
    {
        [viewGame setup:1000 PlayerBlood:10000 EnemyBlood:500 DispalyGap:5 FireGap:5 BulletCount:9999 BombCount:999 LaserCount:99 ProtectCount:50];
    }
    viewGame.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self removeHud];
    self.bHud=NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(type==0 && level==0)
    {
        [viewGame start];
//        [IntroView showTitle:@[@{
//                                   @"title":@"这里是你的子弹数目，瞄准敌机，点击屏幕，发射子弹！",
//                                   @"rect":[NSValue valueWithCGRect:CGRectMake(20, 100, 300, 60)],
//                                   @"view":[viewGame valueForKey:@"lbBullet"]
//                                   }] Block:^{
//                                                   [viewGame start];
//                                               }];
    }
    else if(type==1)
    {
        [TipView showWithTitle:@"求生模式" Tip:@"在求生模式下，敌人无限多，你需要尽可能多的去消灭他们，祝你好运！" Block:^{
            [viewGame start];
        }];
    }
    else
    {
        [viewGame start];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)GameViewFinish:(BOOL)bSuccess KillCount:(NSInteger)count
{
    UserHistory *obj=[[UserHistory alloc] init];
    obj.date=[date stringValue];
    obj.level=level;
    obj.bSuccess=bSuccess;
    obj.killCount=count;
    obj.useTime=[[NSDate date] timeIntervalSinceDate:date];
    obj.type=type;
    [[UserDefaults sharedInstance] addHistory:obj];
    if(bSuccess)
    {
        [TipView showWithTitle:@"闯关成功" Tip:@"成功进入答题环节！屏幕会先显示4个备选项，5秒后题目出现，只有5秒时间做出正确选择，连续答对3题，即可成功过关。" Block:^{
            [[UserDefaults sharedInstance] addLevel];
            //进入答题页面
            AnswerController * vc = [[AnswerController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

        }];
    }
    else
    {
        [TipView showWithTitle:@"闯关失败" Tip:@"再多磨练磨练吧！" Block:^{
            //返回上一页的开始页面
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
@end








