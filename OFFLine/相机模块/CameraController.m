//
//  CameraController.m
//  MyUnityOniOS
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "CameraController.h"
#import "LMCameraManager.h"
#import "LMCameraFilters.h"
#import "GPUImage.h"
#import <CoreMotion/CoreMotion.h>//陀螺仪头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "AppDelegate.h"
#import "Calculation.h"

@interface CameraController ()<UIGestureRecognizerDelegate, BMKLocationServiceDelegate>

{
GPUImageStillCamera *videoCamera;
GPUImageView *view1;
}

//    滤镜数组
@property (nonatomic , strong) NSArray *filters;

//    选择效果视图
@property (nonatomic , strong) LMCameraManager *cameraManager;

//    摄像头位置按钮
@property (nonatomic , strong) UIButton *cameraPostionButton;

@property(nonatomic,assign)CGFloat beginGestureScale;//记录开始的缩放比例
@property(nonatomic,assign)CGFloat effectiveScale;//最后的缩放比例

@property (nonatomic, strong)BMKUserLocation * userLocation;//手机所在位置
@property (nonatomic, strong)CMMotionManager * manager;//陀螺仪
@property (nonatomic, assign)CGFloat angle1;//手机与正北方向角度
@property (nonatomic, assign)CGFloat targetAngle1;//目标1与正北方向的角度
@property (nonatomic, assign)CGFloat targetAngle2;//目标1与正北方向的角度
@property (nonatomic, assign)CGFloat targetAngle3;//目标1与正北方向的角度

@property (nonatomic, assign)double myAltitude;//手机海拔高度
@property (nonatomic, strong)UIImageView * targetImageView1;//目标图片1
@property (nonatomic, strong)UIImageView * targetImageView2;//目标图片2
@property (nonatomic, strong)UIImageView * targetImageView3;//目标图片3
@property (nonatomic, strong)UIImageView * imageView;//瞄准器
@property (nonatomic, strong)UILabel * leftLab;//水平角度
@property (nonatomic, strong)UILabel * rightLab;//垂直角度
@property (nonatomic, strong)UILabel * timeLab;//时间窗
@property (nonatomic, strong)BMKLocationService * locService;

@property (nonatomic, strong)UIImageView * bgImagview;//背景图
@property (nonatomic, strong)NSTimer * timer;//计时器,用于时间的刷新
@property (nonatomic, strong)NSTimer * filterTimer;//切换两种filter的计时器,每0.2秒执行一次
@property (nonatomic, assign)BOOL isFilter;//用于区分两种不同的filter
@property (nonatomic, assign)double ObjectScreenHeight1;//物体1在屏幕中的高度
@property (nonatomic, assign)double ObjectScreenHeight2;//物体2在屏幕中的高度
@property (nonatomic, assign)double ObjectScreenHeight3;//物体3在屏幕中的高度
@property (nonatomic, assign)double ObjectSpaceH1;//物体1在屏幕中的Y值
@property (nonatomic, assign)double ObjectSpaceH2;//物体2在屏幕中的Y值
@property (nonatomic, assign)double ObjectSpaceH3;//物体3在屏幕中的Y值
@property (nonatomic, assign)double myX;
@property (nonatomic, assign)double myY;
@property (nonatomic, assign)double myPercent;

@end

@implementation CameraController

//视图已经消失后,停止相机活动
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self.cameraManager stopCamera];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.isFilter = NO;
    
    [self.cameraManager startCamera];
    [self.cameraManager setFilterAtIndex:0];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    //进入地图开始显示自己的坐标
    [_locService startUserLocationService];
    
    [self createSubviews];
    
    
}

- (void)createSubviews
{
    self.view.transform=CGAffineTransformIdentity;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.cameraPostionButton];//切换摄像头按钮
    
    self.bgImagview = [UIImageView imageViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.height, [UIScreen mainScreen].applicationFrame.size.width) backgroundColor:nil image:[UIImage imageNamed:@"摄像头背景.png"]];
    _bgImagview.userInteractionEnabled = YES;
    [self.view addSubview:_bgImagview];
    
    //切换上一页按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, [UIScreen mainScreen].applicationFrame.size.width - 90, 70, 70);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backToParentView) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"切换.png"] forState:UIControlStateNormal];
    [_bgImagview addSubview:backBtn];
    
    //目标图片
    self.targetImageView1 = [UIImageView imageViewWithFrame:CGRectMake(50, 50, 200, 200) backgroundColor:nil image:[UIImage imageNamed:@"a.png"]];
    [self.view addSubview:_targetImageView1];
    [self.view sendSubviewToBack:_targetImageView1];
    
//    self.targetImageView2 = [UIImageView imageViewWithFrame:CGRectMake(50, 50, 200, 200) backgroundColor:nil image:[UIImage imageNamed:@"b.jpg"]];
//    [self.view addSubview:_targetImageView2];
//    [self.view sendSubviewToBack:_targetImageView2];
//    
//    self.targetImageView3 = [UIImageView imageViewWithFrame:CGRectMake(50, 50, 200, 200) backgroundColor:nil image:[UIImage imageNamed:@"c.jpg"]];
//    [self.view addSubview:_targetImageView3];
//    [self.view sendSubviewToBack:_targetImageView3];
    
    //左侧 角度显示
    self.leftLab = [UILabel labelWithFrame:CGRectMake([UIApplication sharedApplication].keyWindow.frame.size.height / 2.0 - 100, [UIApplication sharedApplication].keyWindow.frame.size.width / 2.0 - 20, 50, 40) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter textColor:[UIColor blackColor] fontSize:17.0];
    [_bgImagview addSubview:_leftLab];
    
    //右侧 角度显示
    self.rightLab = [UILabel labelWithFrame:CGRectMake(70 + [UIApplication sharedApplication].keyWindow.frame.size.height / 2.0, [UIApplication sharedApplication].keyWindow.frame.size.width / 2.0 - 20, 50, 40) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter textColor:[UIColor blackColor] fontSize:17.0];
    [_bgImagview addSubview:_rightLab];
    
    //时间窗
    self.timeLab = [UILabel labelWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.height / 2.0 - 40, 0, 80, 40) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] fontSize:17.0];
    [_bgImagview addSubview:_timeLab];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    _timeLab.text = currentDateStr;
   
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeCurrentTime) userInfo:nil repeats:YES];//每秒钟调用一次方法
    
    //单独button,用于临时切换相机画面
    UIButton * anotherBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(50, 50, 80, 50) tittle:@"" backgroundColor:[UIColor yellowColor] target:self action:@selector(changeCameraFilter)];
    [_bgImagview addSubview:anotherBtn];
    
    self.filterTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeCameraFilter) userInfo:nil repeats:YES];

    //添加捏合手势
//    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
//    [self.view addGestureRecognizer:pinch];
    
    self.manager = [[CMMotionManager alloc] init];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    //    self.manager.gyroUpdateInterval = 0.1; // 告诉manager，更新频率是10Hz
    if (self.manager.deviceMotionAvailable) {
        self.manager.deviceMotionUpdateInterval = 0.2;
        [self.manager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (error) {
                [self.manager stopDeviceMotionUpdates];
                NSLog(@"CMDeviceMotion encountered error: %@",error);
            }else{
                //Gravity 获取手机的重力值在各个方向上的分量，根据这个就可以获得手机的空间位置，倾斜角度等
                double gravityX = motion.gravity.x;
                double gravityY = motion.gravity.y;
                double gravityZ = motion.gravity.z;
                //获取手机的倾斜角度：
                double angle = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
                _rightLab.text = [NSString stringWithFormat:@"%.f", angle];
                
                //调用方法,实时改变目标在屏幕中的位置
                [self changePosition:500 distance:1000 zTheta:angle];//物体1实际高度500米, 距离目标实际距离1000米
                [self changePosition2:500 distance:2000 zTheta:angle];//物体2实际高度500米, 距离目标实际距离2000米
                [self changePosition3:500 distance:3000 zTheta:angle];//物体3实际高度500米, 距离目标实际距离3000米
                
             }
        }];
    }
}

#pragma mark - 手机倾斜后更新变化
//height物体实际高度 distance距离目标实际距离 zTheta手机倾斜角度
- (void)changePosition:(double)height distance:(double)distance zTheta:(double)angle
{
    //根据手机上下倾斜角度,计算目标在屏幕中的位置
    double a = (angle + 25) / 180.0 * M_PI;//
    double b = (25 - angle) / 180.0 * M_PI;//
    double totalHeight = (tan(a) + tan(b)) * distance;//视线实际总高度
    double height1 = height * [UIScreen mainScreen].applicationFrame.size.height / totalHeight;//物体屏幕像素高度
    
    double h1 = self.myAltitude;//手机海拔高度
    double h2 = tan(b) * distance - h1;//地下高度
    double scale = [UIScreen mainScreen].applicationFrame.size.height / totalHeight;//缩放比例
    double y = (totalHeight - h2 - height - 100) * scale;
//    NSLog(@"+++++++%f, %f, %f, %f, %f, %f",a,b, y, totalHeight, scale, [UIScreen mainScreen].applicationFrame.size.height);
    self.ObjectScreenHeight1 = height1;
    self.ObjectSpaceH1 = y;
    
    float f = (self.targetAngle1 - self.angle1 + 30 ) / 60;
    //显示图片
    [self.view bringSubviewToFront:_targetImageView1];
//    [_targetImageView1 setFrame:CGRectMake(f * self.view.frame.size.width - 200 / 2.0, self.ObjectSpaceH1, self.ObjectScreenHeight1, self.ObjectScreenHeight1)];
    
    Calculation * calculation = [Calculation defaultCalculation];
    double percent = [calculation getPercentByFocus:29 Distance:distance ObjectHeight:height horLabel:1 maxPercent:0.5];
    double y1 = [calculation getYCoordinateByLength:self.view.frame.size.height Width:self.view.frame.size.width Focus:29 Distance:distance PhoneHeight:h1 ObjectHeight:height Angle:angle Percent:percent HorLabel:1];//根据手机倾斜度计算
    self.myY = y1;
    self.myPercent = percent;
    [_targetImageView1 setFrame:CGRectMake(self.myX, self.myY, self.view.frame.size.width * self.myPercent, self.view.frame.size.width * self.myPercent)];
}

- (void)changePosition2:(double)height distance:(double)distance zTheta:(double)zTheta
{
    //根据手机上下倾斜角度,计算目标在屏幕中的位置
    double a = (zTheta + 25) / 180.0 * M_PI;//
    double b = (25 - zTheta) / 180.0 * M_PI;//
    double totalHeight = (tan(a) + tan(b)) * distance;//视线实际总高度
    double height1 = height * [UIScreen mainScreen].applicationFrame.size.height / totalHeight;//物体屏幕像素高度
    
    double h1 = self.myAltitude;//手机海拔高度
    double h2 = tan(b) * distance - h1;//地下高度
    double scale = [UIScreen mainScreen].applicationFrame.size.height / totalHeight;//缩放比例
    double y = (totalHeight - h2 - height - 100) * scale;
    //    NSLog(@"+++++++%f, %f, %f, %f, %f, %f",a,b, y, totalHeight, scale, [UIScreen mainScreen].applicationFrame.size.height);
    self.ObjectScreenHeight2 = height1;
    self.ObjectSpaceH2 = y;
    
    float f = (self.targetAngle2 - self.angle1 + 30 ) / 60;
    //显示图片
    [self.view bringSubviewToFront:_targetImageView2];
    [_targetImageView2 setFrame:CGRectMake(f * self.view.frame.size.width - 200 / 2.0, self.ObjectSpaceH2, self.ObjectScreenHeight2, self.ObjectScreenHeight2)];
}


- (void)changePosition3:(double)height distance:(double)distance zTheta:(double)zTheta
{
    //根据手机上下倾斜角度,计算目标在屏幕中的位置
    double a = (zTheta + 25) / 180.0 * M_PI;//
    double b = (25 - zTheta) / 180.0 * M_PI;//
    double totalHeight = (tan(a) + tan(b)) * distance;//视线实际总高度
    double height1 = height * [UIScreen mainScreen].applicationFrame.size.height / totalHeight;//物体屏幕像素高度
    
    double h1 = self.myAltitude;//手机海拔高度
    double h2 = tan(b) * distance - h1;//地下高度
    double scale = [UIScreen mainScreen].applicationFrame.size.height / totalHeight;//缩放比例
    double y = (totalHeight - h2 - height - 100) * scale;
    //    NSLog(@"+++++++%f, %f, %f, %f, %f, %f",a,b, y, totalHeight, scale, [UIScreen mainScreen].applicationFrame.size.height);
    self.ObjectScreenHeight3 = height1;
    self.ObjectSpaceH3 = y;
    
    float f = (self.targetAngle3 - self.angle1 + 30 ) / 60;
    //显示图片
    [self.view bringSubviewToFront:_targetImageView3];
    [_targetImageView3 setFrame:CGRectMake(f * self.view.frame.size.width - 200 / 2.0, self.ObjectSpaceH3, self.ObjectScreenHeight3, self.ObjectScreenHeight3)];
}

#pragma mark - 水平方向更新
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    self.myAltitude = userLocation.location.altitude;//海拔高度赋值
    self.userLocation = userLocation;
//    NSLog(@"%f, %f", userLocation.location.coordinate.longitude, userLocation.location.coordinate.latitude);
    CLHeading *newHeading = userLocation.heading;
    // 1.判断当前的角度是否有效(如果此值小于0,代表角度无效)
    if(newHeading.headingAccuracy < 0)
        return;
    
    // 2.获取当前设备朝向(磁北方向)
    CGFloat angle = newHeading.magneticHeading;
//    NSLog(@"磁北方向角度:%f", angle);
    if (angle <= 270) {
        self.angle1 = angle + 90;//手机角度,因为向右横屏,所以+90度
    }else {
        self.angle1 = angle - 270;//
    }
    
    _leftLab.text = [NSString stringWithFormat:@"%.f", self.angle1];
    
    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(31.198807, 121.26693);//设置一个目标坐标1
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(31.197255,121.265556);//设置一个目标坐标2
    CLLocationCoordinate2D coordinate3 = CLLocationCoordinate2DMake(31.185543, 121.272992);//设置一个目标坐标3
    [self changeHorizontalPosition:coordinate1 userLocation:userLocation];//当达到对应角度时显示目标图像
    [self changeHorizontalPosition2:coordinate2 userLocation:userLocation];//当达到对应角度时显示目标图像
    [self changeHorizontalPosition3:coordinate3 userLocation:userLocation];//当达到对应角度时显示目标图像
    
}

//水平方向位置变化
- (void)changeHorizontalPosition:(CLLocationCoordinate2D)coordinate userLocation:(BMKUserLocation *)userLocation
{
    double a = coordinate.latitude - userLocation.location.coordinate.latitude;
    double b = coordinate.longitude - userLocation.location.coordinate.longitude;
    double m = atan(a/b);
    if (a >= 0 && b >= 0) {
        self.targetAngle1 = m / M_PI * 180;
    }else if (a>= 0 && b< 0){
        self.targetAngle1 = m / M_PI * 180 + 360;
    }else if (a<0 && b <0){
        self.targetAngle1 = m / M_PI * 180 + 180;
    }else{
        self.targetAngle1 = m / M_PI * 180 + 180;//目标角度
    }
    float f = (self.targetAngle1 - self.angle1 + 30 ) / 60;//该值等于0.5时,目标正好位于手机正前方
    if(!_targetImageView1){
        _targetImageView1 = [[UIImageView alloc] init];
        _targetImageView1.image = [UIImage imageNamed:@"a.png"];
    }
    //当达到对应角度时,显示目标图像
    [_targetImageView1 setFrame:CGRectMake(f * self.view.frame.size.width - 200 / 2.0, self.ObjectSpaceH1, self.ObjectScreenHeight1, self.ObjectScreenHeight1)];
    [self.view bringSubviewToFront:_targetImageView1];
    
//    NSLog(@"####%f", self.angle1);
    if (self.angle1 > 180) {
        self.angle1 = self.angle1  - 360;
    }
//    NSLog(@"****%f", self.angle1);
    Calculation * calculation = [Calculation defaultCalculation];
    double x = [calculation getXCoordinateByLength:self.view.frame.size.height Width:self.view.frame.size.width Focus:29 Angle:self.angle1 ObjectX:121.26693 ObjectY:31.198807 PhoneX:self.userLocation.location.coordinate.longitude PhoneY:self.userLocation.location.coordinate.latitude Percent:self.myPercent HorLabel:1];//根据手机方位计算(手机与物体夹角)
    NSLog(@"%f, %f, %f, %f, %f, %f, %f, %f",self.myX, self.myY, self.view.frame.size.width * self.myPercent, self.angle1, 121.26693, 31.198807, self.userLocation.location.coordinate.longitude, self.userLocation.location.coordinate.latitude);

    self.myX = x;
    [_targetImageView1 setFrame:CGRectMake(self.myX, self.myY, self.view.frame.size.width * self.myPercent, self.view.frame.size.width * self.myPercent)];


}

- (void)changeHorizontalPosition2:(CLLocationCoordinate2D)coordinate userLocation:(BMKUserLocation *)userLocation
{
    double a = coordinate.latitude - userLocation.location.coordinate.latitude;
    double b = coordinate.longitude - userLocation.location.coordinate.longitude;
    double m = atan(a/b);
    if (a >= 0 && b >= 0) {
        self.targetAngle2 = m / M_PI * 180;
    }else if (a>= 0 && b< 0){
        self.targetAngle2 = m / M_PI * 180 + 360;
    }else if (a<0 && b <0){
        self.targetAngle2 = m / M_PI * 180 + 180;
    }else{
        self.targetAngle2 = m / M_PI * 180 + 180;//目标角度
    }
    float f = (self.targetAngle2 - self.angle1 + 30 ) / 60;//该值等于0.5时,目标正好位于手机正前方
    if(!_targetImageView2){
        _targetImageView2 = [[UIImageView alloc] init];
        _targetImageView2.image = [UIImage imageNamed:@"b.jpg"];
    }
    //当达到对应角度时,显示目标图像
    [_targetImageView2 setFrame:CGRectMake(f * self.view.frame.size.width - 200 / 2.0, self.ObjectSpaceH2, self.ObjectScreenHeight2, self.ObjectScreenHeight2)];
    [self.view bringSubviewToFront:_targetImageView2];
    
}

- (void)changeHorizontalPosition3:(CLLocationCoordinate2D)coordinate userLocation:(BMKUserLocation *)userLocation
{
    double a = coordinate.latitude - userLocation.location.coordinate.latitude;
    double b = coordinate.longitude - userLocation.location.coordinate.longitude;
    double m = atan(a/b);
    if (a >= 0 && b >= 0) {
        self.targetAngle3 = m / M_PI * 180;
    }else if (a>= 0 && b< 0){
        self.targetAngle3 = m / M_PI * 180 + 360;
    }else if (a<0 && b <0){
        self.targetAngle3 = m / M_PI * 180 + 180;
    }else{
        self.targetAngle3 = m / M_PI * 180 + 180;//目标角度
    }
    float f = (self.targetAngle3 - self.angle1 + 30 ) / 60;//该值等于0.5时,目标正好位于手机正前方
    if(!_targetImageView3){
        _targetImageView3 = [[UIImageView alloc] init];
        _targetImageView3.image = [UIImage imageNamed:@"c.jpg"];
    }
    //当达到对应角度时,显示目标图像
    [_targetImageView3 setFrame:CGRectMake(f * self.view.frame.size.width - 200 / 2.0, self.ObjectSpaceH3, self.ObjectScreenHeight3, self.ObjectScreenHeight3)];
    [self.view bringSubviewToFront:_targetImageView3];
    
}

#pragma mark - buttonAction
int a = 0;
- (void)changeCameraFilter
{
    if (a < 10) {
        //每0.2秒互换一次
        if (_isFilter == NO) {
            [self.cameraManager setFilterAtIndex:1];
            _isFilter = YES;
        }else{
            [self.cameraManager setFilterAtIndex:0];
            _isFilter = NO;
        }
        a++;
    }else{
        [self.cameraManager setFilterAtIndex:0];
        [self.filterTimer invalidate];
        self.filterTimer = nil;
        a = 0;
    }
    
}

//实时刷新时间窗
- (void)changeCurrentTime
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    _timeLab.text = currentDateStr;
}

//返回上一页
- (void)backToParentView
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    [self.manager stopDeviceMotionUpdates];
}

//缩放手势 用于调整焦距
//- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
//    
//    BOOL allTouchesAreOnThePreviewLayer = YES;
//    NSUInteger numTouches = [recognizer numberOfTouches], i;
//    NSLog(@"i = %ld", i);
//    for ( i = 0; i < numTouches; ++i ) {
//        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
//        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
//        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
//            allTouchesAreOnThePreviewLayer = NO;
//            break;
//        }
//    }
//    
//    if (allTouchesAreOnThePreviewLayer) {
//        
//        self.effectiveScale = self.beginGestureScale * recognizer.scale;
//        if (self.effectiveScale < 1.0){
//            self.effectiveScale = 1.0;
//        }
//        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
//        
//        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
//        
//        NSLog(@"%f",maxScaleAndCropFactor);
//        if (self.effectiveScale > maxScaleAndCropFactor)
//            self.effectiveScale = maxScaleAndCropFactor;
//        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:.025];
//        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
//        [CATransaction commit];
//        
//    }
//    
//}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark 滤镜组
- (NSArray *)filters
{
    if (!_filters) {
        GPUImageFilterGroup * f1 = [LMCameraFilters sketch];
        [videoCamera addTarget:f1];
        
//        GPUImageFilterGroup * f2 = [LMCameraFilters polkaDot];
//        [videoCamera addTarget:f2];
        GPUImageFilterGroup * f2 = [LMCameraFilters normal];
        [videoCamera addTarget:f2];
        
        NSArray *arr = [NSArray arrayWithObjects:f1,f2,nil];
        _filters = arr;
    }
    return _filters;
}

#pragma mark 相机管理器
- (LMCameraManager *)cameraManager {
    if (!_cameraManager) {
        CGRect rect;
        rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        LMCameraManager *cameraManager = [[LMCameraManager alloc] initWithFrame:rect superview:self.view];
        [cameraManager addFilters:self.filters];
        [cameraManager setfocusImage:[UIImage imageNamed:@"touch_focus_x"]];
        _cameraManager = cameraManager;
    }
    return _cameraManager;
}

#pragma mark 前后摄像头切换按钮
- (UIButton *)cameraPostionButton {
    if (!_cameraPostionButton) {
        float width = 32.0f;
        float height = 24.0f;
        float x = [UIScreen mainScreen].applicationFrame.size.height - 50;
        float y = 20;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 3;
        [button setImage:[UIImage imageNamed:@"相机切换1.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(x, y, width, height);
        
        [button addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
        _cameraPostionButton = button;
    }
    return _cameraPostionButton;
}

#pragma mark 按钮点击选择摄像头
- (void)selectedButton:(UIButton *)button {
    [self changeCameraPostion];
}

#pragma mark 改变摄像头位置
- (void)changeCameraPostion {
    if (self.cameraManager.position == LMCameraManagerDevicePositionBack)
        self.cameraManager.position = LMCameraManagerDevicePositionFront;
    else
        self.cameraManager.position = LMCameraManagerDevicePositionBack;
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma  mark 横屏设置
/**
 *  强制横屏
 */
-(void)forceOrientationLandscape{
    //这种方法，只能旋转屏幕不能达到强制横屏的效果
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    //加上代理类里的方法，旋转屏幕可以达到强制横屏的效果
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    
}

/**
 *  页面消失需要释放强制约束
*/
-(void)viewWillDisappear:(BOOL)animated{
    //释放约束
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;//竖屏模式保留
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //退出界面前恢复竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [self forceOrientationLandscape]; //设置横屏
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
