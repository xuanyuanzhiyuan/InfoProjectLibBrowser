//
//  iplbProjectDetail.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbProjectDetail.h"

@implementation iplbProjectDetail

+(iplbProjectDetail *) projectSummaryWithDictionary:(NSDictionary *) dic
{
    iplbProjectDetail *detail = [iplbProjectDetail new];
    detail.projectName = [dic valueForKey:@"name"];
    detail.projectDesc = [dic valueForKey:@"desc"];
    detail.iconURL = [dic valueForKey:@"iconURL"];
    detail.detailURL = [dic valueForKey:@"detailURL"];
    return detail;
}

+(iplbProjectDetail *) projectDetailWithDictionary:(NSDictionary *) dic
{
    iplbProjectDetail *detail = [iplbProjectDetail new];
    detail.projectName = [dic valueForKey:@"name"];
    detail.projectDesc = [dic valueForKey:@"desc"];
    detail.iconURL = [dic valueForKey:@"iconURL"];
    detail.detailInfo = [dic valueForKey:@"detailInfo"];
    detail.screenShots = [dic valueForKey:@"screenShotURLs"];
    detail.platformType = [dic valueForKey:@"platformType"];
    return detail;
}

@end
