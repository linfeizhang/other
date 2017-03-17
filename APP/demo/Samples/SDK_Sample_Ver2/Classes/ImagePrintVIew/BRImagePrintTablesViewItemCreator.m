//
//  BRImagePrintViewItemCreator.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/06/23.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#define Connecting  @"Active"
#define UnConnected @"Passive"

#import "BRPtouchDeviceInfo.h"
#ifndef WLAN_ONLY
#import "BRPtouchPrinterKit/BRPtouchBluetoothManager.h"
#endif

#import "UserDefaults.h"
#import "BRImagePrintTablesViewItemCreator.h"

@interface BRImagePrintTablesViewItemCreator ()
{
}
@property(nonatomic, strong) NSMutableArray *itemsArray;
@end

@implementation BRImagePrintTablesViewItemCreator
{
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (BRImagePrintTablesViewItem *)selectedImagePrintTablesViewItem:(NSInteger)tag tableSection:(NSInteger)section
{
    self.itemsArray = [[NSMutableArray alloc] init];
    self.itemsArray = [self createImagePrintTablesViewItems];
    
    BRImagePrintTablesViewItem *item = nil;
    if (tag == 1) {
        switch (section) {
            case 0:
                item = [self.itemsArray objectAtIndex:0];
                break;
#ifndef WLAN_ONLY
            case 1:
                item = [self.itemsArray objectAtIndex:1];
                item.cellLabelDetailName = [self bluetoothPairingCheck];
                break;
#endif
                
            default:
                //Error
                item = nil;
                break;
        }
    }
    else if (tag == 2) {
        item = [self.itemsArray objectAtIndex:2];
    }
    else {
        // Error
        item = nil;
    }
    
    return item;
}

#ifndef WLAN_ONLY
- (NSString *) bluetoothPairingCheck
{
    NSString *isPaired = UnConnected;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *serialNumber = [userDefaults objectForKey:kSerialNumber];
    
    NSMutableArray *pairedDeviceArray = [NSMutableArray arrayWithArray:[[BRPtouchBluetoothManager sharedManager] pairedDevices]];
    for (BRPtouchDeviceInfo *deviceInfo in pairedDeviceArray) {
        if ([serialNumber isEqualToString:deviceInfo.strSerialNumber]) {
            isPaired = Connecting;
            break;
        }
    }
    
    return isPaired;
}
#endif

- (NSMutableArray *)createImagePrintTablesViewItems
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.itemsArray = [[NSMutableArray alloc] init];
    
    if (self.itemsArray)
    {
        BRImagePrintTablesViewItem *itemForWiFi = [[BRImagePrintTablesViewItem alloc] init];
        itemForWiFi.itemID              = [NSNumber numberWithInteger:searchDeviceForWiFi];
        itemForWiFi.sectionLabelName    = NSLocalizedString(@"Wi-Fi", nil);
        itemForWiFi.cellID              = NSLocalizedString(@"deviceSearchCellForWiFi", nil);
        itemForWiFi.cellLabelName       = [userDefaults stringForKey:kSelectedDeviceFromWiFi];
        itemForWiFi.cellLabelDetailName = NSLocalizedString(@"", nil);
        [self.itemsArray addObject:itemForWiFi];
        
        BRImagePrintTablesViewItem *itemForMFi = [[BRImagePrintTablesViewItem alloc] init];
        itemForMFi.itemID              = [NSNumber numberWithInteger:searchDeviceForMFi];
        itemForMFi.sectionLabelName    = NSLocalizedString(@"Bluetooth", nil);
        itemForMFi.cellID              = NSLocalizedString(@"deviceSearchCellForMFi", nil);
        itemForMFi.cellLabelName       = [userDefaults stringForKey:kSelectedDeviceFromBluetooth];
        itemForMFi.cellLabelDetailName = NSLocalizedString(@"", nil);
        [self.itemsArray addObject:itemForMFi];
        
        BRImagePrintTablesViewItem *itemForPrintSetting = [[BRImagePrintTablesViewItem alloc] init];
        itemForPrintSetting.itemID              = [NSNumber numberWithInteger:rootPrintSetting];
        itemForPrintSetting.sectionLabelName    = NSLocalizedString(@"Root print setting", nil);
        itemForPrintSetting.cellID              = NSLocalizedString(@"rootPrintSettingCell", nil);
        itemForPrintSetting.cellLabelName       = NSLocalizedString(@"Print Settings", nil);
        itemForPrintSetting.cellLabelDetailName = NSLocalizedString(@"", nil);
        [self.itemsArray addObject:itemForPrintSetting];
    }
    
    return self.itemsArray;
}


@end
