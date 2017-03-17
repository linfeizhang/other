//
//  BRPrintResultViewController.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/08/27.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRWLANPrintOperation.h"
#import "BRBluetoothPrintOperation.h"

@protocol BRPrintResultViewControllerDelegate <NSObject>
- (void) showPrintResultForWLAN;
- (void) showPrintResultForBluetooth;
@end

@interface BRPrintResultViewController : UIViewController<BRWLANPrintOperationDelegate, BRBluetoothPrintOperationDelegate>
{
}
@property (nonatomic, weak)id<BRPrintResultViewControllerDelegate> delegate;
@property (nonatomic, strong)UIImage *img;

@end
