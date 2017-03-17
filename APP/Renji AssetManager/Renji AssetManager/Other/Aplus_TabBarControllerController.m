//
//  Aplus_TabBarControllerController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/8.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_TabBarControllerController.h"
#import "Aplus_AssetListViewController.h"
#import "Aplus_AboutViewController.h"
#import "Aplus_RepairViewController.h"
@interface Aplus_TabBarControllerController ()

@end

@implementation Aplus_TabBarControllerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITabBar appearance].barTintColor=RGB(240, 240, 240);
    [UITabBar appearance].tintColor = RGB(80, 139, 241);
    
    self.tabBar.translucent = NO;
    [self addChildViewController:[[Aplus_AssetListViewController alloc]init] title:@"资产" imageName:@"tabbar_home" imageSelectedName:@"tabbar_home"];
    [self addChildViewController:[[Aplus_RepairViewController alloc]init] title:@"报修" imageName:@"tabbar_repair" imageSelectedName:@"tabbar_repair"];
    [self addChildViewController:[[Aplus_AboutViewController alloc]init] title:@"关于" imageName:@"tabbar_owner" imageSelectedName:@"tabbar_owner"];

}
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)normalName imageSelectedName:(NSString *)selectedName{
    childController.title = title;
    //    UIImage * normalImage = [[UIImage imageNamed:normalName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.image = [UIImage imageNamed:normalName];//normalImage;
    //    UIImage * selectedImage = [[UIImage imageNamed:selectedName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:normalName];//selectedImage;
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont fontWithName:@"Arial" size:12]} forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(80, 139, 241),NSFontAttributeName:[UIFont fontWithName:@"Arial" size:12]} forState:UIControlStateSelected];
    Aplus_NavigationController * nav = [[Aplus_NavigationController alloc]initWithRootViewController:childController];
    [self addChildViewController:nav];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
