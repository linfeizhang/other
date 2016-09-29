//
//  ZLF_MapView.m
//  MapDemo
//
//  Created by inhandnetworks on 16/9/29.
//  Copyright © 2016年 inhandnetworks. All rights reserved.
//

#import "ZLF_MapView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@implementation ZLF_MapView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        BMKMapView * mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:mapView];
    }
    return self;
}

@end
