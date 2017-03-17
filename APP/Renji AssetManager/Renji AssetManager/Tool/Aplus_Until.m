//
//  Aplus_Until.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/7.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_Until.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@implementation Aplus_Until
+ (id)getDictWithKey:(NSString *)str{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"Language" ofType:@"plist"];
    NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:path];
//    NSDictionary * dictionary;
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"language"] isEqualToString:@"english"]) {
//        dictionary = dict[@"English"];
//    }else{
//        dictionary = dict[@"Chinese"];
//    }
    NSDictionary * dict1 = dict[str];
    return dict1;
}
+ (NSString *)getString:(NSString *)str{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"Language" ofType:@"plist"];
    NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    return dict[str];
}
+ (void)alertView:(NSString *)string{
    CGSize size = [string getSize];
    CGFloat width = size.width+30;
    CGFloat height = size.height+10;
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake((SCREENWIDTH-width)/2, SCREENHEIGHT-height-60, width, height);
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    label.alpha = 1;
    [[UIApplication alloc].keyWindow addSubview:label];
    
    [UIView animateKeyframesWithDuration:1 delay:0.5 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

+ (void)startSVP:(NSString *)str{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD showWithStatus:str];
}
/*******************************日期与时间戳之间的转换**********************************/
// 时间戳转日期
+ (NSString * )getDateWithTime:(NSString *)timeString{
    NSString * timeStr = timeString;
    if (timeStr.length == 13) {
        timeStr = [NSString stringWithFormat:@"%.0f",[timeString doubleValue]/1000];
    }
    NSTimeInterval _interval=[timeStr doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [objDateformat stringFromDate: date];
    return time;
}
// 获取当前日期
+ (NSString *)getcurrentDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate: date];
}
// 获取前一段时间的日期
+ (NSString *)getcurrentDate:(int)days{
    double time = 60*60*24*days;
    NSDate * nowDate = [NSDate date];
    NSDate * date = [nowDate initWithTimeIntervalSinceNow:-time];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate: date];
}
// 获取当前时间戳
+ (NSString *)getCurrentTime10{
    NSDate* date = [NSDate date];
    NSTimeInterval a=[date timeIntervalSince1970];
    NSString * timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}
+ (NSString *)getCurrentTime13{
    NSDate* date = [NSDate date];
    NSTimeInterval a=[date timeIntervalSince1970];
    NSString * timeString = [NSString stringWithFormat:@"%.0f", a*1000];
    return timeString;
}
// 日期转时间戳
+ (NSString *)getTimeWithDate10:(NSString *)dateString{
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:dateString];
    NSTimeInterval a=[date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", a];
}
+ (NSString *)getTimeWithDate13:(NSString *)dateString{
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:dateString];
    NSTimeInterval a=[date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", a*1000];
}
// 获取前一段时间的时间戳
+ (NSString *)getOldTime10:(NSString *)currentTime withDays:(int)num{
    NSTimeInterval oldInterval = [currentTime intValue] - 60*60*24*num;
    return [NSString stringWithFormat:@"%.0f",oldInterval];
}
+ (NSString *)getOldTime13:(NSString *)currentTime withDays:(int)num{
    NSTimeInterval oldInterval = [currentTime intValue] - 1000*60*60*24*num;
    return [NSString stringWithFormat:@"%.0f",oldInterval];
}
#pragma mark /************ 获得当天时间的00：00：00 ************/
+ (NSString *)getZeroTime{
    //获取当日0时
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSString * string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld 00:00:00",(long)year,(long)month,(long)day];
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * inputDate = [inputFormatter dateFromString:string];
    
    // 获取时间戳
    NSInteger time = [inputDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",(long)time];
}


+ (BOOL)availableMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
         NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        /**
         * 固话中不带 "-"符号
         */
        NSString * FIXNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
        /**
         * 固话中带 "-"符号
         */
        NSString * FIX_Num = @"^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
        
        
       
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", FIXNum];
        BOOL isMatch4 = [pred4 evaluateWithObject:mobile];
        NSPredicate *pred5 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", FIX_Num];
        BOOL isMatch5 = [pred5 evaluateWithObject:mobile];
        
        
        if (isMatch1 || isMatch2 || isMatch3 || isMatch4 || isMatch5) {
            return YES;
        }else{
            return NO;
        }
    }
}

+ (void)scanningQRCodeBlock:(void (^)())block{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block();
                        NSLog(@"主线程 - - %@", [NSThread currentThread]);
                    });
                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限");
                } else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            block();
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"请去-> [设置 - 隐私 - 相机 - Renji AssetManager] 打开访问开关" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
            [alertView show];
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"未检测到您的摄像头, 请在真机上测试" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
        [alertView show];
    }
    
}





/******************************* MD5 加密 **********************************/
// MD5 加密
+ (NSString*)md5String:(NSString*)sourceString {
    //由于md5加密都是通过c级别的函数来计算,所以需要将加密的字符串转换为c语言字符串
    //1.获取c字符串
    const char *cStr = sourceString.UTF8String;
    //2.创建一个C语言字符串数组,用来接收加密结束之后的字符串(接收MD5值)
    //一个字节是8位,两个字节是16位,两个字符可以表示一个16位进制的数,MD5结果为32,实际上由16位16进制数组成
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5值(结果存储在result数组中)
    /*
     第一个参数:需要加密的字符串
     第二个参数:需要加密的字符串的长度
     第三个参数:加密完成之后字符串存储的地方
     */
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //4.将加密完成的字符拼接起来使用(16进制)
    //声明一个可变字符串类型,用来拼接转换好的字符
    NSMutableString *resultStr = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultStr appendFormat:@"%02x",result[i]];
    }
    //    resultStr = [resultStr uppercaseString];
    return [resultStr uppercaseString];
}
/******************************* MD5 加密 **********************************/
/******************************* 刷新 refresh_token **********************************/
+(void)refreshTokenWithBlock:(RefreshTokenBlock)refreshTokenBlock{
    //    NSLog(@"刷新了");
    // 设置参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"client_id"] = [Aplus_Api client_id];
    params[@"client_secret"] = [Aplus_Api client_secret];
    params[@"grant_type"] = @"refresh_token";
    params[@"refresh_token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"REFRESH_TOKEN"];
    NSString *strUrl=[Aplus_Api api_token];
    AFHTTPRequestOperationManager * mgr1=[AFHTTPRequestOperationManager manager];
    [mgr1 POST:strUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"access_token"] forKey:@"ACCESS_TOKEN"];
        refreshTokenBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
@end
