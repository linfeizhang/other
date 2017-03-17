//
//  Aplus_RepairViewController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/14.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_RepairViewController.h"
#import "Aplus_RepairModel.h"
#import "Aplus_RepairCell.h"
#import "Aplus_RepairSiftView.h"
#import "Aplus_RepairAddViewController.h"

@interface Aplus_RepairViewController ()<UITableViewDataSource,UITableViewDelegate,Aplus_RepairSiftViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) Aplus_RepairSiftView * repairSiftView;
@property (weak, nonatomic) UISegmentedControl * segmentedControl;
@property (strong, nonatomic) Aplus_RepairModel * message;
@property (strong, nonatomic) NSMutableArray * repairModelArr;
@property (assign, nonatomic) int total;
@property (assign, nonatomic) int pageNumber;
@property (assign, nonatomic) BOOL isSelect;

@end

@implementation Aplus_RepairViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isSelect) {
        _isSelect = !_isSelect;
        [_repairSiftView removeFromSuperview];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavBarItems];
    [self initData];
    [Aplus_Until startSVP:@"加载中..."];
    [self loadRepairListData:LoadTypeRefresh];
}
#pragma mark /************ 创建导航栏按钮 ************/
- (void)createNavBarItems{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(siftConditionClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;
    
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    self.navigationItem.leftBarButtonItem = left;
    
    NSArray * titles = [NSArray arrayWithObjects:@"所有工单",@"我的工单", nil];
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc]initWithItems:titles];
    segmentedControl.frame = CGRectMake(0, 0, 160, 30);
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl = segmentedControl;
    self.navigationItem.titleView = segmentedControl;
}




- (void)initData{
    _pageNumber        = 0;
    _repairModelArr    = [NSMutableArray array];
    _message           = [[Aplus_RepairModel alloc]init];
    _message.startDate = [Aplus_Until getcurrentDate:50];
    _message.endDate   = [Aplus_Until getcurrentDate];
    _message.assetNo   = @"";
    _message.assetName = @"";
    _message.status    = 0;
    NSLog(@"%@\n%@",_message.endDate,_message.startDate);
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _tableView.userInteractionEnabled = NO;
        [self loadRepairListData:LoadTypeRefresh];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _tableView.userInteractionEnabled = NO;
        [self loadRepairListData:LoadTypeMore];
    }];
}
- (void)loadRepairListData:(LoadType)loadType{
    if (loadType == LoadTypeRefresh) {
        _pageNumber = 0;
    }
    _pageNumber ++;
    NSString * url = [Aplus_Api api_repair_list];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = ACCESS_TOKEN;
    params[@"uId"]          = UserName;
    params[@"pageNumber"]   = [NSNumber numberWithInt:_pageNumber];
    params[@"pageSize"]     = @20;
    params[@"startDate"]    = _message.startDate;
    params[@"endDate"]      = _message.endDate;
    if (![_message.assetNo isEqualToString:@""]) {
        params[@"assetNo"]  = _message.assetNo;
    }
    if (![_message.assetName isEqualToString:@""]) {
        params[@"assetName"]= _message.assetName;
    }
    if (_message.status != 0) {
        params[@"status"]   = [NSNumber numberWithInt:_message.status];
    }
    
    
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        if (loadType == LoadTypeRefresh) {
            [_repairModelArr removeAllObjects];
        }
        NSDictionary * logs = responseObject[@"logs"];
        _total = [logs[@"total"]intValue];
        for (NSDictionary * dict in logs[@"list"]) {
            Aplus_RepairModel * model = [Aplus_RepairModel repairModelWithDict:dict];
            [_repairModelArr addObject:model];
        }
        if (_repairModelArr.count == 0) {
            [Aplus_Until alertView:@"无数据"];
        }
        [_tableView reloadData];
        [self dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self dismiss];
        NSLog(@"获取报修列表失败 error = %@",error);
    }];
}

#pragma mark /************ tableView datasourse and delegate ************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%d",_total];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _repairModelArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 148;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Aplus_RepairCell * cell = [Aplus_RepairCell repairCellWithTableView:tableView];
    Aplus_RepairModel * model = _repairModelArr[indexPath.row];
    cell.repairModel = model;
    return cell;
}





#pragma mark /************ navBarItems action ************/

- (void)siftConditionClick{
    _isSelect = !self.isSelect;
    if (_isSelect) {
        Aplus_RepairSiftView * repairSiftView = [[Aplus_RepairSiftView alloc]init];
        repairSiftView.delegate = self;
        repairSiftView.message = _message;
        _repairSiftView =repairSiftView;
        repairSiftView.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, self.view.frame.size.height);
        [self.view addSubview:repairSiftView];
        
        [UIView animateWithDuration:0.3 animations:^{
           _repairSiftView.frame = self.view.bounds;
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _repairSiftView.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [_repairSiftView removeFromSuperview];
        }];
    }
}
- (void)addClick{
    Aplus_RepairAddViewController * repairAddViewController = [[Aplus_RepairAddViewController alloc]init];
    repairAddViewController.titleText = @"创建报修单";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:repairAddViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
- (void)changeValue:(UISegmentedControl *)segment{
//    segment.selectedSegmentIndex
}


#pragma mark /************ repairSiftViewDelegate ************/
- (void)beginSearch:(Aplus_RepairModel *)message{
    _message = message;
    [self siftConditionClick];
    [Aplus_Until startSVP:@"加载中..."];
    [self loadRepairListData:LoadTypeRefresh];
}

- (IBAction)scrollToTop:(id)sender {
    if (_repairModelArr.count >0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}
- (void)dismiss{
    [SVProgressHUD dismiss];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    _tableView.userInteractionEnabled = YES;
}

@end
