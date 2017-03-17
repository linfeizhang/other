//
//  Aplus_AssetModel.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/9.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_AssetModel.h"

@implementation Aplus_AssetModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.assetName   = dict[@"assetName"];
        self.assetNo     = dict[@"assetNo"];
        self.deptName    = dict[@"deptName"];
        self.deptNo      = dict[@"deptNo"];
        self.installDate = dict[@"installDate"];
        self.alias       = dict[@"alias"];
        self.locCode     = dict[@"locCode"];
        self.model       = dict[@"model"];
    }
    return self;
}
+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
