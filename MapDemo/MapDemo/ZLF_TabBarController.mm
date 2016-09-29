//
//  ZLF_TabBarController.m
//  MapDemo
//
//  Created by inhandnetworks on 16/9/29.
//  Copyright © 2016年 inhandnetworks. All rights reserved.
//

#import "ZLF_TabBarController.h"
#import "ZLF_NavigationController.h"
#import "ZLF_FirstViewController.h"
@interface ZLF_TabBarController ()

@end

@implementation ZLF_TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    ZLF_FirstViewController * firstController = [[ZLF_FirstViewController alloc]init];
    ZLF_NavigationController * navController = [[ZLF_NavigationController alloc]initWithRootViewController:firstController];
    firstController.title = @"mapDemo";
    [self addChildViewController:navController];
    self.tabBar.hidden = YES;
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
