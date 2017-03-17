//
//  Aplus_LoginViewController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/15.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_LoginViewController.h"
#import "Aplus_AssetListViewController.h"
#import "Aplus_ImagePrintViewController.h"


@interface Aplus_LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameFeild;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *rememberButton;
@end

@implementation Aplus_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}
- (void)initUI{
    UIImageView * imageViewUser = [[UIImageView alloc]initWithFrame:CGRectMake(3, 8, 30, 20)];
    imageViewUser.image = [UIImage imageNamed:@"icon_login_user"];
    imageViewUser.contentMode = UIViewContentModeScaleAspectFit;
    _userNameFeild.leftView = imageViewUser;
    _userNameFeild.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * imageViewPassword = [[UIImageView alloc]initWithFrame:CGRectMake(3, 8, 30, 20)];
    imageViewPassword.image = [UIImage imageNamed:@"icon_login_password"];
    imageViewPassword.contentMode = UIViewContentModeScaleAspectFit;
    _passwordField.leftView = imageViewPassword;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    _loginButton.layer.cornerRadius = 5;
    _rememberButton.layer.cornerRadius = 3;
}
- (void)initData{
    _userNameFeild.text = UserName;
    _passwordField.text = Password;
    _rememberButton.selected = YES;
}
- (IBAction)rememberAction:(UIButton *)sender {
    _rememberButton.selected = !_rememberButton.selected;
}


- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    if ([[_userNameFeild.text triming] isEqualToString:@""]) {
        [Aplus_Until alertView:@"请输入账号"];
    }else if ([[_passwordField.text triming] isEqualToString:@""]){
        [Aplus_Until alertView:@"请输入密码"];
    }else{
        [self sendLoginRequest];
        [[NSUserDefaults standardUserDefaults]setObject:[_userNameFeild.text triming] forKey:@"UserName"];
    }
    
}

- (void)sendLoginRequest{
    [Aplus_Until startSVP:@"登录中..."];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"client_id"] = [Aplus_Api client_id];
    params[@"client_secret"] = [Aplus_Api client_secret];
    params[@"grant_type"] = @"password";
    params[@"username"] = [_userNameFeild.text triming];
    params[@"password"] = [Aplus_Until md5String:[_passwordField.text triming]];
    NSString *strUrl=[Aplus_Api api_token];
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:strUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (_rememberButton.selected == YES) {
            
            [[NSUserDefaults standardUserDefaults]setObject:[_passwordField.text triming] forKey:@"Password"];
        }else{
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Password"];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"access_token"] forKey:@"ACCESS_TOKEN"];
        [SVProgressHUD dismiss];
        Aplus_TabBarControllerController * tab = [[Aplus_TabBarControllerController alloc]init];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = tab;
        [window makeKeyAndVisible];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error = %@",error);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
