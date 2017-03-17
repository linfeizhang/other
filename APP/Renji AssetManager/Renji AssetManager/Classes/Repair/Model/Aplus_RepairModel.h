//
//  Aplus_RepairModel.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/14.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Aplus_RepairModel : NSObject
@property (nonatomic, copy) NSString * total;
@property (nonatomic, copy) NSString * alias;
@property (nonatomic, copy) NSString * assetName;
@property (nonatomic, copy) NSString * assetNo;
@property (nonatomic, copy) NSString * repairId;
@property (nonatomic, copy) NSString * createDT;
@property (nonatomic, copy) NSString * deptName;
@property (nonatomic, copy) NSString * deptNo;
@property (nonatomic, copy) NSString * creater;
@property (nonatomic, copy) NSString * startDate;
@property (nonatomic, copy) NSString * endDate;
@property (nonatomic, assign) int      status;
@property (nonatomic, assign) int      orderType;









- (instancetype)initRpairModelWithDict:(NSDictionary *)dict;
+ (instancetype)repairModelWithDict:(NSDictionary *)dict;
@end
