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
    return [plistDict objectForKey: key];

}

+(void) saveConfiguration:(NSString *)akey value:(NSString *)aValue
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    [plistDict setValue:akey forKey:akey];
    [plistDict writeToFile:file atomically:YES];
}

+(void) saveConfigurationWithDictionary:(NSDictionary *)dic
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    [plistDict setValuesForKeysWithDictionary:dic];
    [plistDict writeToFile:file atomically:YES];
}

+(void) removeConfiguration:(NSString *)key
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    [plistDict removeObjectForKey:key];
    [plistDict writeToFile:file atomically:YES];
}
@end
