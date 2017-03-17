//
//  Aplus_RepairCell.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/14.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Aplus_RepairModel;
@interface Aplus_RepairCell : UITableViewCell

@property (strong, nonatomic) Aplus_RepairModel * repairModel;
@property (weak, nonatomic) IBOutlet UIView *contenView;

@property (weak, nonatomic) IBOutlet UILabel *repairId;
@property (weak, nonatomic) IBOutlet UILabel *repairDate;
@property (weak, nonatomic) IBOutlet UILabel *assetNo;
@property (weak, nonatomic) IBOutlet UILabel *assetName;
@property (weak, nonatomic) IBOutlet UILabel *assetAlias;
@property (weak, nonatomic) IBOutlet UILabel *deptName;
@property (weak, nonatomic) IBOutlet UILabel *repairStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderType;








+ (Aplus_RepairCell *)repairCellWithTableView:(UITableView *)tableView;
@end
