//
//  PYPieSeries.m
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/10/3.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import "PYPieSeries.h"

PYPieSeriesRoseType const PYPieSeriesRoseTypeRadius = @"radius";
PYPieSeriesRoseType const PYPieSeriesRoseTypeArea   = @"area";

static NSArray<PYPieSeriesRoseType> *pieSeriesRoleTypeScope;
@implementation PYPieSeries

+ (void)initialize
{
    if (self == [PYPieSeries class]) {
        pieSeriesRoleTypeScope = @[PYPieSeriesRoseTypeRadius, PYPieSeriesRoseTypeArea];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _center = @[@"50%", @"50%"];
        _radius = @[@"0", @"75%"];
        _startAngle = @(90);
        _minAngle = @(0);
        _clockWise = YES;
        _selectedMode = @(10);
        _legendHoverLink = YES;
    }
    return self;
}

- (void)setRoseType:(PYPieSeriesRoseType)roseType {
    if (roseType != nil && ![pieSeriesRoleTypeScope containsObject:roseType]) {
        NSLog(@"ERROR: PYPieSeries does not support roseType --- %@", roseType);
        _roseType = nil;
        return;
    }
    _roseType = [roseType copy];
}

@end
