//
//  CountDownManager.h
//  VaccinePatient
//
//  Created by Jam on 16/6/14.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CD_COUNTDOWN_LOGIN,     //登录验证码倒计时
    CD_COUNTDOWN_PWD,       //重置密码
    CD_COUNTDOWN_FORGET,    //忘记密码验证码倒计时
    CD_COUNTDOWN_MOBILE,    //修改手机号验证码倒计时
    CD_COUNTDOWN_MOBILE_VALIDATE,//修改手机号时手机验证倒计时
    CD_COUNTDOWN_APMENT ,   //预约验证码倒计时
    CD_COUNTDOWN_REGISTER,     //注册验证码倒计时
    
} ConutDownType;



@interface CountDownManager : NSObject {

    NSDate *_loginSMSDate;  //登录验证码发送时间
    NSDate *_passwordDate;  //重置密码验证码发送时间
    NSDate *_forgetSMSDate; //忘记密码验证码发送时间
    NSDate *_validateMobileSMSDate;  //修改手机时验证手机验证码码发送时间
    NSDate *_mobileSMSDate; //修改手机号验证码发送时间
    NSDate *_apmentSMSDate; //预约验证码发送时间
    NSDate *_registerSMSDate; //注册验证码发送时间

}


@property (nonatomic, assign) int countDownLogin;   //登录验证码剩余秒数
@property (nonatomic, assign) int countDownForget;  //忘记密码验证码剩余秒数
@property (nonatomic, assign) int countDownPWD;     //重置密码验证码剩余秒数
@property (nonatomic, assign) int countDownMobileValidate;  //修改手机时验证手机验证码剩余秒数
@property (nonatomic, assign) int countDownMobile;  //修改手机验证码剩余秒数
@property (nonatomic, assign) int countDownApment;  //预约验证码剩余秒数
@property (nonatomic, assign) int countDownRegister;  //注册验证码剩余秒数

+ (instancetype)manager;


/**
 *  倒计时
 *  ConutDownType: 倒计时类型
 */
- (void)countdownTime:(ConutDownType)type;

//重置所有的计数倒计时
- (void)resetAllCountDownTimer;

@end
