//
//  FirstChipController.m
//  MyUnityOniOS
//
//  Created by Oneprime on 16/7/21.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "FirstChipController.h"

@interface FirstChipController ()

@property (nonatomic, strong)UIImageView * myImageView;

@end

@implementation FirstChipController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor purpleColor];
    
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
    OBShapedButton *btn = [OBShapedButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(40, 70, self.view.frame.size.width - 80, self.view.frame.size.height - 150);
    UIImage *image = [UIImage imageNamed:@"碎片1 - 副本.png"];
    UIImage *btnImage = [image stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [btn.layer setBorderWidth:2.0]; //边框宽度
    [_myImageView addSubview:btn];
    
    UILabel * lab = [UILabel labelWithFrame:CGRectMake(20, 20, 200, 40) fontSize:30.0 textAlignment:NSTextAlignmentLeft text:@"碎片No.1"];
    lab.textColor = [UIColor whiteColor];
    [btn addSubview:lab];
    
    UIImageView * imageView1 = [UIImageView imageViewWithFrame:CGRectMake(btn.left + 20, btn.top + btn.height / 4.0, 90, 80) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"1号碎片线索2.png"]];
    [_myImageView addSubview:imageView1];
    
    UIImageView * imageView2 = [UIImageView imageViewWithFrame:CGRectMake(self.view.frame.size.width / 2.0, btn.top + btn.height / 6.0, btn.width / 2.0 - 15, btn.width / 2.0 - 15) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"1号碎片线索3.png"]];
    [_myImageView addSubview:imageView2];
    
    UIImageView * imageView3 = [UIImageView imageViewWithFrame:CGRectMake(btn.left + 10, imageView2.bottom + 10, btn.width - 20, btn.width - 20) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"1号碎片线索1.png"]];
    [_myImageView addSubview:imageView3];
    
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
