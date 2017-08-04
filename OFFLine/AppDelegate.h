//
//  AppDelegate.h
//  OFFLine
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>


@property (strong, nonatomic) UIWindow *window;
/**
 *  是否强制横屏
 */
@property  BOOL isForceLandscape;
/**
 *  是否强制竖屏
 */
@property  BOOL isForcePortrait;

@end

