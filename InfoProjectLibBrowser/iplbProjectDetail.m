//
//  iplbProjectDetail.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbProjectDetail.h"

@implementation iplbProjectDetail

+(iplbProjectDetail *) productWithDictionary:(NSDictionary *) dic
{
    iplbProjectDetail *detail = [iplbProjectDetail new];
    detail.projectName = [dic valueForKey:@"name"];
    detail.ProjectDesc = [dic valueForKey:@"desc"];
    detail.iconURL = [dic valueForKey:@"iconURL"];
    detail.detailURL = [dic valueForKey:@"detailURL"];
    return detail;
}

@end
