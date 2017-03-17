//
//  Aplus_SearchDeviceController.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/9.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <BRPtouchPrinterKit/BRPtouchNetworkManager.h>

typedef enum BRSearchMode : NSInteger
{
    BRSearchModeIPv4,
    BRSearchModeIPv6IPv4,
} BRSearchMode;

@interface Aplus_SearchDeviceController : UITableViewController <BRPtouchNetworkDelegate>

@property (assign, nonatomic) BRSearchMode mSearchMode;
@end
