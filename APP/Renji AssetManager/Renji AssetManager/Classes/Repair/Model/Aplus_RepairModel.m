//
//  Aplus_RepairModel.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/14.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_RepairModel.h"

@implementation Aplus_RepairModel

- (instancetype)initRpairModelWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        if ([dict[@"alias"] isKindOfClass:[NSNull class]]){
            self.alias = @"";
        }else{
            self.alias = dict[@"alias"];
        }
        self.assetName = dict[@"assetName"];
        self.assetNo = dict[@"assetNo"];
        self.repairId = dict[@"repairId"];
        self.createDT = dict[@"createDT"];
        self.deptName = dict[@"deptName"];
        self.deptNo = dict[@"deptNo"];
        self.creater = dict[@"creater"];
        self.status = [dict[@"status"]intValue];
        self.orderType = [dict[@"orderType"]intValue];
    }
    return self;
}
+ (instancetype)repairModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initRpairModelWithDict:dict];
}
@end
