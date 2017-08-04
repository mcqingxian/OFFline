//
//  CameraTypeController.m
//  MyUnityOniOS
//
//  Created by Oneprime on 16/7/26.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "CameraTypeController.h"
#import <AVFoundation/AVFoundation.h>//相机头文件
#import <AssetsLibrary/AssetsLibrary.h>//相册需要
#import <CoreMotion/CoreMotion.h>//陀螺仪头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface CameraTypeController ()<UIGestureRecognizerDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) AVCaptureSession* session;//控制输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;//输入设备, 例如摄像头和麦克风
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;//照片输出流,用于输出图像
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;//镜头捕捉到得预览图层
@property (nonatomic, assign) BOOL isUsingFrontFacingCamera;// 是前摄像头

@property(nonatomic,assign)CGFloat beginGestureScale;//记录开始的缩放比例
@property(nonatomic,assign)CGFloat effectiveScale;//最后的缩放比例

@property (nonatomic, strong)CMMotionManager * manager;//陀螺仪
@property (nonatomic, assign)CGFloat angle1;//手机与正北方向角度
@property (nonatomic, assign)CGFloat angle2;//目标与正北方向的角度

@property (nonatomic, strong)UIImageView * targetImageView;//目标图片
@property (nonatomic, strong)UIImageView * imageView;//瞄准器
@property (nonatomic, strong)UILabel * leftLab;//水平角度
@property (nonatomic, strong)UILabel * rightLab;//垂直角度
@property (nonatomic, strong)BMKLocationService * locService;
@property (nonatomic, strong)UIImageView * bgImagview;//背景图

@end

@implementation CameraTypeController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bgImagview = [UIImageView imageViewWithFrame:self.view.frame backgroundColor:nil image:[UIImage imageNamed:@"摄像头背景.png"]];
    [self.view addSubview:_bgImagview];
    
     _targetImageView = [UIImageView imageViewWithFrame:CGRectMake(50, 50, 200, 200) backgroundColor:nil image:[UIImage imageNamed:@"a.png"]];
    [self.view addSubview:_targetImageView];
    [self.view sendSubviewToBack:_targetImageView];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    //进入地图开始显示自己的坐标
    [_locService startUserLocationService];
    
    [self initAVCaptureSession];
    
    _imageView = [UIImageView imageViewWithFrame:CGRectMake(50, 50, 300, 110) backgroundColor:nil image:[UIImage imageNamed:@"准星带角度.png"]];
    _imageView.center = self.view.center;
    [_bgImagview addSubview:_imageView];
    [_bgImagview bringSubviewToFront:_imageView];
    
    _leftLab = [UILabel labelWithFrame:CGRectMake(70, 320, 50, 40) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] fontSize:17.0];
    [_bgImagview addSubview:_leftLab];
    
    _rightLab = [UILabel labelWithFrame:CGRectMake(70 + self.view.frame.size.width / 2.0, 320, 50, 40) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] fontSize:17.0];
    [_bgImagview addSubview:_rightLab];
    
}

//屏幕旋转会自动调用此方法
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    BOOL landscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation); //判断是不是横屏
    NSLog(@"++++%d", landscape);
}

#pragma mark - AVCapture

//初始化相机
- (void)initAVCaptureSession
{
    _isUsingFrontFacingCamera = NO;//前摄像头
    
    self.session = [[AVCaptureSession alloc] init];
    NSError *error;
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设备的时候必须先锁定设备,修改完再解锁,否则会崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];//解锁
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //输出设置, AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.previewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
    self.view.layer.masksToBounds = YES;
    [self.view.layer addSublayer:self.previewLayer];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, [UIScreen mainScreen].applicationFrame.size.height - 90, 70, 70);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backToParentView) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"切换.png"] forState:UIControlStateNormal];
    [_bgImagview addSubview:backBtn];
    
    //切换摄像头按钮
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 50, 20, 32, 24) backgroundImage:[UIImage imageNamed:@"相机切换1.png"] target:self action:@selector(switchCameraBtnClick)];
    [self.view addSubview:changeBtn];
    
    self.beginGestureScale = 1.0;
    self.effectiveScale = 1.0;
    //添加捏合手势
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer:pinch];
    
    self.manager = [[CMMotionManager alloc] init];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    //    self.manager.gyroUpdateInterval = 0.1; ; // 告诉manager，更新频率是10Hz
    if (self.manager.deviceMotionAvailable) {
        self.manager.deviceMotionUpdateInterval = 0.1;
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
                double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
                _rightLab.text = [NSString stringWithFormat:@"%.f", zTheta];
                
                if (zTheta >= -20.0 && zTheta <= 40.0) {
                    //显示图片
                    [self.view bringSubviewToFront:_targetImageView];

                }else{
                    //隐藏图片
                    [self.view sendSubviewToBack:_targetImageView];
                }
            }
        }];
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    CLHeading *newHeading = userLocation.heading;
    // 1.判断当前的角度是否有效(如果此值小于0,代表角度无效)
    if(newHeading.headingAccuracy < 0)
        return;
    
    // 2.获取当前设备朝向(磁北方向)
    CGFloat angle = newHeading.magneticHeading;
    //    NSLog(@"磁北方向角度:%f", angle);
    self.angle1 = angle;//手机角度
    _leftLab.text = [NSString stringWithFormat:@"%.f", self.angle1];
    // 121.269654,31.205921
    double a = 31.0 - userLocation.location.coordinate.latitude;
    double b = 121.5 - userLocation.location.coordinate.longitude;
    double m = atan(a/b);
    if (a >= 0 && b >= 0) {
        self.angle2 = m / M_PI * 180;
    }else if (a>= 0 && b< 0){
        self.angle2 = m / M_PI * 180 + 360;
    }else if (a<0 && b <0){
        self.angle2 = m / M_PI * 180 + 180;
    }else{
        self.angle2 = m / M_PI * 180 + 180;//目标角度
    }
    float f = (self.angle2 - self.angle1 + 30 ) / 60;//该值等于0.5时,目标正好位于手机正前方
    //    NSLog(@"%f", f);
    
    if(!_targetImageView){
        _targetImageView = [UIImageView imageViewWithFrame:CGRectMake(50, 50, 200, 200) backgroundColor:nil image:[UIImage imageNamed:@"tianshiYan.jpg"]];
    }
    if (f >= -0.3 && f <= 1.3) {
        [_targetImageView setFrame:CGRectMake(f * self.view.frame.size.width - 200 / 2.0, 220, 200, 200)];
        [self.view bringSubviewToFront:_targetImageView];
    }else{
        [self.view sendSubviewToBack:_targetImageView];
    }
    
}


//搞一个获取设备方向的方法，在配置图片输出的时候需要使用
-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

//切换镜头
- (void)switchCameraBtnClick
{
    AVCaptureDevicePosition desiredPosition;
    if (_isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    _isUsingFrontFacingCamera = !_isUsingFrontFacingCamera;
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    NSLog(@"i = %ld", i);
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if (allTouchesAreOnThePreviewLayer) {
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - buttonAction

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //强制横屏
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]){
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeRight;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }

    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if (self.session) {
        [self.session stopRunning];
    }
}

//返回上一页
- (void)backToParentView
{
    NSLog(@"返回");
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.manager stopDeviceMotionUpdates];
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
