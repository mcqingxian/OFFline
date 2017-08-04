//
//  AView.h
//  WuLiuPeiSong
//
//  Created by Oneprime on 15/5/25.
//  Copyright (c) 2015年 Oneprime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AView : UIView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title placeHolder:(NSString *)placeHolder isEntry:(BOOL)secureTextEntry;

@property (nonatomic, strong)UITextField * textField;


@end
