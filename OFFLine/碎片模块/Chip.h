//
//  Chip.h
//  MyUnityOniOS
//
//  Created by Apple on 16/8/22.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chip : NSObject

@property (nonatomic, assign)NSInteger Count;//该碎片数量
@property (nonatomic, strong)NSString * ItenID;//分号ID
@property (nonatomic, strong)NSString * Latitude;//维度
@property (nonatomic, strong)NSString * Longitude;//经度
@property (nonatomic, assign)NSInteger OT_Buy;//
@property (nonatomic, assign)NSInteger OT_Sell;//
@property (nonatomic, strong)NSString * ShardDesc;//碎片描述
@property (nonatomic, strong)NSString * ShardID;//碎片ID
@property (nonatomic, strong)NSString * ShardIcon;//碎片图表
@property (nonatomic, strong)NSString * ShardName;//碎片名称
@property (nonatomic, strong)NSString * ShardPic;//碎片图片


- (id)initWithDictionary:(NSDictionary *)dic;

@end
