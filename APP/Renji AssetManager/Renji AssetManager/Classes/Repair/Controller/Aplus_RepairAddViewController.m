//
//  Aplus_RepairAddViewController.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/15.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//   0.881134 0.881108 0.881123 1

#import "Aplus_RepairAddViewController.h"
#import "Aplus_AssetModel.h"
@interface Aplus_RepairAddViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,SGScanningQRCodeVCDelegate,FinishPickViewDelegate>

@property (strong, nonatomic) FullTimeView * fullTimePick;
@property (strong, nonatomic) UIView       * dateView;
@property (strong, nonatomic) NSArray      * statusArr;
@property (strong, nonatomic) NSArray      * faultTypeArr;


@property (assign, nonatomic) CGFloat keybordY;
@end

@implementation Aplus_RepairAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItem];
    [self initData];
    [self initUI];
}
- (void)createNavItem{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)submitAction{
    if ([Aplus_Until availableMobile:_repairTel.text]) {
        NSLog(@"电话号码正确");
    }else{
        NSLog(@"电话号码错误");
    }
}
- (void)initData{
    self.title = self.titleText;
    
    _statusArr = [Aplus_Until getDictWithKey:@"orderStatus"];
    _faultTypeArr = [Aplus_Until getDictWithKey:@"faultType"];
    
    
    
    _repairDate.text = [Aplus_Until getcurrentDate];
    
    NSInteger length = _comment.text.length;
    self.limitLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX_LIMIT_COMMENT-length,MAX_LIMIT_COMMENT];
}
- (void)initUI{
    [_assetNo addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_repairDate addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_repairMan addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_repairTel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_deptName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_locaName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView * imageView     = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 16)];
    imageView.image             = [UIImage imageNamed:@"icon_choose"];
    imageView.contentMode       = UIViewContentModeScaleAspectFit;
    _repairStatus.rightView     = imageView;
    _repairStatus.rightViewMode = UITextFieldViewModeAlways;
    UIImageView * imageView1    = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 16)];
    imageView1.image            = [UIImage imageNamed:@"icon_choose"];
    imageView1.contentMode      = UIViewContentModeScaleAspectFit;
    _faultType.rightView        = imageView1;
    _faultType.rightViewMode    = UITextFieldViewModeAlways;
    
    UIImageView * imageView2    = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 36, 20)];
    imageView2.image            = [UIImage imageNamed:@"icon_date"];
    imageView2.contentMode      = UIViewContentModeScaleAspectFit;
    _repairDate.rightView        = imageView2;
    _repairDate.rightViewMode    = UITextFieldViewModeAlways;
    
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 8, 36, 20)];
    searchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [searchBtn setImage:[UIImage imageNamed:@"icon_search_gray"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    _assetNo.rightViewMode = UITextFieldViewModeAlways;
    _assetNo.rightView     = searchBtn;
    
    _comment.layer.borderColor  = [[UIColor lightGrayColor]CGColor];
    _comment.layer.borderWidth  = 1;
    _comment.layer.cornerRadius = 5;
}
- (void)repeatData:(Aplus_AssetModel *)model{
    _assetName.text = model.assetName;
    _serial.text = model.serial;
    _hospitalName.text = model.hospitalName;
}
#pragma mark /************ 数据处理 ************/
- (void)getAssetData:(NSString *)assetNo{
    [_assetNo resignFirstResponder];
    [Aplus_Until startSVP:@"加载中..."];
    NSString * url = [NSString stringWithFormat:@"%@%@",[Aplus_Api api_assets_asset_no],assetNo];
    
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"获取资产详情数据%@",responseObject);
        if (responseObject[@"error_code"]) {
            [Aplus_Until alertView:@"资产加载失败,请重新加载!"];
        }else{
            Aplus_AssetModel * model = [Aplus_AssetModel modelWithDict:responseObject];
            [self repeatData:model];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"获取资产详情失败%@",error);
    }];
}
#pragma mark /************ textField 代理方法 ************/
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _repairDate) {
        [self createDateView];
        return NO;
    }else if (textField == _faultType){
        [self popViewForFaultType];
        return NO;
    }else if (textField == _repairStatus){
        [self popViewForStatus];
        return NO;
    }
    return YES;
}

- (void)popViewForStatus{
    BOOL first = NO;
    NSMutableArray * arr = [NSMutableArray array];
    for (NSString *str in _statusArr) {
        if (first) {
            [arr addObject:str];
        }
        first = YES;
    }
    CGFloat floatY = CGRectGetMaxY(_repairStatus.frame)+64-_scrollView.contentOffset.y;
    __weak Aplus_RepairAddViewController * blockSelf = self;
    PopoverView * popView = [[PopoverView alloc]initWithPoint:CGPointMake(CGRectGetMidX(_repairStatus.frame), floatY) titles:_statusArr images:nil];
    popView.selectRowAtIndex = ^(NSInteger index){
       
        
    };
    [popView show];
}
- (void)popViewForFaultType{
    CGFloat floatY = CGRectGetMaxY(_faultType.frame)+64-_scrollView.contentOffset.y;
    __weak Aplus_RepairAddViewController * blockSelf = self;
    PopoverView * popView = [[PopoverView alloc]initWithPoint:CGPointMake(CGRectGetMidX(_faultType.frame), floatY) titles:_faultTypeArr images:nil];
    popView.selectRowAtIndex = ^(NSInteger index){
        
        
    };
    [popView show];
}
#pragma mark -- 设置起止时间
- (void)createDateView{
    _dateView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_dateView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_dateView];
    
    
    FullTimeView * fullTimePick=[[FullTimeView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT,SCREENWIDTH, 261)];
    _fullTimePick = fullTimePick;
    fullTimePick.backgroundColor = [UIColor whiteColor];
    fullTimePick.curDate=_repairDate.text;
    fullTimePick.delegate=self;
    [_dateView addSubview:fullTimePick];
    
    [UIView animateWithDuration:0.3 animations:^{
        _fullTimePick.frame = CGRectMake(0,SCREENHEIGHT-261,SCREENWIDTH, 261);
    }];
}
#pragma mark -- fullTimeView 的delegate方法
- (void)setFinishDate:(NSString *)dateString{
    [UIView animateWithDuration:0.3 animations:^{
        _fullTimePick.frame = CGRectMake(0,SCREENHEIGHT,SCREENWIDTH, 261);
    } completion:^(BOOL finished) {
        _repairDate.text = dateString;
        [_dateView removeFromSuperview];
    }];
}
- (void)setCancelView{
    [UIView animateWithDuration:0.3 animations:^{
        _fullTimePick.frame = CGRectMake(0,SCREENHEIGHT,SCREENWIDTH, 261);
    } completion:^(BOOL finished) {
        [_dateView removeFromSuperview];
    }];
}






#pragma mark /************ 回调资产信息 ************/
- (IBAction)scanAction:(id)sender {
    [Aplus_Until scanningQRCodeBlock:^{
        SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
        scanningQRCodeVC.delegate = self;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
    }];
}

- (void)searchClick{
    if (![_assetNo.text isEqualToString:@""]) {
        [self getAssetData:_assetNo.text];
    }
}
#pragma mark /************ SGScanningQRCodeVC delegate ************/
- (void)receiveScanningResult:(NSString *)string{
    _assetNo.text = string;
    [self getAssetData:string];
    
}
#pragma mark /************ 限制文本输入字数 ************/
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.assetNo) {
        if (textField.text.length > MAX_LIMIT_ASSETNO) {
            textField.text = [textField.text substringToIndex:MAX_LIMIT_ASSETNO];
        }
    }else if (textField == self.repairMan) {
        if (textField.text.length > MAX_LIMIT_REPAIRMAN) {
            textField.text = [textField.text substringToIndex:MAX_LIMIT_REPAIRMAN];
        }
    }else if (textField == self.repairTel) {
        if (textField.text.length > MAX_LIMIT_REPAIRTEL) {
            textField.text = [textField.text substringToIndex:MAX_LIMIT_REPAIRTEL];
        }
    }else if (textField == self.deptName) {
        if (textField.text.length > MAX_LIMIT_DEPTNAME) {
            textField.text = [textField.text substringToIndex:MAX_LIMIT_DEPTNAME];
        }
    }else if (textField == self.locaName) {
        if (textField.text.length > MAX_LIMIT_LOCANAME) {
            textField.text = [textField.text substringToIndex:MAX_LIMIT_LOCANAME];
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_COMMENT) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_COMMENT - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.limitLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_COMMENT];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_COMMENT)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_COMMENT];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.limitLabel.text = [NSString stringWithFormat:@"%d/%d",MAX(0,MAX_LIMIT_COMMENT - existTextNum),MAX_LIMIT_COMMENT];
}
#pragma mark /************ 订阅键盘通知 ************/
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _keybordY = CGRectGetMaxY(textField.frame);
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _keybordY = CGRectGetMaxY(textView.frame);
    return YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    CGRect keyboardFrameEnd = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat  duration = 0.25;
    
    CGFloat y = keyboardFrameEnd.origin.y - 64;
    CGFloat h = _keybordY-_scrollView.contentOffset.y+20;
    
    [UIView animateWithDuration:duration animations:^{
        if (h-y > 0) {
            if (h-y > keyboardFrameEnd.size.height) {
                CGFloat heigth = h-y - keyboardFrameEnd.size.height;
                self.view.transform = CGAffineTransformMakeTranslation(0, y-h+heigth);
                _scrollView.contentOffset = CGPointMake(0, _scrollView.contentOffset.y+heigth);
            }else{
                self.view.transform = CGAffineTransformMakeTranslation(0, y-h);
            }
        }else{
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        }
    }];
}
#pragma mark /************ 收键盘 ************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"-----------------");
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
