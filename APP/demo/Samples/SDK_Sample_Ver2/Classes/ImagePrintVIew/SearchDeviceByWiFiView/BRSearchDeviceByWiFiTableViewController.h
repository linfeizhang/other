//
//  BRSearchDeviceByWiFiViewControllerTableViewController.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/06/24.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPtouchNetworkManager.h"

typedef enum BRSearchMode : NSInteger
{
    BRSearchModeIPv4,
    BRSearchModeIPv6IPv4,
} BRSearchMode;

@interface BRSearchDeviceByWiFiTableViewController : UITableViewController <BRPtouchNetworkDelegate>

@property (assign, nonatomic) BRSearchMode mSearchMode;


@end
