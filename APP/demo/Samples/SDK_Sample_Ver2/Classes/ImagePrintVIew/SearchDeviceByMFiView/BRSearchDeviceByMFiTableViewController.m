//
//  SearchDeviceByMFiTableViewController.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/06/24.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import "UserDefaults.h"
#import "BRSearchDeviceByMFiTableViewController.h"
#import <BRPtouchPrinterKit/BRPtouchBluetoothManager.h>
#import <BRPtouchPrinterKit/BRPtouchDeviceInfo.h>

@interface BRSearchDeviceByMFiTableViewController ()

@end

@implementation BRSearchDeviceByMFiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *pairingButton = [[UIBarButtonItem alloc] initWithTitle:@"Pairing" style:UIBarButtonItemStylePlain target:self action:@selector(pairing)];
    [self.navigationItem setRightBarButtonItem:pairingButton];
	
	[[BRPtouchBluetoothManager sharedManager] registerForBRDeviceNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidConnect:) name:BRDeviceDidConnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:BRDeviceDidDisconnectNotification object:nil];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)_accessoryDidDisconnect:(NSNotification *)notification
{
	
	BRPtouchDeviceInfo *disconnectedAccessory = [[notification userInfo] objectForKey:BRDeviceKey];
	NSLog(@"DisconnectedDevice:[%@]",[disconnectedAccessory description]);
    
    [self.tableView reloadData];
}

- (void)_accessoryDidConnect:(NSNotification *)notification
{
	
	BRPtouchDeviceInfo *connectedAccessory = [[notification userInfo] objectForKey:BRDeviceKey];
	NSLog(@"ConnectedDevice:[%@]",[connectedAccessory description]);
    
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pairing {
    
    [[BRPtouchBluetoothManager sharedManager] brShowBluetoothAccessoryPickerWithNameFilter:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[BRPtouchBluetoothManager sharedManager] pairedDevices].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"cellForRowAtIndexPath");
	static NSString *eaAccessoryCellIdentifier = @"brotherDeviceCellIdentifier";
	NSUInteger row = [indexPath row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eaAccessoryCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:eaAccessoryCellIdentifier];
	}
    
    NSArray *deviceList = [[[BRPtouchBluetoothManager sharedManager] pairedDevices] copy];
	
	NSString *brotherDeviceName = [(BRPtouchDeviceInfo *)[deviceList objectAtIndex:row] strModelName];
	if (!brotherDeviceName || [brotherDeviceName isEqualToString:@""]) {
		brotherDeviceName = @"unknown";
	}
	
	[[cell textLabel] setText:brotherDeviceName];
	[[cell detailTextLabel] setText:[(BRPtouchDeviceInfo *)[deviceList objectAtIndex:row] strSerialNumber]];
	
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	
	BRPtouchDeviceInfo *_selectedAccessory = (BRPtouchDeviceInfo *)[[[BRPtouchBluetoothManager sharedManager] pairedDevices] objectAtIndex:row];
	
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_selectedAccessory.strModelName     forKey:kSelectedDevice];
    [userDefaults setObject:_selectedAccessory.strSerialNumber  forKey:kSerialNumber];
    [userDefaults setObject:@""                                forKey:kIPAddress];
    
    [userDefaults setObject:@"0" forKey:kIsWiFi];
    [userDefaults setObject:@"1" forKey:kIsBluetooth];
    [userDefaults setObject:@"Search device from Wi-Fi"         forKey:kSelectedDeviceFromWiFi];
    [userDefaults setObject:_selectedAccessory.strModelName     forKey:kSelectedDeviceFromBluetooth];
    [userDefaults synchronize];
    
	/* Store Model Name and Serial Number */
	NSLog(@"Accessory.name[%@]"         ,_selectedAccessory.strModelName);
	NSLog(@"Accessory.serialNumber[%@]" ,_selectedAccessory.strSerialNumber);
	
	[[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end