//
//  BRImagePrintViewItemCreator.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/06/23.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRImagePrintTablesViewItem.h"

typedef enum {
    searchDeviceForWiFi = 1,
    searchDeviceForMFi,
    rootPrintSetting
} BRImagePrintTablesViewItemEnum;

@interface BRImagePrintTablesViewItemCreator : NSObject
{
}

- (BRImagePrintTablesViewItem *)selectedImagePrintTablesViewItem:(NSInteger)tag tableSection:(NSInteger)section;
- (NSMutableArray *)createImagePrintTablesViewItems;
@end
