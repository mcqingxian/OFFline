//
//  Question.h
//  MyUnityOniOS
//
//  Created by Apple on 16/8/12.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic, strong)NSString * A;
@property (nonatomic, strong)NSString * B;
@property (nonatomic, strong)NSString * C;
@property (nonatomic, strong)NSString * D;
@property (nonatomic, strong)NSString * Q;//问题
@property (nonatomic, strong)NSString * Answer;//答案
@property (nonatomic, assign)int Qno;//题目序号
@property (nonatomic, strong)NSString * QID;//题目ID

- (id)initWithDictionary:(NSDictionary *)dic;

@end
