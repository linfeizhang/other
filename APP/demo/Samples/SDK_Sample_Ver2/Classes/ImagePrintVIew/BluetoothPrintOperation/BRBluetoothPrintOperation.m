//
//  BRBluetoothPrintOperation.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/08/18.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import "UserDefaults.h"
#import "BRBluetoothPrintOperation.h"

@interface BRBluetoothPrintOperation ()
{
}
@property(nonatomic, assign) BOOL isExecutingForBT;
@property(nonatomic, assign) BOOL isFinishedForBT;

@property(nonatomic, weak) BRPtouchPrinter    *ptp;
@property(nonatomic, strong) BRPtouchPrintInfo  *printInfo;
@property(nonatomic, assign) CGImageRef         imgRef;
@property(nonatomic, assign) int                numberOfPaper;
@property(nonatomic, strong) NSString           *serialNumber;
@property(nonatomic, strong) NSString           *customPaperFilePath;

@end


@implementation BRBluetoothPrintOperation

- (id)initWithOperation:(BRPtouchPrinter *)targetPtp
              printInfo:(BRPtouchPrintInfo *)targetPrintInfo
                 imgRef:(CGImageRef)targetImgRef
          numberOfPaper:(int)targetNumberOfPaper
           serialNumber:(NSString *)targetSerialNumber
        customPaperFile:targetCustomPaperFilePath
{
    self = [super init];
    if (self) {
        self.ptp            = targetPtp;
        self.printInfo      = targetPrintInfo;
        self.imgRef         = targetImgRef;
        self.numberOfPaper  = targetNumberOfPaper;
        self.serialNumber   = targetSerialNumber;
        self.customPaperFilePath = targetCustomPaperFilePath;
    }
    
    return self;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    if (
        [key isEqualToString:@"communicationResultForBT"]   ||
        [key isEqualToString:@"isExecutingForBT"]           ||
        [key isEqualToString:@"isFinishedForBT"])
    {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)start
{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.isExecutingForBT = YES;
    
    [self.ptp setupForBluetoothDeviceWithSerialNumber:self.serialNumber];

    if ([self.ptp isPrinterReady])
    {
        self.communicationResultForBT = [self.ptp startCommunication];
        if (self.communicationResultForBT)
        {
            [self.ptp setPrintInfo:self.printInfo];
            [self.ptp setCustomPaperFile:self.customPaperFilePath];
            
            NSString *selectedPDFFilePath = [userDefaults objectForKey:kSelectedPDFFilePath];
            int printResult = 0;
            if (![selectedPDFFilePath isEqualToString:@"0"]){
                NSUInteger length = 0;
                NSUInteger pageIndexes[] = {0};
//                int copies = 1;
                printResult = [self.ptp printPDFAtPath:selectedPDFFilePath pages:pageIndexes length:length copy:self.numberOfPaper];
            }
            else{
                printResult = [self.ptp printImage:self.imgRef copy:self.numberOfPaper];
            }
            [userDefaults setObject:[NSString stringWithFormat:@"%d", printResult] forKey:kPrintResultForBT];
            [userDefaults synchronize];
            if (printResult == 0){
                PTSTATUSINFO resultstatus;
                BOOL result = [self.ptp getPTStatus:&resultstatus];
                if (result) {
                    [userDefaults setObject:[NSString stringWithFormat:@"%d", resultstatus.byFiller] forKey:kPrintStatusBatteryPowerForBT];
                    [userDefaults synchronize];
                }
                else if (!result) {
                    // Error
                }
            }
            if ([self.delegate respondsToSelector:@selector(showPrintResultForBluetooth)]) {
                [self.delegate showPrintResultForBluetooth];
            }
        }
        
        [self.ptp endCommunication];

    }
    else
    {
        self.communicationResultForBT = NO;
    }
    
    self.isExecutingForBT = NO;
    self.isFinishedForBT = YES;
}

@end
