//
//  iplbNews.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-21.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbNews.h"

@implementation iplbNews
+(iplbNews *) newsSummaryWithDictionary:(NSDictionary *)dic
{
    iplbNews *newsDetail = [iplbNews new];
    newsDetail.title = [dic valueForKey:@"title"];
    newsDetail.summary = [dic valueForKey:@"desc"];
    newsDetail.newsPictureURL = [dic valueForKey:@"newsPicURL"];
    newsDetail.detailURL = [dic valueForKey:@"detailURL"];
    newsDetail.content = [dic valueForKey:@"content"];
    return newsDetail;
}

+(iplbNews *) newsWithDictionary:(NSDictionary *)dic
{
    iplbNews *newsDetail = [iplbNews new];
    newsDetail.title = [dic valueForKey:@"title"];
    newsDetail.summary = [dic valueForKey:@"desc"];
    newsDetail.newsPictureURL = [dic valueForKey:@"newsPicURL"];
    newsDetail.content = [dic valueForKey:@"content"];
    return newsDetail;
}
@end
