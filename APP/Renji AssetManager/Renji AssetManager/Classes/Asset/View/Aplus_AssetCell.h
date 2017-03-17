//
//  Aplus_AssetCell.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/9.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Aplus_AssetModel;
@interface Aplus_AssetCell : UITableViewCell
@property (strong, nonatomic) Aplus_AssetModel * model;

@property (weak, nonatomic) IBOutlet UILabel *asset_name;

@property (weak, nonatomic) IBOutlet UILabel *asset_no;

@property (weak, nonatomic) IBOutlet UILabel *department;

@property (weak, nonatomic) IBOutlet UILabel *status;

@end
