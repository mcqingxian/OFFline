//
//  Calculation.m
//  OFFLine
//
//  Created by Apple on 2017/1/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Calculation.h"

@implementation Calculation

+ (Calculation *)defaultCalculation
{
    static Calculation * vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[Calculation alloc] init];
    });
    return vc;
}

/// 获得物体在手机屏幕中的Y坐标，单位为厘米(cm)
/// </summary>
/// <param name="length">手机屏幕长度，单位为厘米(cm)</param>
/// <param name="width">手机屏幕宽度，单位为厘米(cm)</param>
/// <param name="focus">手机摄像头等效焦距，单位为毫米(mm)，例如iPhone5s的等效焦距为30 mm，iPhone6和iPhone6Plus的等效焦距为29 mm</param>
/// <param name="distance">物体与手机的垂直距离，单位为米(m)</param>
/// <param name="phoneHeight">手机所在位置海拔高度，单位为米(m)</param>
/// <param name="objectHeight">物体海拔高度，单位为米(m)</param>
/// <param name="angle">手机与水平面的倾斜角，单位为度，向上倾斜为正数，向下倾斜为负数</param>
/// <param name="percent">物体在手机屏幕中的占比</param> 
/// <param name="horLabel">手机横向放置时为1，手机竖向放置时为0</param>
/// <returns>返回-1000时，表示物体不在手机的视角范围</returns>
- (double)getYCoordinateByLength:(double)length Width:(double)width Focus:(double)focus Distance:(double)distance PhoneHeight:(double)phoneHeight ObjectHeight:(double)objectHeight Angle:(double)angle Percent:(double)percent HorLabel:(double)horLabel
{
    angle = (angle * M_PI) / 180; //角度转化为弧度

	objectHeight = objectHeight / 2;

	if (distance < 1)
        distance = 1;
      
    double visualAngle = 0;
    
    if (horLabel == 1)   //手机横向放置时    
        visualAngle = 2 * atan(24 / (2 * focus));
	else
	    visualAngle = 2 * atan(36 / (2 * focus));
		
	double y = 2 * distance * tan(visualAngle / 2);
        
    if (angle >= 0) //手机向上倾斜时
    {
        if (angle - visualAngle / 2 >= M_PI / 2)
            return -1000;
            
        double maxy = phoneHeight + distance * tan(visualAngle / 2 + angle);
            
        if (visualAngle / 2 + angle >=  M_PI / 2)
            maxy = 100000000000;
            
        double miny = phoneHeight + distance * tan(angle - visualAngle / 2);
            
        if (miny > objectHeight)
        {
            if ((miny - objectHeight) / y <= percent)
                return width + ((miny - objectHeight) / y) * width;
            else
                return -1000;
        }
        else
        {
            if (maxy <= objectHeight)
			{
                if ((objectHeight - maxy) / y <= percent)
					return ((maxy - objectHeight) / y) * width;
				else
					return -1000;
			}
            else
                return width - ((objectHeight - miny) / y) * width;
        }
    }
    else
    {
        if (angle * (-1) - visualAngle / 2 >=  M_PI / 2)
            return -1000;
            
        double maxy = phoneHeight - distance * tan(angle * (-1) - visualAngle / 2);
            
        double miny = phoneHeight - distance * tan(angle * (-1) + visualAngle / 2);
            
        if (angle * (-1) + visualAngle / 2 >=  M_PI / 2)
            miny = -100000000000;
            
        if (miny > objectHeight)
        {
            if ((miny - objectHeight) / y <= percent)
                return width + ((miny - objectHeight) / y) * width;
            else
                return -1000;
        }
        else
        {
            if (maxy <= objectHeight)
			{
                if ((objectHeight - maxy) / y <= percent)
                    return ((maxy - objectHeight) / y) * width;
                else
                    return -1000;
			}
            else                           
                return ((maxy - objectHeight) / y) * width;                      
        } 
    }    
}

/// <summary>
/// 获得物体在手机屏幕中的X坐标，单位为厘米(cm)
/// </summary>
/// <param name="length">手机屏幕长度，单位为厘米(cm)</param> 
/// <param name="width">手机屏幕宽度，单位为厘米(cm)</param>
/// <param name="focus">手机摄像头等效焦距，单位为毫米(mm)，例如iPhone5s的等效焦距为30 mm，iPhone6和iPhone6Plus的等效焦距为29 mm</param> 
/// <param name="angle">手机朝向与正北方向的夹角，单位为度，例如手机朝向正北，度数为0；手机朝向东北方向，就为正45度；手机朝向西北方向，就为负45度；范围从-180度到180度</param> 
/// <param name="objectX">物体所在位置的经度
/// <param name="objectY">物体所在位置的纬度
/// <param name="phoneX">手机所在位置的经度
/// <param name="phoneY">手机所在位置的纬度 
/// <param name="percent">物体在手机屏幕中的占比</param> 
/// <param name="horLabel">手机横向放置时为1，手机竖向放置时为0</param> 
/// <returns>返回-1000时，表示物体不在手机的视角范围</returns>
- (double)getXCoordinateByLength:(double)length Width:(double)width Focus:(double)focus Angle:(double)angle ObjectX:(double)objectX ObjectY:(double)objectY PhoneX:(double)phoneX PhoneY:(double)phoneY  Percent:(double)percent HorLabel:(double)horLabel
{
    angle = (angle * M_PI) / 180; //角度转化为弧度

    double newAngle = atan(fabs(objectX - phoneX) / fabs(objectY - phoneY));

    if (objectX >= phoneX && objectY <= phoneY)
        newAngle = M_PI - newAngle;

    if (objectX <= phoneX && objectY <= phoneY)
        newAngle = newAngle - M_PI;

    if (objectX <= phoneX && objectY >= phoneY)
        newAngle = newAngle * (-1);
                   
    double rotAngle = newAngle - angle;

    if (rotAngle > M_PI)
        rotAngle = rotAngle - 2 * M_PI;

    if (rotAngle < M_PI * (-1))
        rotAngle = rotAngle + 2 * M_PI;
    
    double visualAngle = 0;
    
    if (horLabel == 1)   //手机横向放置时
        visualAngle = 2 * atan(36 / (2 * focus));
	else
	    visualAngle = 2 * atan(24 / (2 * focus));

	double addAngle = (visualAngle / 2) * percent;
        
    if (fabs(rotAngle) > visualAngle / 2)
	{
		if (fabs(rotAngle) <= visualAngle / 2 + addAngle)
			return ((visualAngle / 2 + rotAngle) / visualAngle) * length; 
		else
			return -1000;
	}
    else
        return ((visualAngle / 2 + rotAngle) / visualAngle) * length;
    
}


/// <param name="focus">手机摄像头等效焦距，单位为毫米(mm)，例如iPhone5s的等效焦距为30 mm，iPhone6和iPhone6Plus的等效焦距为29 mm</param>
/// <param name="distance">物体与手机的垂直距离，单位为米(m)</param>
/// <param name="objectHeight">物体海拔高度，单位为米(m)</param>
/// <param name="horLabel">手机横向放置时为1，手机竖向放置时为0</param>
/// <param name="maxPercent">设定占比最大限制值</param>
/// <returns>返回0时，表示物体不在手机的视角范围</returns>
- (double)getPercentByFocus:(double)focus Distance:(double)distance ObjectHeight:(double)objectHeight horLabel:(double)horLabel maxPercent:(double)maxPercent
{   
	if (distance < 1)
		distance = 1; 

    double visualAngle = 0;

	double visualHeight = 0;
    
    if (horLabel == 1)   //手机横向放置时
        visualAngle = 2 * atan(24 / (2 * focus));
	else
	    visualAngle = 2 * atan(36 / (2 * focus));

	visualHeight = 2 * distance * tan(visualAngle / 2);
        
	if (objectHeight >= visualHeight)
        return maxPercent;
    else
        return (objectHeight / visualHeight) * maxPercent;    
		    
}


@end
