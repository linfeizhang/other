//
//  Aplus_Api.h
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/7.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Aplus_Api : NSObject


+ (NSString*)serverIP;
+ (NSString*)client_id;
+ (NSString*)client_secret;
+ (NSString*)api_token;
+ (NSString*)api_permissions;
+ (NSString*)api_assets_asset_no;
+ (NSString*)api_assets_list;
+ (NSString*)api_repair_list;
@end
