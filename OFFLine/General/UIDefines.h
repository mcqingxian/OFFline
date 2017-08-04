//
//  UIDefines.h
//  ContactWork12-4
//
//  Created by death on 14-12-4.
//  Copyright (c) 2014年 蓝鸥科技www.lanou.3g.com. All rights reserved.
//本类用于扩展类目

#import <UIKit/UIKit.h>
//UIimageview 类目
@interface UIImageView (MyImageView)
//带背景颜色类目
+ (UIImageView *)imageViewWithFrame:(CGRect )rect backgroundColor:(UIColor *)color;

//带背景图类目 背景色
+ (UIImageView *)imageViewWithFrame:(CGRect )rect backgroundColor:(UIColor *)color image:(UIImage *)aImage;


//带背景图类目 背景色 tag值
+ (UIImageView *)imageViewWithFrame:(CGRect )rect backgroundColor:(UIColor *)color image:(UIImage *)aImage tag:(NSInteger)aTag;
@end


@interface UIButton (MyButton)
//button类目  带标题 背景图 frame  button

+ (UIButton *)buttonWithType:(UIButtonType )aType
                      frame :(CGRect)frame
             backgroundImage:(UIImage *)aImage
                       ;
+ (UIButton *)buttonWithType:(UIButtonType )aType
                      frame :(CGRect)frame
             backgroundImage:(UIImage *)aImage
                      target:(id)aTarget
                      action:(SEL)action
;

+ (UIButton *)buttonWithType:(UIButtonType)aType
                       frame:(CGRect)frame
                      tittle:(NSString *)tittle
             backgroundColor:(UIColor *)color
                      target:(id)aTarget
                      action:(SEL)action;

@end

@interface UILabel(MyLabel)
+ (UILabel *)labelWithFrame:(CGRect )rect backgroundColor:(UIColor *)color textAlignment:(NSTextAlignment)atextAliment textColor:(UIColor *)atextColor fontSize:(CGFloat )fontSize;

@end

@interface UIViewController (CustomNavigationBar)

- (void)customNavigationBarWithTitle:(NSString *)aTitle;

@end


@interface UINavigationController (myNavigationController)
- (void)setNavigationBarBackgroundImge;
@end


