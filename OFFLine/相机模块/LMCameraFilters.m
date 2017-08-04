//
//  LMCameraFilters.m
//  GPUImageDemo
//
//  Created by xx11dragon on 15/9/22.
//  Copyright © 2015年 xx11dragon. All rights reserved.
//

#import "LMCameraFilters.h"
#import "LMFliterGroup.h"

@implementation LMCameraFilters

+ (GPUImageFilterGroup *)normal {
    GPUImageFilter *filter = [[GPUImageFilter alloc] init]; //默认
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"正常";
    group.color = [UIColor blackColor];
    return group;
}

+ (GPUImageFilterGroup *)saturation {
    GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter.saturation = 2.0f;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"饱和度";
    group.color = [UIColor blueColor];
    return group;
}


+ (GPUImageFilterGroup *)exposure {
    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc] init]; //曝光
    filter.exposure = 1.0f;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"曝光";
    group.color = [UIColor greenColor];
    return group;
}



+ (GPUImageFilterGroup *)contrast {
    GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init]; //对比度
    filter.contrast = 2.0f;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"对比度";
    group.color = [UIColor redColor];
    return group;
}


+ (GPUImageFilterGroup *)grayScale
{
    GPUImageGrayscaleFilter * filter = [[GPUImageGrayscaleFilter alloc] init];//灰度
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"灰度";
    group.color = [UIColor grayColor];
    return group;
}

+ (GPUImageFilterGroup *)testGroup1 {
    GPUImageFilterGroup *filters = [[GPUImageFilterGroup alloc] init];//正常
    
    GPUImageExposureFilter *filter1 = [[GPUImageExposureFilter alloc] init]; //曝光
    filter1.exposure = 0.0f;
    GPUImageSaturationFilter *filter2 = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter2.saturation = 2.0f;
    GPUImageContrastFilter *filter3 = [[GPUImageContrastFilter alloc] init]; //对比度
    filter3.contrast = 2.0f;
    
    [filter1 addTarget:filter2];
    [filter2 addTarget:filter3];
    
    [(GPUImageFilterGroup *) filters setInitialFilters:[NSArray arrayWithObject: filter1]];
    [(GPUImageFilterGroup *) filters setTerminalFilter:filter3];
    filters.title = @"组合";
    filters.color = [UIColor yellowColor];
    return filters;
}

+ (GPUImageFilterGroup *)sepia
{
    GPUImageSepiaFilter * filter = [[GPUImageSepiaFilter alloc] init];//褐色
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"褐色";
    group.color = [UIColor grayColor];
    return group;
}

+ (GPUImageFilterGroup *)falseColor
{
    GPUImageFalseColorFilter * filter = [[GPUImageFalseColorFilter alloc] init];//色彩替换（替换亮部和暗部色彩）
    filter.firstColor = (GPUVector4){0.0f, 0.0f, 0.5f, 1.0f};
    filter.secondColor = (GPUVector4){1.0f, 0.0f, 0.0f, 1.0f};;
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"色彩替换";
    group.color = [UIColor grayColor];
    return group;
}

+ (GPUImageFilterGroup *)luminosity
{
    GPUImageLuminosity * filter = [[GPUImageLuminosity alloc] init];//亮度平均
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"亮度平均";
    group.color = [UIColor grayColor];
    return group;
}

+ (GPUImageFilterGroup *)averageLuminance
{
    GPUImageAverageLuminanceThresholdFilter * filter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];//像素色值亮度平均，图像黑白（有类似漫画效果）
    filter.thresholdMultiplier = 1.0;//
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"像素色值亮度平均,黑白";
    group.color = [UIColor grayColor];
    return group;
}

+ (GPUImageFilterGroup *)sketch
{
    GPUImageSketchFilter * filter = [[GPUImageSketchFilter alloc] init];//素描
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"素描";
    group.color = [UIColor grayColor];
    return group;
}

+ (GPUImageFilterGroup *)toon//
{
    GPUImageToonFilter * filter = [[GPUImageToonFilter alloc] init];//卡通效果（黑色粗线描边）
    filter.threshold = 0.2;
    filter.quantizationLevels = 10.0;
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"卡通效果";
    group.color = [UIColor grayColor];
    return group;
}

+ (GPUImageFilterGroup *)smoothToon//
{
    GPUImageSmoothToonFilter * filter = [[GPUImageSmoothToonFilter alloc] init];//效果更细腻的卡通
    filter.threshold = 0.2;
    filter.blurRadiusInPixels = 2.0;
    filter.quantizationLevels = 10.0;
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"细腻的卡通";
    group.color = [UIColor grayColor];
    return group;
}

+ (GPUImageFilterGroup *)emboss
{
    GPUImageEmbossFilter * filter = [[GPUImageEmbossFilter alloc] init];//浮雕效果
    filter.intensity = 1.0;//0 ~ 4.0
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"浮雕效果";
    group.color = [UIColor grayColor];
    return group;
}

+ (GPUImageFilterGroup *)polkaDot//像素圆点花样
{
    GPUImagePolkaDotFilter * filter = [[GPUImagePolkaDotFilter alloc] init];
    GPUImageFilterGroup * group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *)group setInitialFilters:[NSArray arrayWithObject:filter]];
    [(GPUImageFilterGroup *)group setTerminalFilter:filter];
    group.title = @"像素圆点花样";
    group.color = [UIColor grayColor];
    return group;
    
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com