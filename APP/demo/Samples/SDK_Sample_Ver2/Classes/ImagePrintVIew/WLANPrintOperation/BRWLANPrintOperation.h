//
//  BRWLANPrintOperation.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/08/18.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRPtouchPrinterKit.h"

@protocol BRWLANPrintOperationDelegate <NSObject>
- (void) showPrintResultForWLAN;
@end

@interface BRWLANPrintOperation : NSOperation
{
}
@property (nonatomic, weak)id<BRWLANPrintOperationDelegate> delegate;
@property(nonatomic, assign) BOOL communicationResultForWLAN;

- (id)initWithOperation:(BRPtouchPrinter *)targetPtp
              printInfo:(BRPtouchPrintInfo *)targetPrintInfo
                 imgRef:(CGImageRef)targetImgRef
          numberOfPaper:(int)targetNumberOfPaper
              ipAddress:(NSString *)targetIPAddress
        customPaperFile:(NSString *)targetCustomPaperFilePath;
@end

