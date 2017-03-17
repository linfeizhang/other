//
//  BRMainViewCellTableViewCell.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/04/20.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRMainTableViewCell : UITableViewCell
{
}

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, strong) NSNumber *cellID;
@end
