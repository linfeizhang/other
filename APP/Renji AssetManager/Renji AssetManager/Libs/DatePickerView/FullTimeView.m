//
//  FullTimeView.m
//  ios2688webshop
//
//  Created by wangchan on 16/2/23.
//  Copyright © 2016年 zhangzl. All rights reserved.
//

#import "FullTimeView.h"
#define perWidth  self.frame.size.width
#define height self.frame.size.height
@interface FullTimeView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView*fullPickView;
    
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    NSCalendar *calendar;
    NSString * timeString;
    NSString * dateString;
    
    NSArray * monthArr;
}
@end

@implementation FullTimeView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self config];
    }
    return self;
}
-(void)config
{
//    CGFloat perWidth=self.frame.size.width;
//    CGFloat height=self.frame.size.height;
//    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(perWidth - 70, 0, 40, 40)];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[Aplus_Until getString:@"ok"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:button];
    
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 80, 40)];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:[Aplus_Until getString:@"cancel"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, perWidth, 1)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    for (int i=4; i<6; i++) {
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(i*(perWidth -30)/6+8,height/2+3,  10, 30)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @":";
        [self addSubview:lable];
    }
    
    //0
    fullPickView=[[UIPickerView alloc]initWithFrame:CGRectMake(15, 40, perWidth-30, height-40)];
    fullPickView.dataSource=self;
    fullPickView.delegate=self;
    [self addSubview:fullPickView];
    
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    
    startYear=year-15;
    yearRange=60;
    selectedYear=1970;
    selectedMonth=1;
    selectedDay=1;
    selectedHour=0;
    selectedMinute=0;
    selectedSecond=0;
    dayRange=[self isAllDay:startYear andMonth:1];
    
    monthArr = [Aplus_Until getDictWithKey:@"month"];
}
//默认时间的处理
-(void)setCurDate:(NSString *)curDate
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * inputDate = [inputFormatter dateFromString:curDate];
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar0 components:unitFlags fromDate:inputDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    NSInteger second=[comps second];
    
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    selectedHour=hour;
    selectedMinute=minute;
    selectedSecond=second;
    
    dayRange=[self isAllDay:year andMonth:month];
    
    [fullPickView selectRow:year-startYear inComponent:0 animated:true];
    [fullPickView selectRow:month-1 inComponent:1 animated:true];
    [fullPickView selectRow:day-1 inComponent:2 animated:true];
    [fullPickView selectRow:hour inComponent:3 animated:true];
    [fullPickView selectRow:minute inComponent:4 animated:true];
    [fullPickView selectRow:second inComponent:5 animated:true];
    
    [fullPickView reloadAllComponents];
    
    NSString * string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour,(long)selectedMinute,(long)selectedSecond];
    
    // 获取日期字符串
    dateString = string;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
        case 2:
        {
            return dayRange;
        }
            break;
        case 3:
        {
            return 24;
        }
            break;
        case 4:
        {
            return 60;
        }
            break;
        case 5:
        {
            return 60;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake((perWidth-30)*component/6.0, 0,(perWidth-30)/6.0, 30)];
    label.font=[UIFont systemFontOfSize:14.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
//            label.frame=CGRectMake(perWidth*component/6.0, 0,perWidth/6.0+10, 30);
//            label.backgroundColor = [UIColor greenColor];
//            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld",(long)(startYear + row)];
        }
            break;
        case 1:
        {
//            label.frame=CGRectMake(perWidth*component/6.0+10, 0,perWidth/6.0, 30);
//            label.backgroundColor = [UIColor redColor];
            label.text=monthArr[row];
        }
            break;
        case 2:
        {
//            label.backgroundColor = [UIColor yellowColor];
//            label.frame=CGRectMake(perWidth*component/6.0+10, 0,perWidth/6.0, 30);
            label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
        }
            break;
        case 3:
        {
//            label.backgroundColor = [UIColor blueColor];
//            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%02ld",(long)row];
        }
            break;
        case 4:
        {
//            label.backgroundColor = [UIColor redColor];
//            label.textAlignment=NSTextAlignmentRight;
           label.text=[NSString stringWithFormat:@"%02ld",(long)row];
        }
            break;
        case 5:
        {
//             label.backgroundColor = [UIColor yellowColor];
//            label.textAlignment=NSTextAlignmentRight;
//            label.frame=CGRectMake(perWidth*component/6.0, 0, perWidth/6.0-5, 30);
            label.text=[NSString stringWithFormat:@"%02ld",(long)row];
        }
            break;
            
        default:
            break;
    }
    return label;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            selectedYear=startYear + row;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [fullPickView reloadComponent:2];
        }
            break;
        case 1:
        {
            selectedMonth=row+1;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [fullPickView reloadComponent:2];
        }
            break;
        case 2:
        {
            selectedDay=row+1;
        }
            break;
        case 3:
        {
            selectedHour=row;
        }
            break;
        case 4:
        {
            selectedMinute=row;
        }
            break;
        case 5:
        {
            selectedSecond=row;
        }
            break;
            
        default:
            break;
    }
    
    NSString * string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour,(long)selectedMinute,(long)selectedSecond];

    // 获取日期字符串
    dateString = string;
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * inputDate = [inputFormatter dateFromString:string];
//    NSLog(@"date= %@", string);
    
    // 获取时间戳
    NSInteger time = [inputDate timeIntervalSince1970];
    timeString = [NSString stringWithFormat:@"%ld",(long)time];
    
    //获取的GMT时间，要想获得某个时区的时间，以下代码可以解决这个问题
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: inputDate];
//    NSDate *localeDate = [inputDate  dateByAddingTimeInterval: interval];
//    NSLog(@"\n\n%ld\n\n", time);
//    if ([self.delegate respondsToSelector:@selector(didFinishPickView:)]) {
//        [self.delegate didFinishPickView:inputDate];
//    }
}
- (void)click{
    
//    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate * inputDate = [inputFormatter dateFromString:dateString];
//    NSInteger time = [inputDate timeIntervalSince1970];
//    if (time > [[Aplus_Until getCurrentTime10]doubleValue]) {
//        dateString = [Aplus_Until getDateWithTime:[Aplus_Until getCurrentTime10]];
//    }
////    NSLog(@"%@",dateString);
    if ([self.delegate respondsToSelector:@selector(setFinishDate:)]) {
        [self.delegate setFinishDate:dateString];
    }
}
- (void)cancelClick{
    if ([self.delegate respondsToSelector:@selector(setCancelView)]) {
        [self.delegate setCancelView];
    }
}
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}
@end
