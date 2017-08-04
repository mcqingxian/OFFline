//
//  Chip.m
//  MyUnityOniOS
//
//  Created by Apple on 16/8/22.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "Chip.h"

@implementation Chip

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}


@end
