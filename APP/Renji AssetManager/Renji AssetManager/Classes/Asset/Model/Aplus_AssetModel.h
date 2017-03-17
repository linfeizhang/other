//
//  Aplus_AssetModel.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/9.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Aplus_AssetModel : NSObject

@property (nonatomic, copy) NSString * assetName;
@property (nonatomic, copy) NSString * assetNo;
@property (nonatomic, copy) NSString * alias;
@property (nonatomic, copy) NSString * deptName;
@property (nonatomic, copy) NSString * deptNo;
@property (nonatomic, copy) NSString * installDate;
@property (nonatomic, copy) NSString * locCode;
@property (nonatomic, copy) NSString * model;
@property (nonatomic, copy) NSString * serial;
@property (nonatomic, copy) NSString * hospitalName;






- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;


@end
