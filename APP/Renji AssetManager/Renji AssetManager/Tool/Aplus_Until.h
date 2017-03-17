//
//  Aplus_Until.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/7.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^RefreshTokenBlock)();
@interface Aplus_Until : NSObject

+ (NSString *)getString:(NSString *)str;
+ (id)getDictWithKey:(NSString *)str;
+ (void)alertView:(NSString *)string;
+ (NSString*)md5String:(NSString*)sourceString;
+ (BOOL)availableMobile:(NSString *)mobile;

+ (void)startSVP:(NSString *)str;
// 时间戳转换成日期
+ (NSString * )getDateWithTime:(NSString *)timeStr;
// 日期转换成时间戳
+ (NSString * )getTimeWithDate10:(NSString *)dateString;
+ (NSString * )getTimeWithDate13:(NSString *)dateString;
// 获取当前日期
+ (NSString *)getcurrentDate;
// 获取前一段时间的日期
+ (NSString *)getcurrentDate:(int)days;
// 获得当前时间戳
+ (NSString *)getCurrentTime10;
+ (NSString *)getCurrentTime13;
// 获取前一段时间的时间戳
+ (NSString *)getOldTime10:(NSString *)currentTime withDays:(int)num;
+ (NSString *)getOldTime13:(NSString *)currentTime withDays:(int)num;
// 获取当天的00：00：00
+ (NSString *)getZeroTime;


+ (void)scanningQRCodeBlock:(void (^)())block;
@end
