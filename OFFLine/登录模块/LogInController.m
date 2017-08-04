//
//  LogInController.m
//  MyUnityOniOS
//
//  Created by Apple on 16/8/5.
//  Copyright © 2016年 Oneprime. All rights reserved.
//

#import "LogInController.h"
#import "AView.h"
#import "HomeController.h"
#import "RegisterController.h"

#define L_Space 20
#define L_Width [UIApplication sharedApplication].keyWindow.frame.size.width / 2.0
#define L_Height 40
#define Button_Width [UIApplication sharedApplication].keyWindow.frame.size.width / 6.0
@interface LogInController ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField * userNameTextField;//用户名
@property (nonatomic, strong)UITextField * passwordTextField;//密码
@property (nonatomic, strong)UIButton * rememberPasswordBtn;//记住密码
@property (nonatomic, strong)UIButton * logInBtn;//登录按钮
@property (nonatomic, strong)UIButton * registerBtn;//注册按钮

@end

@implementation LogInController

+ (LogInController *)defaultLogIn
{
    static LogInController * logInVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logInVC = [[LogInController alloc] init];
    });
    return logInVC;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSubViews];
}

//创建子视图
- (void)createSubViews
{
    
    UIImageView * bgImageView = [UIImageView imageViewWithFrame:[UIApplication sharedApplication].keyWindow.frame backgroundColor:nil image:[UIImage imageNamed:@"登录页面背景.png"]];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    self.userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(L_Width / 2.0 - 5, [UIApplication sharedApplication].keyWindow.frame.size.height / 5.0 * 2, L_Width + 7, L_Height)];
    _userNameTextField.delegate = self;
    _userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _userNameTextField.placeholder = @"6~20位英文字符或数字";
    _userNameTextField.font = [UIFont systemFontOfSize:15.0];
    _userNameTextField.secureTextEntry = NO;//是否密文输入
    _userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userNameTextField.returnKeyType = UIReturnKeyDone;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    [bgImageView addSubview:_userNameTextField];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(L_Width / 2.0 - 5, _userNameTextField.bottom + L_Space, L_Width + 7, L_Height)];
    _passwordTextField.delegate = self;
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.font = [UIFont systemFontOfSize:15.0];
    _passwordTextField.secureTextEntry = YES;//是否密文输入
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    [bgImageView addSubview:_passwordTextField];
    
    //记住密码
    _rememberPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(L_Width / 2.0, _passwordTextField.bottom + L_Space * 2, 25, 25) backgroundImage:[UIImage imageNamed:@"记住密码按钮0.png"] target:self action:@selector(rememberMyPassword:)];
    [_rememberPasswordBtn setImage:[UIImage imageNamed:@"记住密码按钮1.png"] forState:UIControlStateSelected];
    _rememberPasswordBtn.layer.masksToBounds = YES;
    _rememberPasswordBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [_rememberPasswordBtn.layer setBorderWidth:1.0]; //边框宽度
    [_rememberPasswordBtn.layer setCornerRadius:3.0];
    [bgImageView addSubview:_rememberPasswordBtn];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_rememberPasswordBtn.right + 5, _rememberPasswordBtn.top, 80, 30)];
    label.text = @"记住密码";
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor whiteColor];
    [bgImageView addSubview:label];
    
    //登录按钮
    _logInBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(L_Width + 30, _passwordTextField.bottom + L_Space * 2, Button_Width, 30) backgroundImage:nil target:self action:@selector(logIn)];
    [_logInBtn setTitle:@"接入" forState:UIControlStateNormal];
    _logInBtn.backgroundColor = [UIColor colorWithRed:157 / 255.0 green:197 / 255.0 blue:71 / 255.0 alpha:1.0];
    [_logInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _logInBtn.layer.masksToBounds = YES;
    _logInBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [_logInBtn.layer setBorderWidth:1.0]; //边框宽度
    [_logInBtn.layer setCornerRadius:4.0];
    [bgImageView addSubview:_logInBtn];
    
    BOOL btnSelected = [[NSUserDefaults standardUserDefaults] boolForKey:@"btnValue"];
    _rememberPasswordBtn.selected = btnSelected;
    if (btnSelected) {
        _userNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"myUserName"];
        _passwordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"myPassword"];
    }else{
        _userNameTextField.text = @"";
        _passwordTextField.text = @"";
    }
    
    //注册
//    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(Button_Width + _logInBtn.right, _passwordTextField.bottom + L_Space, Button_Width, L_Height) backgroundImage:nil target:self action:@selector(registerUser)];
//    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
//    _registerBtn.backgroundColor = [UIColor darkGrayColor];
//    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _registerBtn.layer.masksToBounds = YES;
//    _registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    [_registerBtn.layer setBorderWidth:1.0]; //边框宽度
//    [_registerBtn.layer setCornerRadius:8.0];
//    [bgImageView addSubview:_registerBtn];
    
}

//点击键盘回车按钮,执行操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_userNameTextField resignFirstResponder];//关闭键盘
    [_passwordTextField resignFirstResponder];
    
    return YES;
}


//登录
- (void)logIn
{
    //风火轮
    [self createIndicator];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSDictionary * parameters = @{@"Key":@"A2BB2C892444B155A2540CBF04AB1752", @"Method":@"CheckUser", @"registrationID":@"", @"username":_userNameTextField.text, @"password":_passwordTextField.text};
    [manager POST:MyURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //        NSLog(@"%@", responseObject);
        //停下风火轮
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:103];
        [indicator stopAnimating];
        
        if ([[responseObject objectForKey:@"Message"] isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"UserID"];
            //如果选择记住密码
            if (_rememberPasswordBtn.selected) {
                [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"myUserName"];
                [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:@"myPassword"];
            }
            //登录成功
            HomeController * homeVC = [[HomeController alloc] init];
            homeVC.userName = _userNameTextField.text;
            [self.navigationController pushViewController:homeVC animated:YES];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"error: %@", error);
    }];
}

- (void)rememberMyPassword:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"btnValue"];
        NSLog(@"1");
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"btnValue"];
        NSLog(@"0");
    }
}

//注册用户
- (void)registerUser
{
    RegisterController * registerVC = [[RegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//创建一个风火轮
- (void)createIndicator
{
    UIActivityIndicatorView *indicator = nil;
    indicator = (UIActivityIndicatorView *)[self.view viewWithTag:103];
    
    if (indicator == nil) {
        
        //初始化:
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        
        indicator.tag = 103;
        
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
