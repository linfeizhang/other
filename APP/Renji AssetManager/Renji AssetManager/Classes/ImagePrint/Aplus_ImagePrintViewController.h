//
//  Aplus_ImagePrintViewController.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/9.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    searchDeviceForWiFi = 1,
    searchDeviceForMFi,
    rootPrintSetting
} BRImagePrintTablesViewItemEnum;
@interface Aplus_ImagePrintViewController : UIViewController
@property (strong, nonatomic) NSString * asset_no;
@end
