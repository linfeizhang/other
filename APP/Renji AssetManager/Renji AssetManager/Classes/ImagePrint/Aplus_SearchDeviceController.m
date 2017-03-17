//
//  Aplus_SearchDeviceController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/9.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_SearchDeviceController.h"

#import "UserDefaults.h"

#import <BRPtouchPrinterKit/BRPtouchDeviceInfo.h>

@interface Aplus_SearchDeviceController ()

@end

@implementation Aplus_SearchDeviceController
{
    NSMutableArray *_brotherDeviceList;
    BRPtouchNetworkManager	*_networkManager;
    UIActivityIndicatorView	*_indicator;
    UIView *_loadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _brotherDeviceList = [[NSMutableArray alloc] initWithCapacity:0];
    
    _networkManager = [[BRPtouchNetworkManager alloc] init];
    _networkManager.delegate = self;
    
    // Set search mode.
    switch (self.mSearchMode)
    {
        case BRSearchModeIPv6IPv4:
            _networkManager.isEnableIPv6Search = YES;
            break;
            
        case BRSearchModeIPv4:
        default:
            _networkManager.isEnableIPv6Search = NO;
            break;
    }
    
    NSString *	path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if( path )
    {
        NSDictionary *printerDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *printerList = [[NSArray alloc] initWithArray:printerDict.allKeys];
        [_networkManager setPrinterNames:printerList];
    }
    
    //	Start printer search
    [_networkManager startSearch: 5.0];
    
    //	Create indicator View
    _loadingView = [[UIView alloc] initWithFrame:[self.parentViewController.view bounds]];
    [_loadingView setBackgroundColor:[UIColor blackColor]];
    [_loadingView setAlpha:0.5];
    [self.parentViewController.view addSubview:_loadingView];
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.frame = CGRectMake(SCREENWIDTH/2-20, SCREENHEIGHT/2-20, 40.0, 40.0);
    [self.parentViewController.view addSubview:_indicator];
    
    //	Start indicator animation
    [_indicator startAnimating];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _brotherDeviceList.count;
}

////////////////////////////////////////////////////////////////////////////////////
//
//	BRPtouchNetwork delegate method
//
////////////////////////////////////////////////////////////////////////////////////
-(void)didFinishSearch:(id)sender
{
    NSLog(@"didFinishedSearch");
    
    [_indicator stopAnimating];          //  stop indicator animation
    [_indicator removeFromSuperview];    //  remove indicator view (indicator)
    [_loadingView removeFromSuperview];  //  remove indicator view (view)
    
    //  get BRPtouchNetworkInfo Class list
    [_brotherDeviceList removeAllObjects];
    _brotherDeviceList = (NSMutableArray*)[_networkManager getPrinterNetInfo];
    
    NSLog(@"_brotherDeviceList [%@]",_brotherDeviceList);
    
    // reload TableView
    [self.tableView reloadData];
    
    return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellForRowAtIndexPath");
    static NSString *eaAccessoryCellIdentifier = @"brotherDeviceCellIdentifier";
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eaAccessoryCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:eaAccessoryCellIdentifier];
    }
    
    NSString *brotherDeviceName = [(BRPtouchDeviceInfo *)[_brotherDeviceList objectAtIndex:row] strModelName];
    if (!brotherDeviceName || [brotherDeviceName isEqualToString:@""]) {
        brotherDeviceName = @"unknown";
    }
    
    [[cell textLabel] setText:brotherDeviceName];
    [[cell detailTextLabel] setText:[(BRPtouchDeviceInfo *)[_brotherDeviceList objectAtIndex:row] strIPAddress]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    BRPtouchDeviceInfo *_selectedAccessory = (BRPtouchDeviceInfo *)[_brotherDeviceList objectAtIndex:row];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_selectedAccessory.strModelName forKey:kSelectedDevice];
    [userDefaults setObject:_selectedAccessory.strIPAddress forKey:kIPAddress];
    [userDefaults setObject:@"0"                            forKey:kSerialNumber];
    
    [userDefaults setObject:@"1" forKey:kIsWiFi];
    [userDefaults setObject:@"0" forKey:kIsBluetooth];
    [userDefaults setObject:_selectedAccessory.strModelName forKey:kSelectedDeviceFromWiFi];
    [userDefaults setObject:@"Search device from Bluetooth" forKey:kSelectedDeviceFromBluetooth];
    
    [userDefaults synchronize];
    
    /* Store Model Name and Serial Number */
    NSLog(@"Accessory.name[%@]" ,_selectedAccessory.strModelName);
    NSLog(@"Accessory.IP[%@]"   ,_selectedAccessory.strIPAddress);
    
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
