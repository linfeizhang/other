//
//  BRMainTableViewItemCreator.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/04/20.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import "UserDefaults.h"

#import "BRMainTableViewItemCreator.h"
#import "BRMainTableViewItem.h"

@interface BRMainTableViewItemCreator ()
{
}
@property(nonatomic, strong) NSMutableArray *itemsArray;
@end

@implementation BRMainTableViewItemCreator

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (NSMutableArray *)createMainTableViewItems {
    self.itemsArray = [[NSMutableArray alloc] init];
    
    if (self.itemsArray)
    {
        BRMainTableViewItem *itemForPrintImage = [[BRMainTableViewItem alloc] init];
        itemForPrintImage.itemID             = [NSNumber numberWithInteger:ImagePrint];
        itemForPrintImage.image              = [UIImage imageNamed:@"BlocklistImg.png"];
        itemForPrintImage.highlightedImage   = [UIImage imageNamed:@"BlocklistImgPress.png"];
        itemForPrintImage.labelName          = NSLocalizedString(@"Print", nil);
        [self.itemsArray addObject:itemForPrintImage];
        
        BRMainTableViewItem *itemForSendData = [[BRMainTableViewItem alloc] init];
        itemForSendData.itemID             = [NSNumber numberWithInteger:SendData];
        itemForSendData.image              = [UIImage imageNamed:@"clipboardPrintIcon.png"];
        itemForSendData.highlightedImage   = [UIImage imageNamed:@"clipboardPrintIconPress.png"];
        itemForSendData.labelName          = NSLocalizedString(@"Send Data", nil);
        [self.itemsArray addObject:itemForSendData];
        
        BRMainTableViewItem *itemForUtility = [[BRMainTableViewItem alloc] init];
        itemForUtility.itemID             = [NSNumber numberWithInteger:Utility];
        itemForUtility.image              = [UIImage imageNamed:@"PrintGeneral.png"];
        itemForUtility.highlightedImage   = [UIImage imageNamed:@"PrintGeneralPress.png"];
        itemForUtility.labelName          = NSLocalizedString(@"Utility", nil);
        [self.itemsArray addObject:itemForUtility];
        
        /*
        BRMainTableViewItem *itemForInfo = [[BRMainTableViewItem alloc] init];
        itemForInfo.itemID             = [NSNumber numberWithInteger:Info];
        itemForInfo.image              = [UIImage imageNamed:@"infomationIcon.png"];
        itemForInfo.highlightedImage   = [UIImage imageNamed:@"infomationIconPress.png"];
        itemForInfo.labelName          = NSLocalizedString(@"Infomation", nil);
        [self.itemsArray addObject:itemForInfo];
        */
    }
    
    return self.itemsArray;
}

@end
