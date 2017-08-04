//
//  DutyController.m
//  MyUnityOniOS
//
//  Created by Oneprime on 16/7/20.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "DutyController.h"
#import "DutyView.h"
#import "ChipController.h"

#define Duty_Space 50
#define Duty_Width self.view.frame.size.width - Duty_Space * 2
#define Duty_Height 120
@interface DutyController ()

@property (nonatomic, strong)UIImageView * myImageView;

@end

@implementation DutyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor redColor];
    
    _myImageView = [UIImageView imageViewWithFrame:CGRectMake(-8, -16, [UIApplication sharedApplication].keyWindow.frame.size.width + 8, [UIApplication sharedApplication].keyWindow.frame.size.height + 16) backgroundColor:nil image:[UIImage imageNamed:@"背景底图"]];
    [self.view addSubview:_myImageView];
    _myImageView.userInteractionEnabled = YES;
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 26, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_myImageView addSubview:backBtn];
    
    [self createSubViews];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubViews
{
    NSString * content = @"奖品价值最高价限定15000元人民币,最终奖品将由获奖者亲自陪同于品牌专卖店进行购买,并进行全程直播.所有用户均可参加,所收集的碎片可赠与其他用户,最先集齐者为唯一赢家,任务不设限期,有人胜出为止.获奖者将有义务配合Offline进行适当的宣传活动。";
    DutyView * dutyView1 = [[DutyView alloc] initWithFrame:CGRectMake(Duty_Space + 8, Duty_Space + 64, Duty_Width, Duty_Height) image:[UIImage imageNamed:@"523212风语者.png"] tittle:@"7个碎片 = 1个包包\n还等什么" content:content];
    [dutyView1.startBtn addTarget:self action:@selector(startToGame:) forControlEvents:UIControlEventTouchUpInside];
    [_myImageView addSubview:dutyView1];
    
    DutyView * dutyView2 = [[DutyView alloc] initWithFrame:CGRectMake(Duty_Space + 8, 20 + dutyView1.bottom, Duty_Width, Duty_Height) image:[UIImage imageNamed:@"523212魔都.png"] tittle:@"7个碎片 = 1个包包\n还等什么" content:content];
    [dutyView2.startBtn addTarget:self action:@selector(startToGame:) forControlEvents:UIControlEventTouchUpInside];
    [_myImageView addSubview:dutyView2];
    
    DutyView * dutyView3 = [[DutyView alloc] initWithFrame:CGRectMake(Duty_Space + 8, 20 + dutyView2.bottom, Duty_Width, Duty_Height) image:[UIImage imageNamed:@"523212LV.png"] tittle:@"7个碎片 = 1个包包\n还等什么" content:content];
    [dutyView3.startBtn addTarget:self action:@selector(startToGame:) forControlEvents:UIControlEventTouchUpInside];
    [_myImageView addSubview:dutyView3];
    
}

- (void)changeFrame:(DutyView *)dutyView
{
    if (dutyView.frame.size.height == Duty_Height) {
        [dutyView setFrame:CGRectMake(Duty_Space + 8, Duty_Space + 2 - 30, Duty_Width, 450)];
    }else{
        [dutyView setFrame:CGRectMake(Duty_Space + 8, Duty_Space, Duty_Width, Duty_Height)];
    }
    
    NSLog(@"%f", dutyView.frame.size.height);
}

- (void)startToGame:(DutyView *)dutyView
{
    ChipController * chipVC = [ChipController defaultChip];
    [self.navigationController pushViewController:chipVC animated:YES];
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
