//
//  FifthChipController.m
//  MyUnityOniOS
//
//  Created by Oneprime on 16/7/22.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "FifthChipController.h"

@interface FifthChipController ()

@property (nonatomic, strong)UIImageView * myImageView;

@end

@implementation FifthChipController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [self createSubViews];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubViews
{
    UIScrollView * myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 70, self.view.frame.size.width - 80, self.view.frame.size.height - 150)];
    myScrollView.backgroundColor = [UIColor whiteColor];
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width - 80, 600);
    myScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myScrollView];
    
    OBShapedButton *btn = [OBShapedButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, myScrollView.width, myScrollView.height);
    UIImage *image = [UIImage imageNamed:@"碎片5 - 副本.png"];
    UIImage *btnImage = [image stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [btn.layer setBorderWidth:2.0]; //边框宽度
    [myScrollView addSubview:btn];
    
    UILabel * lab = [UILabel labelWithFrame:CGRectMake(20, btn.height / 5.0 * 3 + 20, 200, 40) fontSize:30.0 textAlignment:NSTextAlignmentLeft text:@"碎片No.5"];
    lab.textColor = [UIColor whiteColor];
    [btn addSubview:lab];
    
}

- (void)startToFind
{
    NSLog(@"开始寻找碎片5号");
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
