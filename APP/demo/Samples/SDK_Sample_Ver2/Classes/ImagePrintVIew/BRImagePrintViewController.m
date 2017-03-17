//
//  BRImagePrintViewController.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/06/15.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import "BRPtouchPrinterKit.h"

#import "UserDefaults.h"
#import "BRImagePrintViewController.h"
#import "BRImagePrintTablesViewItem.h"
#import "BRImagePrintTablesViewItemCreator.h"
#import "BRWLANPrintOperation.h"
#import "BRBluetoothPrintOperation.h"
#import "BRPrintResultViewController.h"
#import "BRPDFPickerVIewController.h"

#define kSearchDeviceByWiFiSegue    @"searchDeviceByWiFiSegue"
#define kSearchDeviceByMFiSegue     @"searchDeviceByMFiSegue"
#define kPrintSettingsSegue         @"printSettingsSegue"

@interface BRImagePrintViewController ()
{
	BRPtouchPrinter	*_ptp;
}
@property(nonatomic, weak) IBOutlet UIImageView     *selectedImageView;
@property(nonatomic, weak) IBOutlet UITableView     *deviceSearchTableView;
@property(nonatomic, weak) IBOutlet UITableView     *rootPrintSettingTableView;

@property(nonatomic, strong) BRPDFPickerViewController *pdfPickerViewController;

@property(nonatomic, strong) BRImagePrintTablesViewItemCreator *imagePrintTablesViewItemCreator;
@property(nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) BRPrintResultViewController *printResultViewController;

@property(nonatomic, strong) NSString *bytesWrittenMessage;
@property(nonatomic, strong) NSNumber *bytesWritten;
@property(nonatomic, strong) NSNumber *bytesToWrite;
@end

@implementation BRImagePrintViewController

- (void) initWithUserDefault
{
    // "UserDefault" Initialize
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaults   = [NSMutableDictionary dictionary];
    
    [userDefaults removeObjectForKey:kPrintCustomPaperKey];
    [userDefaults removeObjectForKey:kSelectedPDFFilePath];
    [userDefaults synchronize];
    
    [defaults setObject:@""                                                 forKey:kExportPrintFileNameKey];
    [defaults setObject:@"1"                                                forKey:kPrintNumberOfPaperKey];
    [defaults setObject:[self defaultPaperSize]                             forKey:kPrintPaperSizeKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Landscape]        forKey:kPrintOrientationKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Original]         forKey:kScalingModeKey];
    [defaults setObject:@"0.5"                                              forKey:kScalingFactorKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", Binary]           forKey:kPrintHalftoneKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Left]             forKey:kPrintHorizintalAlignKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Top]              forKey:kPrintVerticalAlignKey];
    //[defaults setObject:[NSString stringWithFormat:@"%d", PaperLeft]        forKey:kPrintPaperAlignKey];
    
    // nExtFlag
    [defaults setObject:[NSString stringWithFormat:@"%d", CodeOff]          forKey:kPrintCodeKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", CarbonOff]        forKey:kPrintCarbonKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", DashOff]          forKey:kPrintDashKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", NoFeed]           forKey:kPrintFeedModeKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", CurlModeOff]      forKey:kPrintCurlModeKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Fast]             forKey:kPrintSpeedKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", BidirectionOn]    forKey:kPrintBidirectionKey];
    [defaults setObject:@"0"                                                forKey:kPrintFeedMarginKey];
    [defaults setObject:@"200"                                              forKey:kPrintCustomLengthKey];
    [defaults setObject:@"80"                                               forKey:kPrintCustomWidthKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", AutoCutOff]       forKey:kPrintAutoCutKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", CutAtEndOff]      forKey:kPrintCutAtEndKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", HalfCutOff]       forKey:kPrintHalfCutKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", SpecialTapeOff]   forKey:kPrintSpecialTapeKey];
    
    [defaults setObject:@""                                    forKey:kPrintCustomPaperKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", RotateOff]        forKey:kRotateKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", PeelOff]          forKey:kPeelKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", CutMarkOff]       forKey:kPrintCutMarkKey];
    [defaults setObject:@"0"                                                forKey:kPrintLabelMargineKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", DensityMax5Level1]    forKey:kPrintDensityMax5Key];
    [defaults setObject:[NSString stringWithFormat:@"%d", DensityMax10Level6]   forKey:kPrintDensityMax10Key];
    
    [defaults setObject:@"0"     forKey:kPrintTopMarginKey];
    [defaults setObject:@"0"     forKey:kPrintLeftMarginKey];
    
    [defaults setObject:@"No Selected"                                      forKey:kSelectedDevice];
    [defaults setObject:@""                                                forKey:kIPAddress];
    [defaults setObject:@"0"                                                forKey:kSerialNumber];
    [defaults setObject:@"Search device from Wi-Fi"                         forKey:kSelectedDeviceFromWiFi];
    [defaults setObject:@"Search device from Bluetooth"                     forKey:kSelectedDeviceFromBluetooth];
    
    [defaults setObject:@"0"                                                forKey:kIsWiFi];
    [defaults setObject:@"0"                                                forKey:kIsBluetooth];
    
    [defaults setObject:@"0"                                                forKey:kSelectedPDFFilePath];
    
    [userDefaults registerDefaults:defaults];
}

- (NSString *)defaultPaperSize
{
    NSString *result = nil;
    
#warning Temp "Brother PJ-673"
    NSString *pathInPrintSettings   = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if (pathInPrintSettings) {
        NSDictionary *priterListArray = [NSDictionary dictionaryWithContentsOfFile:pathInPrintSettings];
        if (priterListArray) {
            result = [[[priterListArray objectForKey:@"Brother PJ-673"] objectForKey:@"PaperSize"] objectAtIndex:0];
        }
    }
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithUserDefault];
    
    self.selectedImageView.image = nil;
    self.imagePrintTablesViewItemCreator = [[BRImagePrintTablesViewItemCreator alloc] init];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.imagePickerController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedPDFFilePath = [userDefaults objectForKey:kSelectedPDFFilePath];
    if (![selectedPDFFilePath isEqualToString:@"0"])
    {
        UIImage *image = [self previewImageFromPDF:selectedPDFFilePath];
        self.selectedImageView.image = image;
        [self.selectedImageView reloadInputViews];
    }
    
    NSIndexPath *selectedSearchTableRow = [self.deviceSearchTableView indexPathForSelectedRow];
    [self.deviceSearchTableView deselectRowAtIndexPath:selectedSearchTableRow animated:NO];
    
    NSIndexPath *selectedPrintTableRow = [self.rootPrintSettingTableView indexPathForSelectedRow];
    [self.rootPrintSettingTableView deselectRowAtIndexPath:selectedPrintTableRow animated:NO];
    
    [self.deviceSearchTableView     reloadData];
    [self.rootPrintSettingTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImage *)previewImageFromPDF:(NSString *)pdfPath
{
    UIImage *image = nil;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:pdfPath]];
    CFDataRef dataRef = (__bridge CFDataRef)data;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(dataRef);
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);
    CGDataProviderRelease(provider);
    CGPDFPageRef firstPageRef = CGPDFDocumentGetPage(pdf, 1);
    CGRect mediarect = CGPDFPageGetBoxRect(firstPageRef, kCGPDFMediaBox);
    CGFloat scale = 600.0/mediarect.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(600.0, mediarect.size.height*scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillRect(context, mediarect);
    CGContextTranslateCTM(context, 0.0, mediarect.size.height*scale);
    CGContextScaleCTM(context, 1.0*scale, -1.0*scale);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    CGContextDrawPDFPage(context, firstPageRef);
    image = UIGraphicsGetImageFromCurrentImageContext();
    CGPDFDocumentRelease(pdf);
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Table View <Delegate Method>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = 0;
    
    if (tableView.tag == 1) {
        numberOfSections = 2;
    }
    else if (tableView.tag == 2) {
        numberOfSections = 1;
    }
    
    return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BRImagePrintTablesViewItem *item = [self.imagePrintTablesViewItemCreator selectedImagePrintTablesViewItem:tableView.tag
                                                                                                 tableSection:section];
    return item.sectionLabelName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (tableView.tag == 1) {
        numberOfRows = 1;
    }
    else if (tableView.tag == 2) {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRImagePrintTablesViewItem *item = [self.imagePrintTablesViewItemCreator selectedImagePrintTablesViewItem:tableView.tag
                                                                                                 tableSection:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:item.cellID];
    }
    cell.textLabel.text = item.cellLabelName;
    cell.detailTextLabel.text = item.cellLabelDetailName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        switch (indexPath.section) {
            case 0:
                NSLog(@"[Push] search device by Wi-Fi");
                break;
            case 1:
                NSLog(@"[Push] search device by MFi");
                break;
            default:
                //Error
                break;
        }
    }
    else if (tableView.tag == 2) {
        switch (indexPath.section) {
            case 0:
                NSLog(@"[Push] root print setting");
                break;
                
            default:
                //Error
                break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSearchDeviceByWiFiSegue]) {
        NSLog(@"[Segue] search device by Wi-Fi");
    }
    else if ([segue.identifier isEqualToString:kSearchDeviceByMFiSegue]) {
        NSLog(@"[Segue] search device by MFi");
    }
    else if ([segue.identifier isEqualToString:kPrintSettingsSegue]) {
        NSLog(@"[Segue] print settings");
    }
}

- (void) prepareForPtp
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    
    CONNECTION_TYPE type = CONNECTION_TYPE_WLAN;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1){
        type = CONNECTION_TYPE_BLUETOOTH;
            selectedDevice = [NSString stringWithFormat:@"Brother %@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0){
        type = CONNECTION_TYPE_WLAN;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
    }
    else{
        type = CONNECTION_ERROR;
    }
    
    if (selectedDevice) {
        _ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
        switch (type) {
            case CONNECTION_TYPE_BLUETOOTH:
                 [_ptp setupForBluetoothDeviceWithSerialNumber:[userDefaults objectForKey:kSerialNumber]];
            break;
            case CONNECTION_TYPE_WLAN:
                [_ptp setIPAddress:[userDefaults objectForKey:kIPAddress]];
            break;
            case CONNECTION_ERROR:
                // Error
            break;
            default:
            break;
        }
    }
}

- (void) prepareForPrintResultViewControllerNavigationItems
{
    self.printResultViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"printResultViewController"];
    
    UIBarButtonItem *doneButton;
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                               target:self
                                                               action:@selector(dismissModalView)];
    
    UIBarButtonItem *cancelButton;
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(cancelPrint)];
    
    self.printResultViewController.navigationItem.leftBarButtonItem = doneButton;
    self.printResultViewController.navigationItem.rightBarButtonItem = cancelButton;
    self.printResultViewController.img = self.selectedImageView.image;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.printResultViewController];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)dismissModalView {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cancelPrint {
    NSLog(@"*** Cancel Print ***");
    [_ptp cancelPrinting];
}

#pragma mark - Image Picker <Delegate Method>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"0" forKey:kSelectedPDFFilePath];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.selectedImageView.image = image;
    [self.selectedImageView reloadInputViews];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBAction

- (IBAction)imageSelectButton:(id)sender {
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)pdfButton:(id)sender{
    self.pdfPickerViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"pdfPickerViewController"];

    UIBarButtonItem *cancelButton;
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(dismissModalView)];
    
    self.pdfPickerViewController.navigationItem.rightBarButtonItem = cancelButton;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.pdfPickerViewController];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (IBAction)printButton:(id)sender
{
    [self prepareForPtp];
    if (_ptp)
    {
        if ([_ptp isPrinterReady]){
            [self prepareForPrintResultViewControllerNavigationItems];
        }
        else {
            // Connection Error
            [self showConnectionErrorAlert];
        }
    }
}

- (void) showConnectionErrorAlert
{
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(osVersion >= 8.0f) {
        UIAlertController * alertController =
        [UIAlertController alertControllerWithTitle:@"Error"
                                            message:@"Communication Error"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (osVersion < 8.0f && osVersion >= 6.0f) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Communication Error"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        // Non Support
    }
}

@end
