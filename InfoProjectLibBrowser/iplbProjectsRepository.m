//
//  iplbProjectsRepository.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbProjectsRepository.h"
#import "iplbConfiguration.h"

@implementation iplbProjectsRepository
-(NSArray *) getAllProjectInfos
{
    NSLog(@"%@",[iplbConfiguration getConfiguration:@"ServerRootURL"]);
    NSString *projectInfosJSON =[NSString stringWithContentsOfURL:[NSURL URLWithString:[iplbConfiguration getConfiguration:@"ServerRootURL"]] encoding:NSUTF8StringEncoding error:nil];

    NSArray* objects = [NSJSONSerialization
                       JSONObjectWithData:[projectInfosJSON dataUsingEncoding:NSUTF8StringEncoding]
                       options:0
                       error:nil];
    NSLog(@"count=>%lu",(unsigned long)[objects count]);
    return objects;
}

@end
