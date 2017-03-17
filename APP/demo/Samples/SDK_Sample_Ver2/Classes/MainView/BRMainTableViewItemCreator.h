//
//  BRMainTableViewItemCreator.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/04/20.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ImagePrint = 1,
    SendData,
    Utility,
    Info
} BRMainTableViewItemEnum;

@interface BRMainTableViewItemCreator : NSObject
{
}

- (NSMutableArray *)createMainTableViewItems;

@end
