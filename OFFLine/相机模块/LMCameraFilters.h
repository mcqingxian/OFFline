//
//  LMCameraFilters.h
//  GPUImageDemo
//
//  Created by xx11dragon on 15/9/22.
//  Copyright © 2015年 xx11dragon. All rights reserved.
//

#import "GPUImage.h"

@interface LMCameraFilters : NSObject

+ (GPUImageFilterGroup *)normal;//正常

+ (GPUImageFilterGroup *)saturation;//饱和度

+ (GPUImageFilterGroup *)exposure;//曝光

+ (GPUImageFilterGroup *)contrast;//对比度

+ (GPUImageFilterGroup *)testGroup1;//组合

+ (GPUImageFilterGroup *)grayScale;//灰度

+ (GPUImageFilterGroup *)sepia;//褐色(怀旧)

+ (GPUImageFilterGroup *)falseColor;//色彩替换（替换亮部和暗部色彩）

+ (GPUImageFilterGroup *)luminosity;//亮度平均

+ (GPUImageFilterGroup *)averageLuminance;//像素色值亮度平均，图像黑白（有类似漫画效果）

+ (GPUImageFilterGroup *)sketch;//素描

+ (GPUImageFilterGroup *)toon;//卡通效果（黑色粗线描边）

+ (GPUImageFilterGroup *)smoothToon;//相比上面的效果更细腻，上面是粗旷的画风

+ (GPUImageFilterGroup *)emboss;//浮雕效果，带有点3d的感觉

+ (GPUImageFilterGroup *)polkaDot;//像素圆点花样

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com