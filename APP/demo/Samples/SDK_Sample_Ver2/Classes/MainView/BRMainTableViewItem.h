//
//  BRMainTableViewItem.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/04/20.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRMainTableViewItem : NSObject
{
}

@property(nonatomic, strong) NSNumber *itemID;
@property(nonatomic, strong) UIImage  *image;
@property(nonatomic, strong) UIImage  *highlightedImage;
@property(nonatomic, strong) NSString *labelName;

@end
