//
//  ZLF_FirstViewController.m
//  MapDemo
//
//  Created by inhandnetworks on 16/9/29.
//  Copyright © 2016年 inhandnetworks. All rights reserved.
//

#import "ZLF_FirstViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface ZLF_FirstViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate>
{
    BMKPinAnnotationView * newAnnotation;
    BMKGeoCodeSearch * _geoCodeSearch;
    BMKReverseGeoCodeOption * _reverseGeoCodeOption;
}
/***********************************  UI  ****************************************/
@property (weak, nonatomic) IBOutlet BMKMapView * mapView;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;

@property (weak, nonatomic) IBOutlet UITextField * city;
@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapType;

@property (weak, nonatomic) IBOutlet UISwitch * trafficEnabled;
/***********************************  data  ****************************************/
@property (strong, nonatomic) BMKLocationService * localService;

@end

@implementation ZLF_FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView.mapType = BMKMapTypeSatellite;
    [_mapView setZoomLevel:10];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _longitude.text = @"116.403981";
    _latitude.text = @"39.915101";
    _city.text = @"北京";
    _address.text = @"海淀区上地十街10号";
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geoCodeSearch.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geoCodeSearch.delegate = nil;
}
- (void)dealloc {
    if (_geoCodeSearch != nil) {
        _geoCodeSearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
#pragma mark /************ 根据annotation生成对应的View ************/
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    NSString * annotationViewID = @"annotationViewID";
    BMKPinAnnotationView * annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationViewID];
        annotationView.pinColor = BMKPinAnnotationColorRed;
        annotationView.animatesDrop = YES;
    }
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height/2));
    annotationView.annotation = annotation;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    view.backgroundColor = [UIColor greenColor];
    [annotationView.paopaoView addSubview:view];//= [[BMKActionPaopaoView alloc]initWithCustomView:view];
    annotationView.canShowCallout = YES;
    return annotationView;
}
#pragma mark /************ 正向地理编码 ************/
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation * item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        
        NSString * titleStr = @"正向地理编码";
        NSString * showmeg = [NSString stringWithFormat:@"纬度:%f,经度:%f",item.coordinate.latitude,item.coordinate.longitude];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}
#pragma mark /************ 反向地理编码 ************/
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
//    NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation * item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        
        NSString * titleStr = @"反向地理编码";
        NSString * showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}


- (IBAction)zhengXiangBianMa:(id)sender {
    BMKGeoCodeSearchOption * geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city = _city.text;
    geocodeSearchOption.address = _address.text;
    NSLog(@"%@",geocodeSearchOption.address);
    BOOL flag = [_geoCodeSearch geoCode:geocodeSearchOption];
    if (flag) {
        NSLog(@"geo检所发送成功");
    }else{
        NSLog(@"geo检所发送失败");
    }
}

- (IBAction)fanXiangBianMa:(id)sender {
    CLLocationCoordinate2D localCoor = (CLLocationCoordinate2D){0,0};
    if (_latitude.text !=nil && _longitude != nil) {
        localCoor = (CLLocationCoordinate2D){[_latitude.text floatValue],[_longitude.text floatValue]};
    }
    BMKReverseGeoCodeOption * reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeOption.reverseGeoPoint = localCoor;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    if (flag) {
        NSLog(@"反geo检所发送成功");
    }else{
        NSLog(@"反geo检所发送失败");
    }
}


- (IBAction)changeMapType:(id)sender {
    if (_mapType.selectedSegmentIndex == 0) {
        _mapView.mapType = BMKMapTypeNone;
    }else if (_mapType.selectedSegmentIndex == 1){
        _mapView.mapType = BMKMapTypeStandard;
    }else{
        _mapView.mapType = BMKMapTypeSatellite;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}













- (IBAction)setTrafficEnabled:(id)sender {
    NSLog(@"%d",[_trafficEnabled isOn]);
    
    if ([_trafficEnabled isOn])
        [_mapView setTrafficEnabled:NO];
    else
        [_mapView setTrafficEnabled:NO];
}

@end
