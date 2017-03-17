//
//  Aplus_AboutViewController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/8.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_AboutViewController.h"
#import "Aplus_LoginViewController.h"
@interface Aplus_AboutViewController ()

@end

@implementation Aplus_AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)logoutAction:(id)sender {
    Aplus_LoginViewController * login = [[Aplus_LoginViewController alloc]init];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = login;
    [window makeKeyAndVisible];
//    [self.tabBarController dismissViewControllerAnimated:NO completion:nil];
}



@end
