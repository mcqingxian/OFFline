//
//  UIDefines.m
//  ContactWork12-4
//
//  Created by death on 14-12-4.
//  Copyright (c) 2014年 蓝鸥科技www.lanou.3g.com. All rights reserved.
//

#import "UIDefines.h"
@implementation UIImageView (MyImageView)
//带背景颜色类目
+ (UIImageView *)imageViewWithFrame:(CGRect )rect backgroundColor:(UIColor *)color
{
    UIImageView * aImageView = [[UIImageView alloc]initWithFrame:rect];
    aImageView.backgroundColor = color;
    return [aImageView autorelease];
}

//带背景图类目
+ (UIImageView *)imageViewWithFrame:(CGRect )rect backgroundColor:(UIColor *)color image:(UIImage *)aImage
{
    UIImageView * aImageView = [[UIImageView alloc]initWithFrame:rect];
    aImageView.backgroundColor = color;
    aImageView.image = aImage;
    return [aImageView autorelease];

}
//带背景图类目 背景色 tag值
+ (UIImageView *)imageViewWithFrame:(CGRect )rect backgroundColor:(UIColor *)color image:(UIImage *)aImage tag:(NSInteger)aTag
{

    UIImageView * aImageView = [[UIImageView alloc]initWithFrame:rect];
    aImageView.backgroundColor = color;
    aImageView.image = aImage;
    aImageView.tag = aTag;
    return [aImageView autorelease];

}

@end

@implementation UIButton (MyButton)

+ (UIButton *)buttonWithType:(UIButtonType )aType
                      frame :(CGRect)frame
             backgroundImage:(UIImage *)aImage

{
    UIButton * aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = frame;
    [aButton setBackgroundImage:aImage forState:UIControlStateNormal];    
    return aButton;
}
+ (UIButton *)buttonWithType:(UIButtonType )aType
                      frame :(CGRect)frame
             backgroundImage:(UIImage *)aImage
                      target:(id)aTarget
                      action:(SEL)action
{

    UIButton * button = [UIButton buttonWithType:aType];
    button.frame = frame;
    [button setBackgroundImage:aImage forState:UIControlStateNormal];
    [button addTarget:aTarget action:action forControlEvents:UIControlEventTouchUpInside];
    return button;

}

+ (UIButton *)buttonWithType:(UIButtonType)aType
                       frame:(CGRect)frame
                      tittle:(NSString *)tittle
             backgroundColor:(UIColor *)color
                      target:(id)aTarget
                      action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:aType];
    button.frame = frame;
    [button setTitle:tittle forState:UIControlStateNormal];
    button.backgroundColor = color;
    [button addTarget:aTarget action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end

@implementation UILabel(MyLabel)
+ (UILabel *)labelWithFrame:(CGRect )rect backgroundColor:(UIColor *)color textAlignment:(NSTextAlignment)atextAliment textColor:(UIColor *)atextColor fontSize:(CGFloat )fontSize
{
    
    UILabel * alabel = [[UILabel alloc]initWithFrame:rect];
    alabel.backgroundColor = color;
    alabel.textAlignment = atextAliment;
    alabel.textColor = atextColor;
    alabel.font = [UIFont systemFontOfSize:fontSize];
    return alabel;
    
}
@end


@implementation UIViewController (CustomNavigationBar)

- (void)customNavigationBarWithTitle:(NSString *)aTitle
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor grayColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.text = aTitle;
    self.navigationItem.titleView = [titleLabel autorelease];
}
@end


@implementation UINavigationController (myNavigationController)

- (void)setNavigationBarBackgroundImge
{
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar_bg@2x.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor whiteColor];

}

@end
