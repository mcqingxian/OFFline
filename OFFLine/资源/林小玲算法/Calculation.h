//
//  Calculation.h
//  OFFLine
//
//  Created by Apple on 2017/1/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculation : NSObject

+ (Calculation *)defaultCalculation;

// length 手机屏幕长度，单位为厘米(cm) 
// width 手机屏幕宽度，单位为厘米(cm) 
// focus 手机摄像头等效焦距，单位为毫米(mm)，例如iPhone5s的等效焦距为30 mm，iPhone6和iPhone6Plus的等效焦距为29 mm 
// distance 物体与手机的垂直距离，单位为米(m) 
// phoneHeight 手机所在位置海拔高度，单位为米(m) 
// objectHeight 物体海拔高度，单位为米(m) 
// angle 手机与水平面的倾斜角，单位为度，向上倾斜为正数，向下倾斜为负数 
// horLabel 手机横向放置时为1，手机竖向放置时为0
// rotAngle 手机与物体的夹角，单位为度，例如如果物体在手机正前方，度数为0；如果物体在手机的正前方偏右30度，就为正30度；如果物体在手机的正前方偏左30度，就为负30度
// <returns>返回-1时，表示物体不在手机的视角范围

//获得物体在手机屏幕中的Y坐标，单位为厘米(cm)
- (double)getYCoordinateByLength:(double)length Width:(double)width Focus:(double)focus Distance:(double)distance PhoneHeight:(double)phoneHeight ObjectHeight:(double)objectHeight Angle:(double)angle Percent:(double)percent HorLabel:(double)horLabel;

//获得物体在手机屏幕中的X坐标，单位为厘米(cm)
- (double)getXCoordinateByLength:(double)length Width:(double)width Focus:(double)focus Angle:(double)angle ObjectX:(double)objectX ObjectY:(double)objectY PhoneX:(double)phoneX PhoneY:(double)phoneY  Percent:(double)percent HorLabel:(double)horLabel;

// 获得物体在手机屏幕中的占比
- (double)getPercentByFocus:(double)focus Distance:(double)distance ObjectHeight:(double)objectHeight horLabel:(double)horLabel maxPercent:(double)maxPercent;


@end
