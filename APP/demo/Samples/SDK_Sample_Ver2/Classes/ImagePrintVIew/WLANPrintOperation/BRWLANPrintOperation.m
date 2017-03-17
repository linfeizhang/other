//
//  BRWLANPrintOperation.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/08/18.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import "UserDefaults.h"
#import "BRWLANPrintOperation.h"

@interface BRWLANPrintOperation ()
{
}
@property(nonatomic, assign) BOOL isExecutingForWLAN;
@property(nonatomic, assign) BOOL isFinishedForWLAN;


@property(nonatomic, weak) BRPtouchPrinter    *ptp;
@property(nonatomic, strong) BRPtouchPrintInfo  *printInfo;
@property(nonatomic, assign) CGImageRef         imgRef;
@property(nonatomic, assign) int                numberOfPaper;
@property(nonatomic, strong) NSString           *ipAddress;
@property(nonatomic, strong) NSString           *customPaperFilePath;
@end

@implementation BRWLANPrintOperation

- (id)initWithOperation:(BRPtouchPrinter *)targetPtp
              printInfo:(BRPtouchPrintInfo *)targetPrintInfo
                 imgRef:(CGImageRef)targetImgRef
          numberOfPaper:(int)targetNumberOfPaper
              ipAddress:(NSString *)targetIPAddress
        customPaperFile:targetCustomPaperFilePath


{
    self = [super init];
    if (self) {
        self.ptp            = targetPtp;
        self.printInfo      = targetPrintInfo;
        self.imgRef         = targetImgRef;
        self.numberOfPaper  = targetNumberOfPaper;
        self.ipAddress      = targetIPAddress;
        self.customPaperFilePath = targetCustomPaperFilePath;

    }
    
    return self;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    if ([key isEqualToString:@"communicationResultForWLAN"] ||
        [key isEqualToString:@"isExecutingForWLAN"]         ||
        [key isEqualToString:@"isFinishedForWLAN"]) {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)start
{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.isExecutingForWLAN = YES;
    
    [self.ptp setIPAddress:self.ipAddress];
    
    if ([self.ptp isPrinterReady])
    {
        self.communicationResultForWLAN = [self.ptp startCommunication];
        if (self.communicationResultForWLAN)
        {
            
            [self.ptp setPrintInfo:self.printInfo];
            [self.ptp setCustomPaperFile:self.customPaperFilePath];

            
            NSString *selectedPDFFilePath = [userDefaults objectForKey:kSelectedPDFFilePath];
            int printResult = 0;
            if (![selectedPDFFilePath isEqualToString:@"0"]){
                NSUInteger length = 0;
                NSUInteger pageIndexes[] = {0};
//                int copies = 2;
                printResult = [self.ptp printPDFAtPath:selectedPDFFilePath pages:pageIndexes length:length copy:self.numberOfPaper];
            }
            else{
                printResult = [self.ptp printImage:self.imgRef copy:self.numberOfPaper];
            }
            [userDefaults setObject:[NSString stringWithFormat:@"%d", printResult] forKey:kPrintResultForWLAN];
            [userDefaults synchronize];
            
            PTSTATUSINFO resultstatus;
            BOOL result = [self.ptp getPTStatus:&resultstatus];
            if (result) {
                [userDefaults setObject:[NSString stringWithFormat:@"%d", resultstatus.byFiller] forKey:kPrintStatusBatteryPowerForWLAN];
                [userDefaults synchronize];
            }
            else if (!result) {
                // Error
            }
            if ([self.delegate respondsToSelector:@selector(showPrintResultForWLAN)]) {
                [self.delegate showPrintResultForWLAN];
            }
        }
        [self.ptp endCommunication];

    }
    else
    {
        self.communicationResultForWLAN = NO;
    }
    
    self.isExecutingForWLAN = NO;
    self.isFinishedForWLAN = YES;
}

@end
