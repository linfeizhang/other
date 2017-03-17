//
//  Aplus_AssetCell.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/9.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_AssetCell.h"
#import "Aplus_AssetModel.h"

@implementation Aplus_AssetCell

- (void)setModel:(Aplus_AssetModel *)model{
    _model = model;
    _asset_name.text = model.assetName;
    _asset_no.text = model.assetNo;
    _department.text = model.deptName;
    _status.text = model.model;
}

@end
