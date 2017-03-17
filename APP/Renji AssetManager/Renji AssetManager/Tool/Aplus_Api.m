//
//  Aplus_Api.m
//  Renji AssetManager
//
//  Created by inhandnetworks on 2017/3/7.
//  Copyright © 2017年 inhandnetworks. All rights reserved.
//

#import "Aplus_Api.h"

@implementation Aplus_Api

+ (NSString *)client_id
{
    return [[self alloc] getApi:@"client_id"];
}
+ (NSString *)client_secret
{
    return [[self alloc] getApi:@"client_secret"];
}
+ (NSString *)serverIP{
    return [[self alloc] getApi:@"serverIP"];
}
+ (NSString*)api_token{
    return [NSString stringWithFormat:@"%@%@",[self serverIP],[[self alloc] getApi:@"oauth.accessToken"]];
}
+ (NSString *)api_permissions{
    return [NSString stringWithFormat:@"%@%@",[self serverIP],[[self alloc] getApi:@"oauth.permissions"]];
}
+ (NSString*)api_assets_asset_no{
    return [NSString stringWithFormat:@"%@%@",[self serverIP],[[self alloc] getApi:@"assets.assets_no"]];
}
+ (NSString*)api_assets_list{
    return [NSString stringWithFormat:@"%@%@",[self serverIP],[[self alloc] getApi:@"assets.list"]];
}
+ (NSString*)api_repair_list{
    return [NSString stringWithFormat:@"%@%@",[self serverIP],[[self alloc] getApi:@"repairs.list"]];
}












- (NSString *)getApi:(NSString *)ApiString{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"API.plist" ofType:nil];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString * apistring = dict[ApiString];
    return apistring;
}
//- (NSArray *)judgeServerIP{
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"ServerIP.plist" ofType:nil];
//    NSArray * arr = [NSArray arrayWithContentsOfFile:path];
//    return arr;
//}
@end
