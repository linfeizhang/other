//
//  Aplus_AddAssetViewController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/8.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_AddAssetViewController.h"

@interface Aplus_AddAssetViewController ()<SGScanningQRCodeVCDelegate>
@property (weak, nonatomic) IBOutlet UITextField *asset_no;
@property (weak, nonatomic) IBOutlet UITextField *asset_serial;
@property (weak, nonatomic) IBOutlet UITextField *asset_name;
@property (weak, nonatomic) IBOutlet UITextField *asset_alias;
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *model;

@end

@implementation Aplus_AddAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增资产";
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction)];
//    self.navigationItem.rightBarButtonItem = rightItem;
}



- (IBAction)submitAction:(id)sender {
    [self generateQRCode];
}
/** 开始扫描 */
- (IBAction)scanAtion:(id)sender {
    [Aplus_Until scanningQRCodeBlock:^{
        SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
        scanningQRCodeVC.delegate = self;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
    }];
}

#pragma mark /************ SGScanningQRCodeVC delegate ************/
- (void)receiveScanningResult:(NSString *)string{
    _asset_no.text = string;
    
}
/** 生成二维码方法 */
- (void)generateQRCode {
    SGGenerateQRCodeVC *VC = [[SGGenerateQRCodeVC alloc] init];
    VC.asset_no = [_asset_no.text triming];
    [self.navigationController pushViewController:VC animated:YES];
}










@end
