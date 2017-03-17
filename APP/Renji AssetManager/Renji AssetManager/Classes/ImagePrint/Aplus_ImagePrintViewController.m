//
//  Aplus_ImagePrintViewController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/9.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//
#import <BRPtouchPrinterKit/BRPtouchPrinterKit.h>
#import "Aplus_ImagePrintViewController.h"
#import "SGQRCodeTool.h"
#import "Aplus_SearchDeviceController.h"

#define kSearchDeviceByWiFiSegue    @"searchDeviceByWiFiSegue"
#define kSearchDeviceByMFiSegue     @"searchDeviceByMFiSegue"
#define kPrintSettingsSegue         @"printSettingsSegue"

@interface Aplus_ImagePrintViewController ()
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIApplicationDelegate,
//UITableViewDataSource,
//UITableViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UITextFieldDelegate
>
{
    BRPtouchPrinter * _ptp;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *printDeviceTextField;

@property (strong, nonatomic) UIImagePickerController * imagePickerController;
@end

@implementation Aplus_ImagePrintViewController
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
    [defaults setObject:[NSString stringWithFormat:@"%d", Fit]              forKey:kScalingModeKey];
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
    
    [defaults setObject:[NSString stringWithFormat:@"%d", AutoCutOn]       forKey:kPrintAutoCutKey];
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
    NSString *pathInPrintSettings   = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if (pathInPrintSettings) {
        NSDictionary *priterListArray = [NSDictionary dictionaryWithContentsOfFile:pathInPrintSettings];
        if (priterListArray) {
            result = [[[priterListArray objectForKey:@"Brother PT-P750W"] objectForKey:@"PaperSize"] objectAtIndex:5];
        }
    }
    return result;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePickerController = [[UIImagePickerController alloc] init];
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.imagePickerController.delegate = self;
    [self setupGenerateQRCode];
    [self initWithUserDefault];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedPDFFilePath = [userDefaults objectForKey:kSelectedPDFFilePath];
    if (![selectedPDFFilePath isEqualToString:@"0"])
    {
        UIImage *image = [self previewImageFromPDF:selectedPDFFilePath];
        self.imageView.image = image;
        [self.imageView reloadInputViews];
    }
    _printDeviceTextField.text = [userDefaults stringForKey:kSelectedDeviceFromWiFi];
    NSLog(@"===========================");
    NSLog(@"itemID = %@",[NSNumber numberWithInteger:searchDeviceForWiFi]);
    NSLog(@"sectionLabelName = %@",NSLocalizedString(@"Wi-Fi", nil));
    NSLog(@"cellID = %@",NSLocalizedString(@"deviceSearchCellForWiFi", nil));
    NSLog(@"cellLabelName = %@",[userDefaults stringForKey:kSelectedDeviceFromWiFi]);
    NSLog(@"cellLabelDetailName = %@",NSLocalizedString(@"", nil));
    NSLog(@"===========================");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_ptp cancelPrinting];
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

#pragma mark /************ 开始打印 ************/
- (IBAction)printButtonAction:(id)sender
{
    [sender setEnabled:NO];
    BRPtouchPrinter * ptp;
    CONNECTION_TYPE type = CONNECTION_ERROR;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedSendDataPath = [userDefaults objectForKey:kSelectedSendDataPath];
    NSString *selectedDevice = nil;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1)
    {
        type = CONNECTION_TYPE_BLUETOOTH;
        selectedDevice = [NSString stringWithFormat:@"Brother %@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
        
        NSString *serialNumber = [userDefaults stringForKey:kSerialNumber];
        if (serialNumber) {
            ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [ptp setupForBluetoothDeviceWithSerialNumber:serialNumber];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0)
    {
        type = CONNECTION_TYPE_WLAN;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
        
        NSString *ipAddress = [userDefaults stringForKey:kIPAddress];
        if (ipAddress) {
            ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [ptp setIPAddress:ipAddress];
        }
    }
    else
    {
        type = CONNECTION_ERROR;
    }
    
    int isSuccess = -1;
    if (type == CONNECTION_ERROR) {
        [self showAlertSendDataResult:isSuccess];
    }else{
        BOOL startCommunicationResult = [ptp startCommunication];
        if (startCommunicationResult) {
            
            BOOL isPDZFile = false;
            BOOL isBLFFile = false;
            if (type == CONNECTION_TYPE_BLUETOOTH) {
                isPDZFile =[selectedSendDataPath hasSuffix:@".pd3"];
            }
            else if (type == CONNECTION_TYPE_WLAN){
                isBLFFile = [selectedSendDataPath hasSuffix:@".blf"];
            }
            
            if (isPDZFile || isBLFFile) {
                isSuccess = [ptp sendTemplate:selectedSendDataPath connectionType:type];
            }else {
                //                isSuccess = [self.ptp sendFile:selectedSendDataPath];
                
                NSData *data = UIImagePNGRepresentation(_imageView.image);
                isSuccess = [ptp sendData:data];
//                isSuccess = [ptp printImage:[_imageView.image CGImage] copy:1];
            }
            [self showAlertSendDataResult:isSuccess];
        }
        
        [ptp endCommunication];
        
    }
    
    [sender setEnabled:YES];
}

- (void)showAlertSendDataResult: (int)isSuccess
{
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    NSString *title = @"Send Result";
    NSString *message = @"";
    if (isSuccess == 0) {
        message = @"Success";
    }else {
        message = @"Failure";
    }
    
    if(osVersion >= 8.0f) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (osVersion < 8.0f && osVersion >= 6.0f) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        // Non Support
    }
}


#pragma mark /************ 扫描 ************/

- (void)setupGenerateQRCode {
    self.imageView.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:_asset_no imageViewWidth:160];
}
- (IBAction)imageSelectAtion:(id)sender {
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
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
    }
}


#pragma mark - Image Picker <Delegate Method>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"0" forKey:kSelectedPDFFilePath];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self.imageView reloadInputViews];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark /************ textField delegate ************/
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    Aplus_SearchDeviceController * searchDeviceController = [[Aplus_SearchDeviceController alloc]init];
    [self.navigationController pushViewController:searchDeviceController animated:YES];
    return NO;
}















@end
