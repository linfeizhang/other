//
//  NSString+triming.m
//  映翰通设备云
//
//  Created by zhanglf on 16/4/15.
//  Copyright © 2016年 zhanglf. All rights reserved.
//

#import "NSString+triming.h"

@implementation NSString (triming)
- (NSString *)triming{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (CGSize)getSize{
    CGSize size = [self boundingRectWithSize:CGSizeMake(SCREENWIDTH-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return size;
}

@end
