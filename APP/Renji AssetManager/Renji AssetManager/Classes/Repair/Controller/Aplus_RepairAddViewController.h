//
//  Aplus_RepairAddViewController.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/15.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Aplus_RepairAddViewController : UIViewController

@property (strong, nonatomic) NSString * titleText;

@property (weak, nonatomic) IBOutlet UIView *backgroudView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *limitLabel;

@property (weak, nonatomic) IBOutlet UITextField *assetNo;
@property (weak, nonatomic) IBOutlet UITextField *repairId;
@property (weak, nonatomic) IBOutlet UITextField *assetName;
@property (weak, nonatomic) IBOutlet UITextField *serial;
@property (weak, nonatomic) IBOutlet UITextField *hospitalName;
@property (weak, nonatomic) IBOutlet UITextField *repairDate;
@property (weak, nonatomic) IBOutlet UITextField *repairMan;
@property (weak, nonatomic) IBOutlet UITextField *repairTel;
@property (weak, nonatomic) IBOutlet UITextField *deptName;
@property (weak, nonatomic) IBOutlet UITextField *locaName;
@property (weak, nonatomic) IBOutlet UITextField *repairStatus;
@property (weak, nonatomic) IBOutlet UITextField *faultType;
@property (weak, nonatomic) IBOutlet UITextView *comment;

@end
