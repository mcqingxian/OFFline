//
//  HomeController.m
//  MyUnityOniOS
//
//  Created by Oneprime on 16/7/19.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "HomeController.h"
#import "AppDelegate.h"
#import "DutyController.h"
#import "CameraTypeController.h"
#import "CameraController.h"
#import "StartChipController.h"
#import "Chip.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <CoreMotion/CoreMotion.h>//陀螺仪头文件
#import <AudioToolbox/AudioToolbox.h> //声音提示

#define SOUNDID 1306 //系统声音id

#define H_Space 20
#define H_Icon_Width 50
#define H_Lab_Width 80
#define H_Lab_height 15
@interface HomeController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)BMKMapView * mapView;
@property (nonatomic, strong)BMKLocationService * locService;
@property (nonatomic, strong)BMKUserLocation * userLocation;
@property (nonatomic, strong)BMKPoiSearch * searcher;
@property (nonatomic, assign)CLLocationCoordinate2D myCoordinate;
@property (nonatomic, strong)NSString * name;

@property (nonatomic, strong)CMMotionManager * manager;//陀螺仪
@property (nonatomic, assign)CGFloat angle1;//手机与正北方向角度
@property (nonatomic, assign)CGFloat angle2;//目标与正北方向的角度

@property (nonatomic, strong)UIImageView * iconImageView;//用户头像
@property (nonatomic, strong)UILabel * userNameLab;//用户名称
@property (nonatomic, strong)UIImageView * strengthImageView;//体力
@property (nonatomic, strong)UIImageView * goldImageView;//金币

@property (nonatomic, strong)UIImageView * targetImageView;//目标图片
@property (nonatomic, strong)NSMutableArray * chipArray;//碎片数组

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self configueMapView];

    [self createSubViews];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(backToMyPosition) userInfo:nil repeats:NO];
}

- (void)backToMyPosition
{
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(_myCoordinate.latitude , _myCoordinate.longitude);
}

- (void)createSubViews
{
    _iconImageView = [UIImageView imageViewWithFrame:CGRectMake(H_Space, H_Space, H_Icon_Width, H_Icon_Width) backgroundColor:[UIColor yellowColor] image:[UIImage imageNamed:@"头像.png"]];
    [_mapView addSubview:_iconImageView];
    
    _userNameLab = [UILabel labelWithFrame:CGRectMake(10 + _iconImageView.right, H_Space, H_Lab_Width + 50, H_Lab_height + 10) fontSize:20.0 textAlignment:NSTextAlignmentLeft text:self.userName];
    _userNameLab.textColor = [UIColor whiteColor];
    _userNameLab.font = [UIFont fontWithName:@"SF-UI-Display" size:24.0];
    [_mapView addSubview:_userNameLab];
    //体力值
    _strengthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - H_Lab_Width - H_Space, H_Space, H_Lab_Width, H_Lab_height)];
    _strengthImageView.image = [UIImage imageNamed:@"蓝条.png"];
    [_mapView addSubview:_strengthImageView];
    
    //金币值
    _goldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - H_Lab_Width - H_Space, _strengthImageView.bottom + 2.5, H_Lab_Width, H_Lab_height)];
    _goldImageView.image = [UIImage imageNamed:@"红条.png"];
    [_mapView addSubview:_goldImageView];
    
    //分数
    UILabel * markLab = [[UILabel alloc] initWithFrame:CGRectMake(_goldImageView.left, _goldImageView.bottom + 2.5, H_Lab_Width, H_Lab_height)];
//    markLab.backgroundColor = [UIColor whiteColor];
    markLab.text = @"OT 9999";
    markLab.font = [UIFont systemFontOfSize:14];
    markLab.textColor = [UIColor whiteColor];
    
    [_mapView addSubview:markLab];
    
}

//播放声音
-(void)playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sc2" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark - buttonAction
//扫描目标
-(void)searchDestination1
{
    //    AudioServicesPlaySystemSound(SOUNDID);//点击按钮时发出声音
    [self playSound];//播放声音
    [self loadChips];
}

//加载碎片
- (void)loadChips
{
    //风火轮
    [self createIndicator];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSDictionary * parameters = @{@"Key":@"A2BB2C892444B155A2540CBF04AB1752", @"Method":@"GetShardInfo", @"UserID":@"", @"Latitude":[NSString stringWithFormat:@"%f",self.myCoordinate.latitude], @"Longitude":[NSString stringWithFormat:@"%f", self.myCoordinate.longitude], @"distance":@"50"};
    [manager POST:MyURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        //停下风火轮
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:104];
        [indicator stopAnimating];
        
        for (NSDictionary * dic in [responseObject objectForKey:@"OffineShard"]) {
            Chip * chip = [[Chip alloc] initWithDictionary:dic];
            [self.chipArray addObject:chip];
            [self addPointAnnotation:chip];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"error: %@", error);
    }];
    
    
}

//创建一个风火轮
- (void)createIndicator
{
    UIActivityIndicatorView *indicator = nil;
    indicator = (UIActivityIndicatorView *)[self.view viewWithTag:104];
    if (indicator == nil) {
        //初始化:
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        indicator.tag = 104;
        //设置显示样式,见UIActivityIndicatorViewStyle的定义
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        //设置背景色
        indicator.backgroundColor = [UIColor blackColor];
        //设置背景透明
        indicator.alpha = 0.5;
        //设置背景为圆角矩形
        indicator.layer.cornerRadius = 6;
        indicator.layer.masksToBounds = YES;
        //设置显示位置
        [indicator setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
        
        //开始显示Loading动画
        [indicator startAnimating];
        
        [self.view addSubview:indicator];
    }
    //开始显示Loading动画
    [indicator startAnimating];
}


//添加一个PointAnnotation碎片
- (void)addPointAnnotation:(Chip *)chip
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([chip.Latitude floatValue], [chip.Longitude floatValue]);
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = chip.ShardName;;
    [self.mapView addAnnotation:annotation];
}

//回到当前位置
- (void)backToCurrentPosition:(UIButton *)btn
{
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(_myCoordinate.latitude , _myCoordinate.longitude);
}

//切换模式
- (void)exchangeMode:(UIButton *)btn
{
//    CameraTypeController * cameraVC = [[CameraTypeController alloc] init];
    
    CameraController * cameraVC = [[CameraController alloc] init];
    [cameraVC forceOrientationLandscape]; //设置横屏
    [self.view addSubview:cameraVC.view];
    [self addChildViewController:cameraVC];

    [cameraVC didMoveToParentViewController:self];
}

//进入选择任务
- (void)startDuties
{
    DutyController * dutyVC = [[DutyController alloc] init];
    [self.navigationController pushViewController:dutyVC animated:YES];
    
    
}

#pragma mark - configueMap
+ (void)initialize {
    //设置自定义地图样式，会影响所有地图实例
    //注：必须在BMKMapView对象初始化之前调用
    NSString* path = [[NSBundle mainBundle] pathForResource:@"custom_config_黑夜" ofType:@""];
    [BMKMapView customMapStyle:path];
}

//配置地图
- (void)configueMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.showMapPoi = NO;//不显示底层标注
    _mapView.showsUserLocation = YES;//显示定位
    _mapView.zoomLevel = 15;
    _mapView.minZoomLevel = 13;
    _mapView.maxZoomLevel = 18;
    _mapView.showMapScaleBar = YES;//比例尺
    _mapView.mapScaleBarPosition = CGPointMake(5, self.view.frame.size.height - 40);//比例尺位置
    [BMKMapView enableCustomMapStyle:YES];//开启自定义地图样式
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    [self.view addSubview:_mapView];

    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    //进入地图开始显示自己的坐标
    [_locService startUserLocationService];
    
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    
    //切换摄像头模式
    UIButton * exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBtn.frame = CGRectMake(H_Space, self.view.frame.size.height - H_Space - 70, 70, 70);
    exchangeBtn.backgroundColor = [UIColor clearColor];
//    [exchangeBtn setTitle:@"切换" forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchangeMode:) forControlEvents:UIControlEventTouchUpInside];
    exchangeBtn.layer.masksToBounds = YES;
    [exchangeBtn.layer setCornerRadius:3.0];
    exchangeBtn.titleLabel.font = [UIFont fontWithName:@"SF-UI-Display" size:20.0];
    [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"切换.png"] forState:UIControlStateNormal];
    [self.view addSubview:exchangeBtn];
    
    //扫描
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(self.view.frame.size.width / 2.0 - 35, self.view.frame.size.height - H_Space - 70, 70, 70);
    searchBtn.backgroundColor = [UIColor clearColor];
//    [searchBtn setTitle:@"扫描" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchDestination1) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.masksToBounds = YES;
    [searchBtn.layer setCornerRadius:3.0];
//    [searchBtn setImage:[UIImage imageNamed:@"扫描.png"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"扫描.png"] forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    
    //任务
    UIButton * dutyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dutyBtn.frame = CGRectMake(self.view.frame.size.width - H_Space - 70, self.view.frame.size.height - H_Space - 70, 70, 70);
    dutyBtn.backgroundColor = [UIColor clearColor];
    [dutyBtn addTarget:self action:@selector(startDuties) forControlEvents:UIControlEventTouchUpInside];
    [dutyBtn setBackgroundImage:[UIImage imageNamed:@"任务.png"] forState:UIControlStateNormal];
    [self.view addSubview:dutyBtn];
    
    //回到当前位置
    UIButton * backToCurrent = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(H_Space, exchangeBtn.top - 90, 70, 70) backgroundImage:[UIImage imageNamed:@"定位.png"] target:self action:@selector(backToCurrentPosition:)];
//    backToCurrent.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:backToCurrent];
    
}

#pragma mark - BMKLocationServiceDelegate
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.compassPosition = CGPointMake(20, 80);//指南针位置起点
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userLocation = userLocation;
    self.myCoordinate = userLocation.location.coordinate;//我的位置
    [_mapView updateLocationData:userLocation];//显示自己所在位置的小圆圈
    
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];        
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;//大头针颜色
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.annotation=annotation;
        
        if ([annotation.title isEqualToString:@"钢铁侠碎片1 of 5"]) {
            newAnnotationView.image = [UIImage imageNamed:@"碎片_死侍.png"];
        }else if([annotation.title isEqualToString:@"钢铁侠碎片2 of 5"]){
            newAnnotationView.image = [UIImage imageNamed:@"碎片_布朗熊.png"];
        }else{
            newAnnotationView.image = [UIImage imageNamed:@"ironman.png"];
        }
        
        //弹出的气泡视图
        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 45)];
        popView.backgroundColor = [UIColor clearColor];
        [popView.layer setMasksToBounds:YES];
        [popView.layer setCornerRadius:3.0];
                
        //自定义气泡的内容，添加子控件在popView上
        UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, popView.width, popView.height - 15)];
        driverName.backgroundColor = [UIColor colorWithRed:16 / 255.0 green:16 / 255.0 blue:16 / 255.0 alpha:1.0];
        driverName.text = annotation.title;
        driverName.numberOfLines = 0;
        driverName.font = [UIFont systemFontOfSize:15];
        driverName.textColor = [UIColor lightGrayColor];
        driverName.textAlignment = NSTextAlignmentCenter;
        [popView addSubview:driverName];
        
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
        pView.frame = popView.frame;
        ((BMKPinAnnotationView*)newAnnotationView).paopaoView = nil;
        ((BMKPinAnnotationView*)newAnnotationView).paopaoView = pView;
        
        return newAnnotationView;
    }
    return nil;
}

//点击碎片,进入碎片挑战页面
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSInteger index = [self.mapView.annotations indexOfObject:view.annotation];
    
    StartChipController * startVC = [[StartChipController alloc] init];
    startVC.chip = [self.chipArray objectAtIndex:index];
    if ([self calculateDistance:[self.chipArray objectAtIndex:index]] < 1000) {
        startVC.distance = [NSString stringWithFormat:@"距离%.fm",[self calculateDistance:[self.chipArray objectAtIndex:index]]];
    }else{
        startVC.distance = [NSString stringWithFormat:@"距离%.1fkm",[self calculateDistance:[self.chipArray objectAtIndex:index]] / 1000.0];
    }
    [self.navigationController pushViewController:startVC animated:YES];
}

//计算当前位置与目标位置的两点间距离
- (CLLocationDistance)calculateDistance:(Chip *)chip
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([chip.Latitude floatValue], [chip.Longitude floatValue]);
    BMKMapPoint point1 = BMKMapPointForCoordinate(_myCoordinate);//我的位置坐标点
    BMKMapPoint point2 = BMKMapPointForCoordinate(coordinate);//目标位置坐标点
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    return distance;
}

- (void)mapview:(BMKMapView *)mapView baseIndoorMapWithIn:(BOOL)flag baseIndoorMapInfo:(BMKBaseIndoorMapInfo *)info
{
    if (flag) {
        NSLog(@"进入室内");
    }else{
        NSLog(@"进入室外");
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%.f", _mapView.zoomLevel);
    return YES;
}

#pragma mark - ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _searcher.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
}

- (NSMutableArray *)chipArray
{
    if (!_chipArray) {
        self.chipArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _chipArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
