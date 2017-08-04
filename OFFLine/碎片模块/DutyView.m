//
//  DutyView.m
//  MyUnityOniOS
//
//  Created by Oneprime on 16/7/20.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "DutyView.h"

@implementation DutyView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image tittle:(NSString *)tittle content:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.masksToBounds = YES;
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
//        [self.layer setBorderWidth:2.0]; //边框宽度
//        [self.layer setCornerRadius:3.0];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120)];
        _imageView.image = image;
        _imageView.backgroundColor = [UIColor clearColor];
//        _imageView.userInteractionEnabled = YES;
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.frame = CGRectMake(0, 0, self.frame.size.width, 120);
        _clickBtn.backgroundColor = [UIColor clearColor];
        [_clickBtn addTarget:self action:@selector(changeMyFrame) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clickBtn];
        
        self.tittleLab = [UILabel labelWithFrame:CGRectMake(0, _clickBtn.bottom, self.frame.size.width, 100) fontSize:28.0 textAlignment:NSTextAlignmentCenter text:tittle];
        _tittleLab.numberOfLines = 0;
        [self addSubview:_tittleLab];
        
        self.contentLab = [UILabel labelWithFrame:CGRectMake(10, _tittleLab.bottom, self.frame.size.width - 20, 120) fontSize:14.0 textAlignment:NSTextAlignmentLeft text:content];
        _contentLab.numberOfLines = 0;
        [self addSubview:_contentLab];
        
        self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(60, _contentLab.bottom + 20, self.frame.size.width - 120, 60);
        _startBtn.backgroundColor = [UIColor darkGrayColor];
        [_startBtn setTitle:@"同意并开始行动" forState:UIControlStateNormal];
        _startBtn.layer.masksToBounds = YES;
        _startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_startBtn.layer setBorderWidth:2.0]; //边框宽度
        [_startBtn.layer setCornerRadius:10.0];
        [self addSubview:_startBtn];
        
        
        
        
    }
    return self;
}

static float original;
- (void)changeMyFrame
{
    if (self.frame.size.height == 120) {
        [self.superview bringSubviewToFront:self];
        original = self.top;//记录初始位置
        NSLog(@"%f", self.top);
        [self setFrame:CGRectMake(self.left, 40 + 64, self.width, 450)];
    }else{
        [self setFrame:CGRectMake(self.left, original, self.width, 120)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
