//
//  Aplus_RepairSiftView.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/15.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Aplus_RepairModel;
@protocol Aplus_RepairSiftViewDelegate <NSObject>
//- (void)siftConditionViewWithAlert;
- (void)beginSearch:(Aplus_RepairModel *)message;
@end

@interface Aplus_RepairSiftView : UIView
@property (nonatomic, weak) id<Aplus_RepairSiftViewDelegate>delegate;
@property (strong, nonatomic) Aplus_RepairModel * message;


@property (weak, nonatomic) IBOutlet UIView *backgroudView;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property (weak, nonatomic) IBOutlet UILabel *assetNoLabel;
@property (weak, nonatomic) IBOutlet UITextField *assetNo;
@property (weak, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *assetName;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UITextField *orderStatus;
@property (weak, nonatomic) IBOutlet UIButton *search;
@end
