//
//  BRPrintResultViewController.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/08/27.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import "BRPtouchPrinterKit.h"

#import "UserDefaults.h"
#import "BRPrintResultViewController.h"
#import "BRWLANPrintOperation.h"
#import "BRBluetoothPrintOperation.h"

@interface BRPrintResultViewController ()
{
    BRPtouchPrinter	*_ptp;
}
@property(nonatomic, weak) IBOutlet UILabel *communicationResultLabel;
@property(nonatomic, weak) IBOutlet UILabel *sendDataLabel;
@property(nonatomic, weak) IBOutlet UILabel *printResultLabel;
@property(nonatomic, weak) IBOutlet UILabel *batteryPowerLabel;

@property(nonatomic, strong) NSOperationQueue           *queueForWLAN;
@property(nonatomic, strong) BRWLANPrintOperation       *operationForWLAN;
@property(nonatomic, strong) NSOperationQueue           *queueForBT;
@property(nonatomic, strong) BRBluetoothPrintOperation  *operationForBT;

@property(nonatomic, strong) NSString *bytesWrittenMessage;
@property(nonatomic, strong) NSNumber *bytesWritten;
@property(nonatomic, strong) NSNumber *bytesToWrite;

@property(nonatomic, assign) CONNECTION_TYPE type;
@end

@implementation BRPrintResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem.enabled = NO;
    
self.communicationResultLabel.text = @"Communication Result : ";
    self.bytesWritten = [NSNumber numberWithInt:0];
    self.bytesToWrite = [NSNumber numberWithInt:0];
    self.sendDataLabel.text = [NSString stringWithFormat:@"Send Data : %@/%@",self.bytesWritten, self.bytesToWrite];
    self.printResultLabel.text = @"Print Result : ";
    self.batteryPowerLabel.text = @"Battery Power : ";
    self.type = CONNECTION_ERROR;

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths lastObject];
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1){
        self.type = CONNECTION_TYPE_BLUETOOTH;
            selectedDevice = [NSString stringWithFormat:@"Brother %@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0){
        self.type = CONNECTION_TYPE_WLAN;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
    }
    else{

        self.type = CONNECTION_ERROR;
    }

    
    NSString *ipAddress     = [userDefaults stringForKey:kIPAddress];
    NSString *serialNumber  = [userDefaults stringForKey:kSerialNumber];
    
    // PrintInfo
    BRPtouchPrintInfo *printInfo = [[BRPtouchPrintInfo alloc] init];
    
    if ([[userDefaults stringForKey:kExportPrintFileNameKey] isEqualToString:@""]) { 
        printInfo.strSaveFilePath	= @"";
    }
    else {
        NSString *fileName = [[userDefaults stringForKey:kExportPrintFileNameKey] stringByAppendingPathExtension:@"prn"];
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        printInfo.strSaveFilePath = filePath; // Item 0
    }
    
    NSString *numPaper = [userDefaults stringForKey:kPrintNumberOfPaperKey]; // Item 1
    
    printInfo.strPaperName		= [userDefaults stringForKey:kPrintPaperSizeKey]; // Item 2
    printInfo.nOrientation		= (int)[userDefaults integerForKey:kPrintOrientationKey]; // Item 3
    printInfo.nPrintMode		= (int)[userDefaults integerForKey:kScalingModeKey]; // Item 4
    printInfo.scaleValue		= [userDefaults doubleForKey:kScalingFactorKey]; // Item 5
    
    printInfo.nHalftone			= (int)[userDefaults integerForKey:kPrintHalftoneKey]; // Item 6
    printInfo.nHorizontalAlign	= (int)[userDefaults integerForKey:kPrintHorizintalAlignKey]; // Item 7
    printInfo.nVerticalAlign	= (int)[userDefaults integerForKey:kPrintVerticalAlignKey]; // Item 8
    printInfo.nPaperAlign		= (int)[userDefaults integerForKey:kPrintPaperAlignKey]; // Item 9
    
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintCodeKey]; // Item 10
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintCarbonKey]; // Item 11
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintDashKey]; // Item 12
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintFeedModeKey]; // Item 13
    
    printInfo.nRollPrinterCase	= (int)[userDefaults integerForKey:kPrintCurlModeKey]; // Item 14
    printInfo.nSpeed            = (int)[userDefaults integerForKey:kPrintSpeedKey]; // Item 15
    printInfo.bBidirection      = (int)[userDefaults integerForKey:kPrintBidirectionKey]; // Item 16
    
    printInfo.nCustomFeed   = (int)[userDefaults integerForKey:kPrintFeedMarginKey]; // Item 17
    printInfo.nCustomLength = (int)[userDefaults integerForKey:kPrintCustomLengthKey]; // Item 18
    printInfo.nCustomWidth  = (int)[userDefaults integerForKey:kPrintCustomWidthKey]; // Item 19
    
    printInfo.nAutoCutFlag  |= (int)[userDefaults integerForKey:kPrintAutoCutKey]; // Item 20
    printInfo.bEndcut = (int)[userDefaults integerForKey:kPrintCutAtEndKey]; // Item 21
    printInfo.bHalfCut       = (int)[userDefaults integerForKey:kPrintHalfCutKey]; // Item 22
    printInfo.bSpecialTape      = (int)[userDefaults integerForKey:kPrintSpecialTapeKey]; // Item 23
    printInfo.bRotate180     = (int)[userDefaults integerForKey:kRotateKey]; // Item 24
    printInfo.bPeel          = (int)[userDefaults integerForKey:kPeelKey]; // Item 25
    
    NSString *customPaper = [userDefaults stringForKey:kPrintCustomPaperKey]; // Item 26
    NSString *customPaperFilePath = nil;
    if(![customPaper isEqualToString:@"NoCustomPaper"]) {
        customPaperFilePath = [NSString stringWithFormat:@"%@/%@",directory, [userDefaults stringForKey:kPrintCustomPaperKey]];
    }
    
    printInfo.bCutMark      = (int)[userDefaults integerForKey:kPrintCutMarkKey]; // Item 27
    printInfo.nLabelMargine = (int)[userDefaults integerForKey:kPrintLabelMargineKey]; // Item 28
    
    if ([selectedDevice rangeOfString:@"RJ-"].location != NSNotFound ||
        [selectedDevice rangeOfString:@"TD-"].location != NSNotFound) {
        printInfo.nDensity = (int)[userDefaults integerForKey:kPrintDensityMax5Key]; // Item 29
    }
    else if([selectedDevice rangeOfString:@"PJ-"].location != NSNotFound){
        printInfo.nDensity = (int)[userDefaults integerForKey:kPrintDensityMax10Key]; // Item 30
    }
    else {
        // Error
    }
    
    printInfo.nTopMargin   = (int)[userDefaults integerForKey:kPrintTopMarginKey]; // Item 31
    printInfo.nLeftMargin   = (int)[userDefaults integerForKey:kPrintLeftMarginKey]; // Item 32
    
    NSLog(@"kSelectedDevice             = %@"   , selectedDevice);
    NSLog(@"kIPAddress                  = %@"   , ipAddress);
    NSLog(@"kSerialNumber               = %@"   , serialNumber);
    NSLog(@"");
    NSLog(@"strSaveFilePath             = %@"   , printInfo.strSaveFilePath);
    NSLog(@"kPrintNumberOfPaperKey      = %@"   , numPaper);
    NSLog(@"kPrintPaperSizeKey          = %@"   , printInfo.strPaperName);
    NSLog(@"kPrintOrientationKey        = %d"   , printInfo.nOrientation);
    NSLog(@"kPrintDensityKey            = %d"   , printInfo.nDensity);
    NSLog(@"kScalingModeKey             = %d"   , printInfo.nPrintMode);
    NSLog(@"kScalingFactorKey           = %lf"  , printInfo.scaleValue);
    NSLog(@"kPrintHalftoneKey           = %d"   , printInfo.nHalftone);
    NSLog(@"kPrintHorizintalAlignKey    = %d"   , printInfo.nHorizontalAlign);
    NSLog(@"kPrintVerticalAlignKey      = %d"   , printInfo.nVerticalAlign);
    NSLog(@"kPrintPaperAlignKey         = %d"   , printInfo.nPaperAlign);
    NSLog(@"");
    NSLog(@"nExtFlag                    = %d"   , printInfo.nExtFlag);
    NSLog(@"");
    NSLog(@"nRollPrinterCase            = %d"   , printInfo.nRollPrinterCase);
    NSLog(@"nSpeed                      = %d"   , printInfo.nSpeed);
    NSLog(@"bBidirection                = %d"   , printInfo.bBidirection);
    NSLog(@"");
    NSLog(@"kPrintFeedMarginKey         = %d"   , printInfo.nCustomFeed);
    NSLog(@"kPrintCustomLengthKey       = %d"   , printInfo.nCustomLength);
    NSLog(@"kPrintCustomWidthKey        = %d"   , printInfo.nCustomWidth);
    NSLog(@"");
    NSLog(@"nAutoCutFlag                = %d"   , printInfo.nAutoCutFlag);
    NSLog(@"bEndCut                     = %d"   , printInfo.bEndcut);
    NSLog(@"bSpecialTape                = %d"   , printInfo.bSpecialTape);
    NSLog(@"bHalfCut                    = %d"   , printInfo.bHalfCut);
    NSLog(@"bRotate180                  = %d"   , printInfo.bRotate180);
    NSLog(@"bPeel                       = %d"   , printInfo.bPeel);
    NSLog(@"");
    NSLog(@"kPrintCustomPaperKey        = %@"   , customPaperFilePath);
    NSLog(@"");
    NSLog(@"bCutMark                    = %d"   , printInfo.bCutMark);
    NSLog(@"nLabelMargine               = %d"   , printInfo.nLabelMargine);
    
    [self initWithNotificationObserver];
    
    if (self.type != CONNECTION_ERROR)
    {
        _ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:self.type];
        CGImageRef imgRef = [self.img CGImage];
        switch (self.type)
        {
            case CONNECTION_TYPE_WLAN:
            {
                self.queueForWLAN = [[NSOperationQueue alloc] init];
                self.operationForWLAN = [[BRWLANPrintOperation alloc] initWithOperation:_ptp
                                                                              printInfo:printInfo
                                                                                 imgRef:imgRef
                                                                          numberOfPaper:[numPaper intValue]
                                                                              ipAddress:ipAddress
                                                                        customPaperFile:customPaperFilePath];
                [self.operationForWLAN addObserver:self
                                        forKeyPath:@"isFinishedForWLAN"
                                           options:NSKeyValueObservingOptionNew
                                           context:nil];
                
                [self.operationForWLAN addObserver:self
                                        forKeyPath:@"communicationResultForWLAN"
                                           options:NSKeyValueObservingOptionNew
                                           context:nil];
                
                self.operationForWLAN.delegate = self;
                
                [self.queueForWLAN addOperation:self.operationForWLAN];
            }
                break;
                
            case CONNECTION_TYPE_BLUETOOTH:
#ifndef WLAN_ONLY
            {
                NSArray *pairedDevices = [NSArray arrayWithArray:[[BRPtouchBluetoothManager sharedManager] pairedDevices]];
                if (pairedDevices == nil) {
                    NSLog(@"No Bluetooth Device Connected !!");
                }
                else {
                    self.queueForBT = [[NSOperationQueue alloc] init];
                    self.operationForBT = [[BRBluetoothPrintOperation alloc] initWithOperation:_ptp
                                                                                     printInfo:printInfo
                                                                                        imgRef:imgRef
                                                                                 numberOfPaper:[numPaper intValue]
                                                                                  serialNumber:serialNumber
                                                                               customPaperFile:customPaperFilePath];

                    [self.operationForBT addObserver:self
                                          forKeyPath:@"isFinishedForBT"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
                    
                    [self.operationForBT addObserver:self
                                          forKeyPath:@"communicationResultForBT"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
                    
                    self.operationForBT.delegate = self;
                    
                    [self.queueForBT addOperation:self.operationForBT];
                }
            }
#endif
                break;
                
            case CONNECTION_ERROR:
            {
                // Error
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeNotificationObserver];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"isFinishedForWLAN"])
    {
        self.queueForWLAN = nil;
        [self.operationForWLAN removeObserver:self forKeyPath:@"isFinishedForWLAN"];
        [self.operationForWLAN removeObserver:self forKeyPath:@"communicationResultForWLAN"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.view reloadInputViews];
        });
    }
    else if ([keyPath isEqualToString:@"isFinishedForBT"])
    {
        self.queueForBT = nil;
        [self.operationForBT removeObserver:self forKeyPath:@"isFinishedForBT"];
        [self.operationForBT removeObserver:self forKeyPath:@"communicationResultForBT"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.view reloadInputViews];
        });
    }
    else if ([keyPath isEqualToString:@"communicationResultForWLAN"])
    {
        BOOL result = _operationForWLAN.communicationResultForWLAN;
        self.communicationResultLabel.text = [NSString stringWithFormat:@"Communication Result : %d",result];
        if (!result) {
            self.queueForWLAN = nil;
            [self.operationForWLAN removeObserver:self forKeyPath:@"isFinishedForWLAN"];
            [self.operationForWLAN removeObserver:self forKeyPath:@"communicationResultForWLAN"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view reloadInputViews];
        });
    }
    else if ([keyPath isEqualToString:@"communicationResultForBT"])
    {
        BOOL result = _operationForBT.communicationResultForBT;
        self.communicationResultLabel.text = [NSString stringWithFormat:@"Communication Result : %d",result];
        if (!result) {
            self.queueForBT = nil;
            [self.operationForBT removeObserver:self forKeyPath:@"isFinishedForBT"];
            [self.operationForBT removeObserver:self forKeyPath:@"communicationResultForBT"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view reloadInputViews];
        });
    }
}

#pragma mark - Notification (for Progress)

- (void) initWithNotificationObserver
{
    self.bytesWrittenMessage = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bytesWrittenNotification:)
                                                 name:BRWLanConnectBytesWrittenNotification
                                               object:nil];
    
#ifndef WLAN_ONLY
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bytesWrittenNotification:)
                                                 name:BRBluetoothSessionBytesWrittenNotification
                                               object:nil];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bytesWrittenNotification:)
                                                 name:BRPtouchPrinterKitMessageNotification
                                               object:nil];
}

- (void) removeNotificationObserver
{
    self.bytesWrittenMessage = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BRWLanConnectBytesWrittenNotification
                                                  object:nil];
    
#ifndef WLAN_ONLY
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BRBluetoothSessionBytesWrittenNotification
                                                  object:nil];
#endif
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BRPtouchPrinterKitMessageNotification
                                                  object:nil];
}

- (void) bytesWrittenNotification: (NSNotification *)notification
{
    NSString *msgStr = [notification.userInfo objectForKey:@"message"];
    if ([msgStr isEqualToString:@"MESSAGE_START_SEND_DATA"] ||
        [msgStr isEqualToString:@"MESSAGE_END_SEND_DATA"]   ||
        [msgStr isEqualToString:@"MESSAGE_PRINT_COMPLETE"]  ||
        [msgStr isEqualToString:@"MESSAGE_PRINT_ERROR"]){
        self.bytesWrittenMessage = msgStr;
    }
    
    if ([self.bytesWrittenMessage isEqualToString:@"MESSAGE_START_SEND_DATA"])
    {
        self.bytesWritten = [notification.userInfo objectForKey:@"bytesWritten"];
        self.bytesToWrite = [notification.userInfo objectForKey:@"bytesToWrite"];
        NSLog(@"bytesWritten = %d", [self.bytesWritten intValue]);
        NSLog(@"bytesToWrite = %d", [self.bytesToWrite intValue]);
        
        NSLog(@"message = %@", msgStr);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.sendDataLabel.text = [NSString stringWithFormat:@"Send Data : %@/%@",self.bytesWritten, self.bytesToWrite];
            [self.view reloadInputViews];
        });
    }
    else if ([self.bytesWrittenMessage isEqualToString:@"MESSAGE_END_SEND_DATA"])
    {
        NSLog(@"*   message = %@", msgStr);
            self.bytesWritten = 0;
            self.bytesToWrite = 0;
    }
    else if ([self.bytesWrittenMessage isEqualToString:@"MESSAGE_END_READ_PRINTER_STATUS"])
    {
        NSLog(@"**  message = %@", msgStr);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.navigationController reloadInputViews];
        });
    }
    else if ([self.bytesWrittenMessage isEqualToString:@"MESSAGE_PRINT_ERROR"])
    {
        NSLog(@"**  message = %@", msgStr);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.navigationController reloadInputViews];
        });
    }
    else
    {
        NSLog(@"*** message = %@", msgStr);
    }
}

- (void) showPrintResultForWLAN
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
        if (self.type == CONNECTION_TYPE_WLAN) {
            self.printResultLabel.text  = [NSString stringWithFormat:@"Print Result  : %ld", [userDefaults integerForKey:kPrintResultForWLAN]];
            self.batteryPowerLabel.text = [NSString stringWithFormat:@"Battery Power : %ld", [userDefaults integerForKey:kPrintStatusBatteryPowerForWLAN]];
            [self.printResultLabel reloadInputViews];
        }
    });
}

- (void) showPrintResultForBluetooth
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
        if  (self.type == CONNECTION_TYPE_BLUETOOTH) {
            self.printResultLabel.text  = [NSString stringWithFormat:@"Print Result  : %ld", [userDefaults integerForKey:kPrintResultForBT]];
            self.batteryPowerLabel.text = [NSString stringWithFormat:@"Battery Power : %ld", [userDefaults integerForKey:kPrintStatusBatteryPowerForBT]];
        }
    });
}

@end
