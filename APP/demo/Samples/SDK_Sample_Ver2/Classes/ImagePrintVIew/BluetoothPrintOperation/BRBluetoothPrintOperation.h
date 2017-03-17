//
//  BRBluetoothPrintOperation.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/08/18.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRPtouchPrinterKit.h"

@protocol BRBluetoothPrintOperationDelegate <NSObject>
- (void) showPrintResultForBluetooth;
@end

@interface BRBluetoothPrintOperation : NSOperation
{
}
@property (nonatomic, weak)id<BRBluetoothPrintOperationDelegate> delegate;
@property(nonatomic, assign) BOOL communicationResultForBT;

- (id)initWithOperation:(BRPtouchPrinter *)targetPtp
              printInfo:(BRPtouchPrintInfo *)targetPrintInfo
                 imgRef:(CGImageRef)targetImgRef
          numberOfPaper:(int)targetNumberOfPaper
           serialNumber:(NSString *)targetSerialNumber
        customPaperFile:(NSString *)targetCustomPaperFilePath;
@end
