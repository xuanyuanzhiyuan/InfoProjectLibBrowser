//
//  iplbConfiguration.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbConfiguration.h"

@implementation iplbConfiguration
+(NSString *) getConfiguration:(NSString *)key
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    if(plistDict)
        return [plistDict objectForKey: key];
    return nil;

}

+(NSString *) getUserLoginInfo:(NSString *)key
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *file=[plistPath1 stringByAppendingPathComponent:[self getConfiguration:@"UserLoginFileName"]];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    if(plistDict)
        return [plistDict objectForKey: key];
    return nil;
    
}

+(void) saveUserLongInfo:(NSString *)akey value:(NSString *)aValue fileName:(NSString *)aFileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *file=[plistPath1 stringByAppendingPathComponent:aFileName];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    if(!plistDict){
        plistDict = [NSMutableDictionary new];
    }
    [plistDict setValue:aValue forKey:akey];
    [plistDict writeToFile:file atomically:YES];
    //检查是否写入
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    NSLog(@"config is %@",newDic);
}

+(void) saveConfigurationWithDictionary:(NSDictionary *)dic
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    [plistDict setValuesForKeysWithDictionary:dic];
    [plistDict writeToFile:file atomically:YES];
    //检查是否写入
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    NSLog(@"config is %@",newDic);
}

+(void) removeConfiguration:(NSString *)key
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    [plistDict removeObjectForKey:key];
    [plistDict writeToFile:file atomically:YES];
}

+(void) removeUserLoginInfo:(NSString *)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *file=[plistPath1 stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:file error:nil];
}
@end
