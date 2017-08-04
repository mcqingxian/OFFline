//
//  MyController.m
//  OFFLine
//
//  Created by Apple on 16/8/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyController.h"
#import "LMCameraManager.h"
#import "LMCameraFilters.h"
#import "GPUImage.h"
@interface MyController ()
{
    GPUImageStillCamera *videoCamera;
    GPUImageView *view1;
}

//    滤镜数组
@property (nonatomic , strong) NSArray *filters;

//    选择效果视图
@property (nonatomic , strong) LMCameraManager *cameraManager;

@end

@implementation MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.cameraManager startCamera];
    [self.cameraManager setFilterAtIndex:0];
}

#pragma mark 滤镜组
- (NSArray *)filters
{
    if (!_filters) {
        GPUImageFilterGroup * f1 = [LMCameraFilters sketch];
        [videoCamera addTarget:f1];
        NSArray *arr = [NSArray arrayWithObjects:f1,nil];
        _filters = arr;
    }
    return _filters;
}

#pragma mark 相机管理器
- (LMCameraManager *)cameraManager {
    if (!_cameraManager) {
        CGRect rect;
        rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        LMCameraManager *cameraManager = [[LMCameraManager alloc] initWithFrame:rect superview:self.view];
        [cameraManager addFilters:self.filters];
        [cameraManager setfocusImage:[UIImage imageNamed:@"touch_focus_x"]];
        _cameraManager = cameraManager;
        _cameraManager.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        self.cameraManager.position = LMCameraManagerDevicePositionBack;
    }
    return _cameraManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
