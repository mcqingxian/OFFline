//
//  MyUtil.h
//  SkyFighting
//
//  Created by Apple on 16/8/24.
//  Copyright © 2016年 孙昕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIViewController(PushView)
-(UIViewController*)pushViewController:(NSString *)ToView Param:(NSDictionary*)param;
-(UIViewController*)presentViewController:(NSString *)ToView Param:(NSDictionary*)param;
-(void)dismiss;
-(void)flipToView:(UIView*)view;
@end
@interface NSString (Extensin)
- (NSString *) md5;
- (NSString *) trim;
- (BOOL) isEmpty;
- (NSDictionary *) parseJson;
- (BOOL)isMobileNumber;
@end

@interface MyUtil : NSObject

/// 获得设备号
+ (NSString *)getIdentifierForVendor;

/// 获取caches目录下文件夹路径
+ (NSString *)getCachesPath:(NSString *)directoryName;

/// 获得缓存文件夹路径
+ (NSString *)getCachesDirPath:(NSString *)cachesDir;

/// data json解析
+ (id)getSerializationData:(NSData *)data;

/// 获得文字的尺寸
+ (CGSize)getContentSize:(NSString *)content withCGSize:(CGSize)size withSystemFontOfSize:(int)font;

+(UIViewController*)topViewController;
+ (NSString *)getCurrentDeviceModel;
@end

@interface UIImage (RoundRectImage)
- (UIImage *)roundRectWithRadius:(NSInteger)r;
@end

@interface UIView (Additions)
-(UIViewController *)viewController;
-(UIImage*)imageCache;
@end

@interface NSDictionary (WG)
-(NSString*)json;
@end

@interface UIButton (Text)
@property (strong,nonatomic) NSString *text;
@end

@interface NSDate (String)
-(NSString*)stringValue;
@end

@interface NSTimer (TFAddition)
-(void)pause;
-(void)resume;

@end

@interface NSString (size)
- (CGFloat)fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
@end

@interface UIImage (Additions)
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;


@end
