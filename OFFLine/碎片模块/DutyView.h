//
//  DutyView.h
//  MyUnityOniOS
//
//  Created by Oneprime on 16/7/20.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DutyView : UIView

@property (nonatomic, strong)UIImageView * imageView;//图片
@property (nonatomic, strong)UIButton * clickBtn;//点击按钮
@property (nonatomic, strong)UILabel * tittleLab;//标题
@property (nonatomic, strong)UILabel * contentLab;//内容
@property (nonatomic, strong)UIButton * startBtn;//任务开始按钮

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image tittle:(NSString *)tittle content:(NSString *)content;

@end
