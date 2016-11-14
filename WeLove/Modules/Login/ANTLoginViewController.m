//
//  ANZLoginViewController.m
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ANTLoginViewController.h"
#import "ANTTextField.h"
#import "LoginManager.h"

@interface ANTLoginViewController () <RCIMUserInfoDataSource>
//登录logo
@property(nonatomic,strong)UIImageView *loginIcon;
//手机号码
@property(nonatomic,strong)ANTTextField *phoneNumberTextField;
//密码
@property(nonatomic,strong)ANTTextField *passwordTextField;
//登录按钮
@property(nonatomic,strong)UIButton *loginBtn;

//登录APIManager
@property(nonatomic,strong)LoginManager *loginManager;
@end

@implementation ANTLoginViewController

- (void)loadSubViews
{
    [super loadSubViews];
    self.leftBtn.hidden = NO;
    self.titleLabel.text = @"登 录";
    [self.contentView addSubview:self.loginIcon];
    [self.contentView addSubview:self.phoneNumberTextField];
    [self.contentView addSubview:self.passwordTextField];
    [self.contentView addSubview:self.loginBtn];
    
    if (userManager.userInfo.phoneNumber.length) {
        self.phoneNumberTextField.text = userManager.userInfo.phoneNumber;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)layoutConstraints
{
    WS(weakSelf);
    [self.loginIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(107);
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).offset(60);
    }];
    
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view).offset(-30);
        make.top.mas_equalTo(weakSelf.loginIcon.mas_bottom).offset(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view).offset(-30);
        make.top.mas_equalTo(weakSelf.phoneNumberTextField.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(30);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(weakSelf.passwordTextField.mas_bottom).offset(40);
    }];
    
    
    [self handleKeyboardShowEvent];
    [self.contentView layoutIfNeeded];
//    self.contentView.contentSize = CGSizeMake(kScreenWidth, self.forgetBtn.bottom+40);
}

+(void)presentLoginPageSuccess:(void(^)())success
{
    ANTLoginViewController *loginVC = [[ANTLoginViewController alloc] init];
    loginVC.loginSuccessBlock = success;
    [kRootNavigation pushViewController:loginVC animated:YES];
}

#pragma mark - APIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(BaseAPIManager *)manager
{
    return @{@"account":self.phoneNumberTextField.text,
             @"pwd":[QMUtil sha512Encode:self.passwordTextField.text]};
}

#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(BaseAPIManager *)manager
{
    userManager.userInfo.phoneNumber = self.phoneNumberTextField.text;
    [userManager saveUserInfo];
    [userManager updatePassword:self.passwordTextField.text];
    
    NSString *token = RONGCLOUD_Token;
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        // 设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        NSLog(@"Login successfully with userId: %@.", userId);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 登录成功之后，跳转到主页面
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"登录成功");
//            ComTabBarController *viewController = [[ComTabBarController alloc] init];
//            ComNavigationController *rootNav = [[ComNavigationController alloc] initWithRootViewController:viewController];
//            [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"login error status: %ld.", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
    }];
//    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChangedNotification object:nil];
    if (self.loginSuccessBlock) {
        self.loginSuccessBlock();
    }
}

- (void)managerCallAPIDidFailed:(BaseAPIManager *)manager
{
    [MBProgressHUD showTip:manager.errorMessage];
}

#pragma mark - actions
- (void)textFieldTextChanged:(NSNotification *)note
{
    self.loginBtn.enabled = self.phoneNumberTextField.text.length && self.passwordTextField.text.length;
    UITextField *textField = note.object;
    if (textField==self.phoneNumberTextField) {
        if (textField.text.length>=11) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
        }
    }
}

- (void)loginAction
{
    if (self.phoneNumberTextField.text.length < 11) {
        [MBProgressHUD showTip:@"亲爱的，请输入11位手机号"];
        return;
    }
    if (![QMUtil checkMoblieNumber:self.phoneNumberTextField.text]) {
        [MBProgressHUD showTip:@"亲爱的，请输入正确的手机号码"];
        return;
    }
    if ([self.phoneNumberTextField.text isEqualToString:@""]) {
        [MBProgressHUD showTip:@"亲爱的，账号不能为空哦~"];
        return;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [MBProgressHUD showTip:@"亲爱的，密码不能为空哦~"];
        return;
    }
//    if (![self.passwordTextField.text isEqualToString:@"20161026520"]) {
//        [MBProgressHUD showTip:@"亲爱的，密码不对哦~"];
//        return;
//    }
    
    [self.loginManager loadDataWithHUDOnView:self.contentView];
}


#pragma mark - getters and setters
- (UIImageView *)loginIcon
{
    if (!_loginIcon) {
        _loginIcon = [[UIImageView alloc] init];
        _loginIcon.contentMode = UIViewContentModeScaleAspectFit;
        _loginIcon.image = [UIImage imageNamed:@"ic_login_logo"];
    }
    return _loginIcon;
}

- (ANTTextField *)phoneNumberTextField
{
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[ANTTextField alloc] initWithLeftTitle:@"手机号码："];
        _phoneNumberTextField.placeholder = @"亲爱的、请输入账号";
        _phoneNumberTextField.font = XiHeiFont(16);
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _phoneNumberTextField;
}

- (ANTTextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[ANTTextField alloc] initWithLeftTitle:@"密      码："];
        _passwordTextField.placeholder = @"亲爱的、请输入密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.font = XiHeiFont(16);
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _passwordTextField;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.layer.cornerRadius = 3;
        [_loginBtn setBackgroundImage:[QMUtil createImageWithColor:kBgLightGrayColor] forState:UIControlStateDisabled];
        [_loginBtn setBackgroundImage:[QMUtil createImageWithColor:kRedColor] forState:UIControlStateNormal];
        _loginBtn.clipsToBounds = YES;
        [_loginBtn setTitle:@"登    录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = XiHeiFont(16);
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}

- (LoginManager *)loginManager
{
    if (!_loginManager) {
        _loginManager = [[LoginManager alloc] init];
        _loginManager.paramSource = (id)self;
        _loginManager.delegate = (id)self;
        _loginManager.validator = (id)_loginManager;
    }
    return _loginManager;
}

@end
