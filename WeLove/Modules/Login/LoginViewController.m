//
//  LoginViewController.m
//  LoveMySmallV
//
//  Created by 宇玄丶 on 2016/11/3.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "LoginViewController.h"

//#import "ComNavigationController.h"
//#import "ComTabBarController.h"

@interface LoginViewController ()
//<RCIMUserInfoDataSource>
{
    UIImageView *View;
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
    UIButton *QQBtn;
    UIButton *weixinBtn;
    UIButton *xinlangBtn;
}
@property(copy,nonatomic) NSString * accountNumber;
@property(copy,nonatomic) NSString * mmmm;
@property(copy,nonatomic) NSString * user;

@end

@implementation LoginViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    View.image = [UIImage imageNamed:@"bg4"];
    [self.view addSubview:View];
    
    UILabel *lanel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-30)/2, 30, 50, 30)];
    lanel.text = @"登录";
    lanel.textColor = [UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.view addSubview:lanel];
    
    // 账号、密码
    [self createTextFields];
    [self createLabel];
    [self createImageViews];
    [self createButtons];
}

- (void)createTextFields {
    CGRect frame = [UIScreen mainScreen].bounds;
    bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 75, frame.size.width-20, 100)];
    bgView.layer.cornerRadius = 3.0;
    bgView.alpha = 0.7;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    user = [self createTextFielfFrame:CGRectMake(60, 10, 271, 30) font:[UIFont systemFontOfSize:14] placeholder:@"亲爱的、请输入账号"];
    user.text = @"13520245101";
    user.keyboardType = UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    pwd = [self createTextFielfFrame:CGRectMake(60, 60, 271, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"亲爱的、请输入密码" ];
    pwd.text = @"20161026520";
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwd.secureTextEntry = YES;
    
    
    UIImageView *userImageView = [self createImageViewFrame:CGRectMake(20, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView = [self createImageViewFrame:CGRectMake(20, 60, 25, 25) imageName:@"mm_normal" color:nil];
    UIImageView *line1 = [self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    [bgView addSubview:user];
    [bgView addSubview:pwd];
    
    [bgView addSubview:userImageView];
    [bgView addSubview:pwdImageView];
    [bgView addSubview:line1];
}

- (void)createLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, 390, 140, 21)];
    label.text = @"第三方账号快速登录";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
}

- (void)createImageViews {
    
    UIImageView *line3 = [self createImageViewFrame:CGRectMake(2, 400, 100, 1) imageName:nil color:[UIColor lightGrayColor]];
    UIImageView *line4 = [self createImageViewFrame:CGRectMake(self.view.frame.size.width-100-4, 400, 100, 1) imageName:nil color:[UIColor lightGrayColor]];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
}

- (void)createButtons {
    UIButton *landBtn = [self createButtonFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 37) backImageName:nil title:@"登录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(landClick)];
    landBtn.backgroundColor = [UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    
    UIButton *newUserBtn = [self createButtonFrame:CGRectMake(5, 235, 70, 30) backImageName:nil title:@"快速注册" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(registration:)];
    //newUserBtn.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *forgotPwdBtn = [self createButtonFrame:CGRectMake(self.view.frame.size.width-75, 235, 60, 30) backImageName:nil title:@"找回密码" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(fogetPwd:)];
    //fogotPwdBtn.backgroundColor=[UIColor lightGrayColor];
    
    
#define Start_X 60.0f           // 第一个按钮的X坐标
#define Start_Y 440.0f           // 第一个按钮的Y坐标
#define Width_Space 50.0f        // 2个按钮之间的横间距
#define Height_Space 20.0f      // 竖间距
#define Button_Height 50.0f    // 高
#define Button_Width 50.0f      // 宽
    
    
    
    //微信
    weixinBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2, 440, 50, 50)];
    //weixinBtn.tag = UMSocialSnsTypeWechatSession;
    weixinBtn.layer.cornerRadius=25;
    weixinBtn = [self createButtonFrame:weixinBtn.frame backImageName:@"ic_landing_wechat" title:nil titleColor:nil font:nil target:self action:@selector(onClickQQ:)];
    //qq
    QQBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2-100, 440, 50, 50)];
    //QQBtn.tag = UMSocialSnsTypeMobileQQ;
    QQBtn.layer.cornerRadius=25;
    QQBtn = [self createButtonFrame:QQBtn.frame backImageName:@"ic_landing_qq" title:nil titleColor:nil font:nil target:self action:@selector(onClickQQ:)];
    
    //新浪微博
    xinlangBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2+100, 440, 50, 50)];
    //xinlangBtn.tag = UMSocialSnsTypeSina;
    xinlangBtn.layer.cornerRadius=25;
    xinlangBtn = [self createButtonFrame:xinlangBtn.frame backImageName:@"ic_landing_microblog" title:nil titleColor:nil font:nil target:self action:@selector(onClickQQ:)];
    
    [self.view addSubview:weixinBtn];
    [self.view addSubview:QQBtn];
    [self.view addSubview:xinlangBtn];
    [self.view addSubview:landBtn];
//    [self.view addSubview:newUserBtn];
//    [self.view addSubview:forgotPwdBtn];
    
    
}

//登录
- (void)landClick {
    if ([user.text isEqualToString:@""]) {
        [MBProgressHUD showTip:@"亲爱的，账号不能为空哦~"];
        return;
    }
    else if (user.text.length < 11 && ![user.text isEqualToString:@"13520245101"] && ![user.text isEqualToString:@"18304624061"]) {
        [MBProgressHUD showTip:@"亲爱的，账号不对哦~"];
        return;
    }
    else if ([pwd.text isEqualToString:@""]) {
        [MBProgressHUD showTip:@"亲爱的，密码不能为空哦~"];
        return;
    }
    else if (![pwd.text isEqualToString:@"20161026520"]) {
        [MBProgressHUD showTip:@"亲爱的，密码不对哦~"];
        return;
    }
    
    /*
    NSString *token = RONGCLOUD_Token;
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        // 设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        NSLog(@"Login successfully with userId: %@.", userId);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 登录成功之后，跳转到主页面
            ComTabBarController *viewController = [[ComTabBarController alloc] init];
            ComNavigationController *rootNav = [[ComNavigationController alloc] initWithRootViewController:viewController];
            [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"login error status: %ld.", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
    }];
     */
}

- (void)registration:(UIButton *)button {
}

- (void)fogetPwd:(UIButton *)button {
}

- (void)onClickQQ:(UIButton *)button {
}


/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion {
//    //此处为了演示写了一个用户信息
//    if ([@"yugeaixiaowei" isEqual:userId]) {
//        RCUserInfo *user = [[RCUserInfo alloc]init];
//        user.userId = @"yugeaixiaowei";
//        user.name = @"yugeaixiaowei";
//        
//        NSString *imgStr = (NSString *)[UIImage imageNamed:@"WechatIMG11.jpeg"];
//        user.portraitUri = imgStr;
//        
//        return completion(user);
//    }
//}


- (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    
    if (imageName) {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color) {
        imageView.backgroundColor=color;
    }
    return imageView;
}
- (UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    
    textField.font = font;
    textField.textColor = [UIColor grayColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    
    return textField;
}

- (UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (imageName) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font) {
        btn.titleLabel.font = font;
    }
    
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
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
