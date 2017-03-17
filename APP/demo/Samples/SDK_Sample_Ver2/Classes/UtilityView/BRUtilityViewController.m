//
//  BRUtilityViewController.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2016/11/01.
//  Copyright (c) 2016年 Kusumoto Naoki. All rights reserved.
//

#import "BRPtouchPrinterKit.h"
#import "UserDefaults.h"
#import "BRUtilityViewController.h"

@interface BRUtilityViewController ()
{
}
@property(nonatomic, weak) IBOutlet UISwitch    *autoConnectBluetoothSwitch;
@property(nonatomic, weak) IBOutlet UILabel     *autoConnectBluetoothStatusLabel;
@property(nonatomic, strong) BRPtouchPrinter    *ptp;
@end

@implementation BRUtilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.autoConnectBluetoothSwitch.on = NO;
    self.autoConnectBluetoothStatusLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction) settingForAutoConnectBluetoothButton:(id)sender
{
    [sender setEnabled:NO];
    CONNECTION_TYPE type = CONNECTION_ERROR;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1){
        type = CONNECTION_TYPE_BLUETOOTH;
        selectedDevice = [NSString stringWithFormat:@"Brother %@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
        
        NSString *serialNumber = [userDefaults stringForKey:kSerialNumber];
        if (serialNumber) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setupForBluetoothDeviceWithSerialNumber:serialNumber];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0){
        type = CONNECTION_TYPE_WLAN;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
        
        NSString *ipAddress = [userDefaults stringForKey:kIPAddress];
        if (ipAddress) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setIPAddress:ipAddress];
        }
    }
    else{
        type = CONNECTION_ERROR;
    }
    
    if (type != CONNECTION_ERROR) {
        BOOL startCommunicationResult = [self.ptp startCommunication];
        if (startCommunicationResult) {
            BOOL isAutoConnectBluetooth = self.autoConnectBluetoothSwitch.on;
            [self.ptp setAutoConnectBluetooth: isAutoConnectBluetooth];
        }
        [self.ptp endCommunication];
    }
    [sender setEnabled:YES];
}

- (IBAction)getAutoConnectBluetooth:(id)sender
{
    [sender setEnabled:NO];
    CONNECTION_TYPE type = CONNECTION_ERROR;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1){
        type = CONNECTION_TYPE_BLUETOOTH;
        selectedDevice = [NSString stringWithFormat:@"Brother %@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
        
        NSString *serialNumber = [userDefaults stringForKey:kSerialNumber];
        if (serialNumber) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setupForBluetoothDeviceWithSerialNumber:serialNumber];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0){
        type = CONNECTION_TYPE_WLAN;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
        
        NSString *ipAddress = [userDefaults stringForKey:kIPAddress];
        if (ipAddress) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setIPAddress:ipAddress];
        }
    }
    else{
        type = CONNECTION_ERROR;
    }
    
    if (type != CONNECTION_ERROR) {
        BOOL startCommunicationResult = [self.ptp startCommunication];
        if (startCommunicationResult) {
            int isAutoConnectBluetooth = [self.ptp isAutoConnectBluetooth];
            self.autoConnectBluetoothStatusLabel.text = [NSString stringWithFormat:@"%d", isAutoConnectBluetooth];
            [self.autoConnectBluetoothStatusLabel reloadInputViews];
        }
        [self.ptp endCommunication];
    }
    [sender setEnabled:YES];
}


@end
