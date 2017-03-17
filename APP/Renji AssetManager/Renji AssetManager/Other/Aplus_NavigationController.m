//
//  Aplus_NavigationController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/8.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_NavigationController.h"

@interface Aplus_NavigationController ()

@end

@implementation Aplus_NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UINavigationBar appearance].barTintColor= [UIColor stringToColor:@"#147bc5"];//RGB(58, 58, 62);
    [UINavigationBar appearance].tintColor= [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
