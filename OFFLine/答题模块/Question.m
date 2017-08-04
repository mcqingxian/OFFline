//
//  Question.m
//  MyUnityOniOS
//
//  Created by Apple on 16/8/12.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "Question.h"

@implementation Question

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
