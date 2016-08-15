//
//  PYVennSeries.h
//  iOS-Echarts
//
//  Created by Pluto Y on 4/21/16.
//  Copyright © 2016 Pluto-y. All rights reserved.
//

#import "PYSeries.h"

@class PYItemStyle;

@interface PYVennSeriesData : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) PYItemStyle *itemStyle;

@end

/**
 *
 *  You can goto this website for references:
 *  http://echarts.baidu.com/echarts2/doc/doc.html#SeriesVenn
 *
 */
@interface PYVennSeries : PYSeries

@end
