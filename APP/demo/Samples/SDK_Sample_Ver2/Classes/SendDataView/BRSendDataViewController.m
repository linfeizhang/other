//
//  BRSendDataViewController.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/09/02.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import "BRPtouchPrinterKit.h"

#import "UserDefaults.h"
#import "BRSendDataViewController.h"

@interface BRSendDataViewController ()
{
}
@property(nonatomic, weak) IBOutlet UILabel *selectedSendData;
//@property(nonatomic, strong) NSString           *ipAddress;
@property(nonatomic, strong) BRPtouchPrinter    *ptp;
@end

@implementation BRSendDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedSendDataName = [userDefaults objectForKey:kSelectedSendDataName];
    self.selectedSendData.text = selectedSendDataName;
    [self.view reloadInputViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)sendDataSelectButton:(id)sender {
}

- (IBAction)sendDataButton:(id)sender
{
    [sender setEnabled:NO];
    CONNECTION_TYPE type = CONNECTION_ERROR;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedSendDataPath = [userDefaults objectForKey:kSelectedSendDataPath];
    NSString *selectedDevice = nil;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1)
    {
        type = CONNECTION_TYPE_BLUETOOTH;
        selectedDevice = [NSString stringWithFormat:@"Brother %@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
        
        NSString *serialNumber = [userDefaults stringForKey:kSerialNumber];
        if (serialNumber) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setupForBluetoothDeviceWithSerialNumber:serialNumber];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0)
    {
        type = CONNECTION_TYPE_WLAN;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
        
        NSString *ipAddress = [userDefaults stringForKey:kIPAddress];
        if (ipAddress) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setIPAddress:ipAddress];
        }
    }
    else
    {
        type = CONNECTION_ERROR;
    }
    
    int isSuccess = -1;
    if (type == CONNECTION_ERROR) {
        [self showAlertSendDataResult:isSuccess];
    }else{
        BOOL startCommunicationResult = [self.ptp startCommunication];
        if (startCommunicationResult) {

            BOOL isPDZFile = false;
            BOOL isBLFFile = false;
            if (type == CONNECTION_TYPE_BLUETOOTH) {
                isPDZFile =[selectedSendDataPath hasSuffix:@".pd3"];
            }
            else if (type == CONNECTION_TYPE_WLAN){
                isBLFFile = [selectedSendDataPath hasSuffix:@".blf"];
            }
            
            if (isPDZFile || isBLFFile) {
                isSuccess = [self.ptp sendTemplate:selectedSendDataPath connectionType:type];
            }else {
//                isSuccess = [self.ptp sendFile:selectedSendDataPath];
                
                NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"1489374202"]);
                isSuccess = [self.ptp sendData:data];
            }
            [self showAlertSendDataResult:isSuccess];
        }
        [self.ptp endCommunication];
    }
    
    [sender setEnabled:YES];
}

- (void)showAlertSendDataResult: (int)isSuccess
{
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    NSString *title = @"Send Result";
    NSString *message = @"";
    if (isSuccess == 0) {
        message = @"Success";
    }else {
        message = @"Failure";
    }
    
    if(osVersion >= 8.0f) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (osVersion < 8.0f && osVersion >= 6.0f) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        // Non Support
    }
}

@end
