//
//  AView.m
//  WuLiuPeiSong
//
//  Created by Oneprime on 15/5/25.
//  Copyright (c) 2015年 Oneprime. All rights reserved.
//

#import "AView.h"

@implementation AView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title placeHolder:(NSString *)placeHolder isEntry:(BOOL)secureTextEntry
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        [self.layer setBorderWidth:1.0]; //边框宽度
        [self.layer setCornerRadius:5.0];

        
        UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 4.0, self.frame.size.height)];
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.text = title;
        aLabel.textColor = [UIColor whiteColor];
        aLabel.font = [UIFont systemFontOfSize:15.0];
        aLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:aLabel];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width / 4.0, 0, self.frame.size.width / 4.0 * 3, self.frame.size.height)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = placeHolder;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.secureTextEntry = secureTextEntry;//是否密文输入
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        [self addSubview:_textField];
        
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
