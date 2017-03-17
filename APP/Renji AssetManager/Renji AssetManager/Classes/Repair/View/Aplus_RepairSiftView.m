//
//  Aplus_RepairSiftView.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/15.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_RepairSiftView.h"
#import "Aplus_RepairModel.h"


#define swidth self.frame.size.width
#define sheight self.frame.size.height
@interface Aplus_RepairSiftView()<FinishPickViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) FullTimeView * fullTimePick;
@property (strong, nonatomic) UIView       * dateView;
@property (assign, nonatomic) int            buttonTag;
@property (strong, nonatomic) NSArray      * orderStatusArr;
@property (strong, nonatomic) NSArray      * imageArr;
@property (assign, nonatomic) int            status;

@end
@implementation Aplus_RepairSiftView

- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"Aplus_RepairSiftView" owner:self options:nil]lastObject];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        [self initUI];
    }
    return self;
}
- (void)initUI{
    _orderStatusArr = [Aplus_Until getDictWithKey:@"orderStatus"];
    _imageArr = [NSArray arrayWithObjects:@"empty",@"icon_orderType_1",@"icon_orderType_2",@"icon_orderType_3",@"icon_orderType_4", nil];

    _startTime.delegate       = self;
    _endTime.delegate         = self;
    _assetNo.delegate         = self;
    _assetName.delegate       = self;
    _orderStatus.delegate     = self;


    _search.layer.cornerRadius = 5;

    UIImageView * imageView    = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
    imageView.image            = [UIImage imageNamed:@"icon_choose"];
    imageView.contentMode      = UIViewContentModeScaleAspectFit;
    _orderStatus.rightView     = imageView;
    _orderStatus.rightViewMode = UITextFieldViewModeAlways;
    
    
}
- (void)setMessage:(Aplus_RepairModel *)message{
    _message          = message;
    _startTime.text   = message.startDate;
    _endTime.text     = message.endDate;
    _assetNo.text     = message.assetNo;
    _assetName.text   = message.assetName;
    _orderStatus.text = _orderStatusArr[message.status];
    
}

#pragma mark -- 开始搜索
- (IBAction)searchClick:(id)sender {
    [_backgroudView endEditing:YES];

    double start   = [[Aplus_Until getTimeWithDate10:_message.startDate]doubleValue];
    double end     = [[Aplus_Until getTimeWithDate10:_message.endDate]doubleValue];
    double current = [[Aplus_Until getCurrentTime10]doubleValue];
    
    if (start > current || end > current) {
        [Aplus_Until alertView:@"所时间不能大于当前时间"];
    }else if (start > end) {
        [Aplus_Until alertView:@"开始时间不能大于结束时间"];
    }else{
        _message.assetName = _assetName.text;
        _message.assetNo   = _assetNo.text;
        _message.startDate = _startTime.text;
        _message.endDate   = _endTime.text;
        _message.status    = _status;
        if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
            [self.delegate beginSearch:_message];
        }
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_backgroudView endEditing:YES];
    
}
#pragma mark /************ UITextField delegeta ************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _startTime) {
        [_backgroudView endEditing:YES];
        _buttonTag = 100;
        [self createDateView:textField.text];
        return NO;
    }else if (textField == _endTime){
        [_backgroudView endEditing:YES];
        _buttonTag = 200;
        [self createDateView:textField.text];
        return NO;
    }else if (textField == _orderStatus){
        [_backgroudView endEditing:YES];
        [self orderTypePopView];
        return NO;
    }else{
        return YES;
    }
}
- (void)orderTypePopView{
    PopoverView * popView = [[PopoverView alloc]initWithPoint:CGPointMake(CGRectGetMidX(_orderStatus.frame), CGRectGetMaxY(_orderStatus.frame)+64) titles:_orderStatusArr images:_imageArr];
    __weak Aplus_RepairSiftView * blockSelf = self;
    popView.selectRowAtIndex = ^(NSInteger index){
        blockSelf.status = (int)index;
        blockSelf.orderStatus.text = blockSelf.orderStatusArr[index];
    };
    [popView show];
}
#pragma mark -- 设置起止时间
- (void)createDateView:(NSString *)curDate{
    _dateView = [[UIView alloc]initWithFrame:self.bounds];
    [_dateView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_dateView];
    
    
    FullTimeView * fullTimePick=[[FullTimeView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT,SCREENWIDTH, 261)];
    _fullTimePick = fullTimePick;
    fullTimePick.backgroundColor = [UIColor whiteColor];
    fullTimePick.curDate=curDate;
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
        if (_buttonTag == 100) {
            _startTime.text = dateString;
        }else{
            _endTime.text = dateString;
        }
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

@end
