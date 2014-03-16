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
@end
