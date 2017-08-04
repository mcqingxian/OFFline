//
//  StartChipController.m
//  MyUnityOniOS
//
//  Created by Apple on 16/8/19.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "StartChipController.h"
#import "AnswerController.h"
#import "Chip.h"
#import "GameVC.h"
#import "Header.h"
#import "MyController.h"

#define START_LEFT_SPACE 50
#define START_WIDTH ([UIScreen mainScreen].applicationFrame.size.width - START_LEFT_SPACE * 2)
@interface StartChipController ()

@property (nonatomic, strong)UILabel * tittleLab;//碎片名称
@property (nonatomic, strong)UIImageView * iconImageview;//碎片图片
@property (nonatomic, strong)UILabel * contentLab;//碎片描述

@end

@implementation StartChipController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
}

//返回上一页
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //背景图
    UIImageView * bgImageview = [UIImageView imageViewWithFrame:[UIScreen mainScreen].applicationFrame backgroundColor:nil image:[UIImage imageNamed:@"碎片初始页背景.png"]];
    bgImageview.userInteractionEnabled = YES;
    [self.view addSubview:bgImageview];
    
    //返回按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(20, 20, 13, 20) backgroundImage:[UIImage imageNamed:@"back2@2x.png"] target:self action:@selector(back)];
    [bgImageview addSubview:backBtn];
    
    //碎片名称
    self.tittleLab = [UILabel labelWithFrame:CGRectMake(START_LEFT_SPACE, 100, START_WIDTH, 40) fontSize:18.0 textAlignment:NSTextAlignmentCenter text:_chip.ShardName];
//    _tittleLab.backgroundColor = [UIColor yellowColor];
    _tittleLab.textColor = [UIColor whiteColor];
    [bgImageview addSubview:_tittleLab];
    
    //碎片图片
    self.iconImageview = [UIImageView imageViewWithFrame:CGRectMake(START_LEFT_SPACE, _tittleLab.bottom + 10, START_WIDTH, START_WIDTH - 30) backgroundColor:nil image:[UIImage imageNamed:@"答题背景_死侍.png"]];
    [bgImageview addSubview:_iconImageview];
    
    //距离小图标
    UIImageView * distanceImageView = [UIImageView imageViewWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width / 3.0, _iconImageview.bottom - 30, 20, 30) backgroundColor:nil image:[UIImage imageNamed:@"答题首页_距离图标.png"]];
    [bgImageview addSubview:distanceImageView];
    
    //当前距离
    UILabel * distanceLab = [UILabel labelWithFrame:CGRectMake(distanceImageView.right + 10, distanceImageView.top, START_WIDTH / 2.0, 30) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft textColor:[UIColor whiteColor] fontSize:15.0];
    distanceLab.text = self.distance;
    [bgImageview addSubview:distanceLab];
    
    //碎片描述
    self.contentLab = [UILabel labelWithFrame:CGRectMake(40, _iconImageview.bottom + 10, [UIScreen mainScreen].applicationFrame.size.width - 80, 60) fontSize:15.0 textAlignment:NSTextAlignmentLeft text:[NSString stringWithFormat:@"      %@", _chip.ShardDesc]];
    _contentLab.textColor = [UIColor whiteColor];
//    _contentLab.backgroundColor = [UIColor yellowColor];
    _contentLab.numberOfLines = 0;
    [bgImageview addSubview:_contentLab];
    
    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width / 3.0, _contentLab.bottom + 40, [UIScreen mainScreen].applicationFrame.size.width / 3.0, 40) tittle:@"开始挑战" backgroundColor:MyBlueColor target:self action:@selector(startToChallenge)];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.layer.masksToBounds = YES;
    startBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [startBtn.layer setBorderWidth:1.0]; //边框宽度
    [startBtn.layer setCornerRadius:6.0];
    [bgImageview addSubview:startBtn];
    
}

- (void)startToChallenge
{    
    [TipView showWithTitle:@"提示" Tip:@"请将手机正面垂直面向自己，通过摄像头搜索敌方战机，点击屏幕发射弹药，消灭所有敌人。" Block:^{
        [self pushViewController:@"GameVC" Param:@{@"type":@0}];
//        MyController * myVC = [[MyController alloc] init];
//        [self.navigationController pushViewController:myVC animated:YES];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
