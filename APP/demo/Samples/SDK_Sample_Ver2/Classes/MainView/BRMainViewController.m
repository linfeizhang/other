//
//  ViewController.m
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/04/20.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This class maid in ARC.
#endif

#import "UserDefaults.h"

#import "BRMainViewController.h"
#import "BRMainTableViewCell.h"
#import "BRMainTableViewItem.h"
#import "BRMainTableViewItemCreator.h"
#import "BRImagePrintViewController.h"
#import "BRSendDataViewController.h"
#import "BRUtilityViewController.h"

@interface BRMainViewController ()
{
}
@property (nonatomic, weak) IBOutlet UILabel        *mainViewTitle;
@property (nonatomic, weak) IBOutlet UITableView    *mainTableView;

@property (nonatomic, strong) NSMutableArray *mainTableViewItemArray;
@property (nonatomic, strong) BRMainTableViewItemCreator *mainTableViewItemCreator;

// for Image
@property (nonatomic, strong) UIStoryboard *imagePrintViewStoryboard;
@property (nonatomic, strong) BRImagePrintViewController *imagePrintViewController;

// for Send Data
@property (nonatomic, strong) UIStoryboard *sendDataViewStoryboard;
@property (nonatomic, strong) BRSendDataViewController *sendDataViewController;

// for Utility
@property (nonatomic, strong) UIStoryboard *utilityViewStoryboard;
@property (nonatomic, strong) BRUtilityViewController *utilityViewController;

@end

@implementation BRMainViewController

#pragma mark - Common Class Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTableViewItemArray     = [[NSMutableArray alloc] init];
    self.mainTableViewItemCreator   = [[BRMainTableViewItemCreator alloc] init];
    
    UINib * nibForTable = [UINib nibWithNibName:@"BRMainTableViewCell" bundle:nil];
    [self.mainTableView registerNib:nibForTable forCellReuseIdentifier:@"mainTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mainViewTitle.text = @"iOS SDK Sample Ver.2";
    self.mainViewTitle.font = [UIFont systemFontOfSize:22.0];
    self.mainViewTitle.textColor = [UIColor blueColor];
    
    if (self.mainTableViewItemArray){
        [self loadToMainTableView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Class Method

- (void)loadToMainTableView {
    [self.mainTableViewItemArray removeAllObjects];
    
    if (self.mainTableViewItemCreator){
        NSMutableArray *creatorArray = [self.mainTableViewItemCreator createMainTableViewItems];
        for (BRMainTableViewItem *item in [creatorArray objectEnumerator]){
            [self.mainTableViewItemArray addObject:item];
        }
    }
    [self.mainTableView reloadData];
}

#pragma mark - TableView <Delegate Method>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    
    if (self.mainTableViewItemArray){
        count = [self.mainTableViewItemArray count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainTableViewCell"
                                                                forIndexPath:indexPath];
    
    if (cell){
        BRMainTableViewItem *item = [self.mainTableViewItemArray objectAtIndex:indexPath.row];
        cell.cellID = item.itemID;
        cell.image.image = item.image;
        cell.image.highlightedImage = item.highlightedImage;
        cell.label.text  = item.labelName;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BRMainTableViewCell *cell = (BRMainTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    switch ([cell.cellID integerValue])
    {
        case ImagePrint:
            [self imagePrintViewWillLoad];
        break;
            
        case SendData:
            [self sendDataViewWillLoad];
        break;
            
        case Utility:
            [self utilityViewWillLoad];
        break;
            
        case Info:
            NSLog(@"Pushed [Info]");
        break;
            
        default:
        break;
    }
    
    NSIndexPath *selectedRow = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selectedRow animated:YES];
}

- (void)dismissModalView {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePrintViewWillLoad {
    self.imagePrintViewStoryboard = [UIStoryboard storyboardWithName: @"BRImagePrintViewController" bundle: nil];
    self.imagePrintViewController = [self.imagePrintViewStoryboard instantiateViewControllerWithIdentifier: @"imagePrintViewController"];
    
    UIBarButtonItem *cancelButton;
    
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(dismissModalView)];
    
    self.imagePrintViewController.navigationItem.leftBarButtonItem = cancelButton;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.imagePrintViewController];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)sendDataViewWillLoad {
    self.sendDataViewStoryboard = [UIStoryboard storyboardWithName: @"BRSendDataViewController" bundle: nil];
    self.sendDataViewController = [self.sendDataViewStoryboard instantiateViewControllerWithIdentifier: @"sendDataViewController"];
    
    UIBarButtonItem *cancelButton;
    
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(dismissModalView)];
    
    self.sendDataViewController.navigationItem.leftBarButtonItem = cancelButton;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.sendDataViewController];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)utilityViewWillLoad {
    self.utilityViewStoryboard = [UIStoryboard storyboardWithName:@"BRUtilityViewController" bundle:nil];
    self.utilityViewController = [self.utilityViewStoryboard instantiateViewControllerWithIdentifier:@"utilityViewController"];
    
    UIBarButtonItem *cancelButton;
    
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(dismissModalView)];
    
    self.utilityViewController.navigationItem.leftBarButtonItem = cancelButton;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.utilityViewController];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)infoViewWillLoad {
}

@end
