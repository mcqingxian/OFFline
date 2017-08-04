//
//  AppDelegate.m
//  OFFLine
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInController.h"
#import <AVFoundation/AVFoundation.h>

#import "Header.h"
#import "MainTabVC.h"
#import "InStroVC.h"
#import "UserDefaults.h"
#import "GameVC.h"
@interface AppDelegate ()

@end

BMKMapManager* _mapManager;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"xEKYaOiQ478x1OdeAEiDa9eQOZeQm12Y" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    NSError *err = nil;
    [[AVAudioSession sharedInstance]setCategory: AVAudioSessionCategoryPlayback error: &err];
    [[AVAudioSession sharedInstance]setActive: YES error: &err];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.isForcePortrait = YES;//强制竖屏
    
    LogInController * logInVC = [LogInController defaultLogIn];
    UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:logInVC];
    self.window.rootViewController = naVC;
    
    [self.window makeKeyAndVisible];

    return YES;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.isForceLandscape) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else if (self.isForcePortrait){
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
