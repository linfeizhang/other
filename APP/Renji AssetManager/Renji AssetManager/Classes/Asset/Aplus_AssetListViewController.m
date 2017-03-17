//
//  Aplus_AssetListViewController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/8.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_AssetListViewController.h"
#import "Aplus_AddAssetViewController.h"
#import "Aplus_AssetDetailViewController.h"
#import "Aplus_AssetCell.h"
#import "Aplus_AssetModel.h"


static NSString * cellIndentify = @"Aplus_AssetCell";
@interface Aplus_AssetListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SGScanningQRCodeVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) UISearchBar * searchBar;

@property (strong, nonatomic) NSMutableArray * assetModelArr;
@property (assign, nonatomic) int pageNumber;
@end

@implementation Aplus_AssetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createNavItems];
    [Aplus_Until startSVP:@"加载中..."];
    [self loadAssetListData:@"" type:LoadTypeRefresh];
}
- (void)initData{
    _pageNumber = 0;
    _assetModelArr = [NSMutableArray array];
    [_tableView registerNib:[UINib nibWithNibName:cellIndentify bundle:nil] forCellReuseIdentifier:cellIndentify];
    // 设置header
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.tableView.userInteractionEnabled = NO;
        [self loadAssetListData:@"" type:LoadTypeRefresh];
        
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.tableView.userInteractionEnabled = NO;
        [self loadAssetListData:@"" type:LoadTypeMore];
        
    }];
}
#pragma mark /************ createNavBarItems ************/
- (void)createNavItems{
    UIBarButtonItem * rightScan = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scanAction)];
    UIBarButtonItem * leftAdd = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    self.navigationItem.leftBarButtonItem = leftAdd;
    self.navigationItem.rightBarButtonItem = rightScan;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];//allocate titleView
    UIColor *color =  self.navigationController.navigationBar.backgroundColor;
    
    [titleView setBackgroundColor:color];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    _searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 0, 200, 30);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 15;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:8];
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    
    searchBar.placeholder = @"请输入资产名";
    [titleView addSubview:searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
}
#pragma mark /************ loadData ************/
- (void)loadAssetListData:(NSString *)name type:(LoadType)loadType{
    _pageNumber ++;
    NSString * url = [Aplus_Api api_assets_list];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    if (loadType == LoadTypeRefresh) {
        _pageNumber = 1;
    }
    params[@"pagenumber"] = [NSNumber numberWithInt:_pageNumber];
    params[@"pagesize"] = @5;
    if (![_searchBar.text isEqualToString:@""]) {
        params[@"assetName"] = [_searchBar.text triming];
    }
    
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取资产列表数据%@",responseObject);
        if (loadType == LoadTypeRefresh) {
            [_assetModelArr removeAllObjects];
        }
        for (NSDictionary * dict in responseObject[@"list"]) {
            Aplus_AssetModel * model = [Aplus_AssetModel modelWithDict:dict];
            [_assetModelArr addObject:model];
        }
        [_tableView reloadData];
        [self dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self dismiss];
        NSLog(@"获取资产列表失败%@",error);
    }];
}
#pragma mark /************ tableView dataSource and delegate ************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _assetModelArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 150;
    return _tableView.rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Aplus_AssetCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    Aplus_AssetModel * model = _assetModelArr[indexPath.row];
    cell.model = model;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Aplus_AssetModel * model = _assetModelArr[indexPath.row];
    Aplus_AssetDetailViewController * assetDetailController = [[Aplus_AssetDetailViewController alloc]init];
    assetDetailController.assetNo = model.assetNo;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:assetDetailController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark /************ itemAction ************/
/** 开始扫描 */
- (void)scanAction{
    [Aplus_Until scanningQRCodeBlock:^{
        SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
        scanningQRCodeVC.delegate = self;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }];
}

- (void)addAction{
    Aplus_AddAssetViewController * addAssetController = [[Aplus_AddAssetViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addAssetController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [Aplus_Until startSVP:@"加载中"];
    [self loadAssetListData:[searchBar.text triming] type:LoadTypeRefresh];
    
}
#pragma mark /************ 收起键盘 ************/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar resignFirstResponder];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_searchBar resignFirstResponder];
}
#pragma mark /************ SGScanningQRCodeVC delegate ************/
- (void)receiveScanningResult:(NSString *)string{
    NSLog(@"扫描资产返回数据");
    Aplus_AssetDetailViewController * assetDetailController = [[Aplus_AssetDetailViewController alloc]init];
    assetDetailController.assetNo = string;
    assetDetailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:assetDetailController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)dismiss{
    [SVProgressHUD dismiss];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    _tableView.userInteractionEnabled = YES;
}
@end
