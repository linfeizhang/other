//
//  Aplus_RepairCell.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/14.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_RepairCell.h"
#import "Aplus_RepairModel.h"


@implementation Aplus_RepairCell


- (void)setRepairModel:(Aplus_RepairModel *)repairModel{
    NSArray * statusArr = [Aplus_Until getDictWithKey:@"orderStatus"];
    NSArray * orderTypeArr = [Aplus_Until getDictWithKey:@"orderType"];

    _repairModel = repairModel;
    _repairId.text = repairModel.repairId;
    _repairDate.text = repairModel.createDT;
    _assetNo.text = repairModel.assetNo;
    _assetName.text = repairModel.assetName;
    _assetAlias.text = repairModel.alias;
    _deptName.text = repairModel.deptName;
    _repairStatus.text = statusArr[repairModel.status];
    _orderType.text = orderTypeArr[repairModel.orderType];
}


+ (Aplus_RepairCell *)repairCellWithTableView:(UITableView *)tableView{
    static NSString * CellIdentifier=@"Aplus_RepairCell";
    Aplus_RepairCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:CellIdentifier owner:self options:nil]  lastObject];
    }
    return cell;
}

@end
