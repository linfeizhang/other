//
//  Aplus_AssetDetailViewController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/8.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_AssetDetailViewController.h"
#import "Aplus_ImagePrintViewController.h"
#import "Aplus_AssetModel.h"
@interface Aplus_AssetDetailViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *asset_no;
@property (weak, nonatomic) IBOutlet UITextField *asset_serial;
@property (weak, nonatomic) IBOutlet UITextField *asset_name;
@property (weak, nonatomic) IBOutlet UITextField *asset_alias;
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *model;

@end

@implementation Aplus_AssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资产详情";
    [self loadAssetListData];
}
- (void)repeatUI:(Aplus_AssetModel *)model{
    _asset_no.text = model.assetNo;
    _asset_name.text = model.assetName;
    _asset_alias.text = model.alias;
    _department.text = model.deptName;
    _model.text = model.model;
}
#pragma mark /************ loadData ************/
- (void)loadAssetListData{
    [Aplus_Until startSVP:@"加载中..."];
    NSString * url = [NSString stringWithFormat:@"%@%@",[Aplus_Api api_assets_asset_no],_assetNo];
    
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"获取资产详情数据%@",responseObject);
        if (responseObject[@"error_code"]) {
            [Aplus_Until alertView:@"加载失败!"];
        }else{
            Aplus_AssetModel * model = [Aplus_AssetModel modelWithDict:responseObject];
            [self repeatUI:model];
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"获取资产详情失败%@",error);
    }];
}

- (IBAction)printButtonAction:(id)sender {
    Aplus_ImagePrintViewController * imageViewController = [[Aplus_ImagePrintViewController alloc]init];
    imageViewController.asset_no = [_asset_no.text triming];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imageViewController animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
