//
//  ChipController.m
//  MyUnityOniOS
//
//  Created by Oneprime on 16/7/21.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "ChipController.h"
#import "FirstChipController.h"
#import "SecondChipController.h"
#import "ThirdChipController.h"
#import "ForthChipController.h"
#import "FifthChipController.h"
#import "SixthChipController.h"
#import "SeventhChipController.h"

@interface ChipController ()

@property (nonatomic, strong)UIImageView * myImageView;

@end

@implementation ChipController

+ (ChipController *)defaultChip
{
    static ChipController * chipVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chipVC  = [[ChipController alloc] init];
    });
    return chipVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
//    self.view.backgroundColor = [UIColor greenColor];
    
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
    OBShapedButton *findCarBtn = [OBShapedButton buttonWithType:UIButtonTypeSystem];
    findCarBtn.frame = CGRectMake(48, 70, self.view.frame.size.width - 80, self.view.frame.size.height - 150);
    UIImage *findCarImage = [UIImage imageNamed:@"碎片1 - 副本.png"];
    UIImage *findCarBtnImage = [findCarImage stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [findCarBtn setBackgroundImage:findCarBtnImage forState:UIControlStateNormal];
    findCarBtn.backgroundColor = [UIColor clearColor];
    [findCarBtn addTarget:self action:@selector(findcar:) forControlEvents:UIControlEventTouchUpInside];
    findCarBtn.layer.masksToBounds = YES;
    findCarBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [findCarBtn.layer setBorderWidth:2.0]; //边框宽度
    findCarBtn.tag = 1201;
    [_myImageView addSubview:findCarBtn];
    
    OBShapedButton *findCarBtn2 = [OBShapedButton buttonWithType:UIButtonTypeSystem];
    findCarBtn2.frame = CGRectMake(48, 70, self.view.frame.size.width - 80, self.view.frame.size.height - 150);
    findCarBtn2.tag = 1202;
    UIImage *findCarImage2 = [UIImage imageNamed:@"碎片2 - 副本.png"];
    UIImage *findCarBtnImage2 = [findCarImage2 stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [findCarBtn2 setBackgroundImage:findCarBtnImage2 forState:UIControlStateNormal];
    findCarBtn2.backgroundColor = [UIColor clearColor];
    [findCarBtn2 addTarget:self action:@selector(findcar:) forControlEvents:UIControlEventTouchUpInside];
    findCarBtn2.layer.masksToBounds = YES;
    findCarBtn2.layer.borderColor = [UIColor whiteColor].CGColor;
    [findCarBtn2.layer setBorderWidth:2.0]; //边框宽度
    [_myImageView addSubview:findCarBtn2];
    
    OBShapedButton *findCarBtn3 = [OBShapedButton buttonWithType:UIButtonTypeSystem];
    findCarBtn3.frame = CGRectMake(48, 70, self.view.frame.size.width - 80, self.view.frame.size.height - 150);
    findCarBtn3.tag = 1203;
    UIImage *findCarImage3 = [UIImage imageNamed:@"碎片3 - 副本.png"];
    UIImage *findCarBtnImage3 = [findCarImage3 stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [findCarBtn3 setBackgroundImage:findCarBtnImage3 forState:UIControlStateNormal];
    findCarBtn3.backgroundColor = [UIColor clearColor];
    [findCarBtn3 addTarget:self action:@selector(findcar:) forControlEvents:UIControlEventTouchUpInside];
    findCarBtn3.layer.masksToBounds = YES;
    findCarBtn3.layer.borderColor = [UIColor whiteColor].CGColor;
    [findCarBtn3.layer setBorderWidth:2.0]; //边框宽度
    [_myImageView addSubview:findCarBtn3];
    
    OBShapedButton *findCarBtn4 = [OBShapedButton buttonWithType:UIButtonTypeSystem];
    findCarBtn4.frame = CGRectMake(48, 70, self.view.frame.size.width - 80, self.view.frame.size.height - 150);
    findCarBtn4.tag = 1204;
    UIImage *findCarImage4 = [UIImage imageNamed:@"碎片4 - 副本.png"];
    UIImage *findCarBtnImage4 = [findCarImage4 stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [findCarBtn4 setBackgroundImage:findCarBtnImage4 forState:UIControlStateNormal];
    findCarBtn4.backgroundColor = [UIColor clearColor];
    [findCarBtn4 addTarget:self action:@selector(findcar:) forControlEvents:UIControlEventTouchUpInside];
    findCarBtn4.layer.masksToBounds = YES;
    findCarBtn4.layer.borderColor = [UIColor whiteColor].CGColor;
    [findCarBtn4.layer setBorderWidth:2.0]; //边框宽度
    [_myImageView addSubview:findCarBtn4];
    
    OBShapedButton *findCarBtn5 = [OBShapedButton buttonWithType:UIButtonTypeSystem];
    findCarBtn5.frame = CGRectMake(48, 70, self.view.frame.size.width - 80, self.view.frame.size.height - 150);
    findCarBtn5.tag = 1205;
    UIImage *findCarImage5 = [UIImage imageNamed:@"碎片5 - 副本.png"];
    UIImage *findCarBtnImage5 = [findCarImage5 stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [findCarBtn5 setBackgroundImage:findCarBtnImage5 forState:UIControlStateNormal];
    findCarBtn5.backgroundColor = [UIColor clearColor];
    [findCarBtn5 addTarget:self action:@selector(findcar:) forControlEvents:UIControlEventTouchUpInside];
    findCarBtn5.layer.masksToBounds = YES;
    findCarBtn5.layer.borderColor = [UIColor whiteColor].CGColor;
    [findCarBtn5.layer setBorderWidth:2.0]; //边框宽度
    [_myImageView addSubview:findCarBtn5];
    
    OBShapedButton *findCarBtn6 = [OBShapedButton buttonWithType:UIButtonTypeSystem];
    findCarBtn6.frame = CGRectMake(48, 70, self.view.frame.size.width - 80, self.view.frame.size.height - 150);
    findCarBtn6.tag = 1206;
    UIImage *findCarImage6 = [UIImage imageNamed:@"碎片6 - 副本.png"];
    UIImage *findCarBtnImage6 = [findCarImage6 stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [findCarBtn6 setBackgroundImage:findCarBtnImage6 forState:UIControlStateNormal];
    findCarBtn6.backgroundColor = [UIColor clearColor];
    [findCarBtn6 addTarget:self action:@selector(findcar:) forControlEvents:UIControlEventTouchUpInside];
    findCarBtn6.layer.masksToBounds = YES;
    findCarBtn6.layer.borderColor = [UIColor whiteColor].CGColor;
    [findCarBtn6.layer setBorderWidth:2.0]; //边框宽度
    [_myImageView addSubview:findCarBtn6];
    
    OBShapedButton *findCarBtn7 = [OBShapedButton buttonWithType:UIButtonTypeSystem];
    findCarBtn7.frame = CGRectMake(48, 70, self.view.frame.size.width - 80, self.view.frame.size.height - 150);
    findCarBtn7.tag = 1207;
    UIImage *findCarImage7 = [UIImage imageNamed:@"碎片7 - 副本.png"];
    UIImage *findCarBtnImage7 = [findCarImage7 stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [findCarBtn7 setBackgroundImage:findCarBtnImage7 forState:UIControlStateNormal];
    findCarBtn7.backgroundColor = [UIColor clearColor];
    [findCarBtn7 addTarget:self action:@selector(findcar:) forControlEvents:UIControlEventTouchUpInside];
    findCarBtn7.layer.masksToBounds = YES;
    findCarBtn7.layer.borderColor = [UIColor whiteColor].CGColor;
    [findCarBtn7.layer setBorderWidth:2.0]; //边框宽度
    [_myImageView addSubview:findCarBtn7];
    
    
}

- (void)findcar:(OBShapedButton *)btn
{
    switch (btn.tag) {
        case 1201:{
            FirstChipController * firstVC = [[FirstChipController alloc] init];
            [self.navigationController pushViewController:firstVC animated:YES];
        }
            break;
        case 1202:{
            SecondChipController * secondVC = [[SecondChipController alloc] init];
            [self.navigationController pushViewController:secondVC animated:YES];
        }
            break;
        case 1203:{
            ThirdChipController * thirdVC = [[ThirdChipController alloc] init];
            [self.navigationController pushViewController:thirdVC animated:YES];
        }
            break;
        case 1204:{
            ForthChipController * forthVC = [[ForthChipController alloc] init];
            [self.navigationController pushViewController:forthVC animated:YES];
        }
            break;
        case 1205:{
            FifthChipController * fifthVC = [[FifthChipController alloc] init];
            [self.navigationController pushViewController:fifthVC animated:YES];
        }
            break;
        case 1206:{
            SixthChipController * sixthVC = [[SixthChipController alloc] init];
            [self.navigationController pushViewController:sixthVC animated:YES];
        }
            break;
        case 1207:{
            SeventhChipController * seventhVC = [[SeventhChipController alloc] init];
            [self.navigationController pushViewController:seventhVC animated:YES];
        }
            break;
        default:
            break;
    }
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
