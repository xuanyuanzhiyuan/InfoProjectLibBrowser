//
//  iplbNewsRepository.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-21.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbNewsRepository.h"
#import "iplbNews.h"
#import "iplbConfiguration.h"

@implementation iplbNewsRepository
-(NSMutableArray *) getAllNews
{
    NSString *newsListUrl = [NSString stringWithFormat:@"%@%@",[iplbConfiguration getConfiguration:@"ServerRoot"],[iplbConfiguration getConfiguration:@"NewsList"]];
    NSDictionary *responseDict = [super dictionaryFromHTTPResponseJSON:newsListUrl];
    NSMutableArray *news = [NSMutableArray new];
    if([responseDict objectForKey:@"returnArray"]){
        NSArray* objects = [responseDict objectForKey:@"returnArray"];
        for (id obj in objects) {
            if([obj isKindOfClass:[NSDictionary class]]){
                [news addObject:[iplbNews newsSummaryWithDictionary:obj]];
            }
        }
    }
    return news;
}

-(iplbNews *) getNewsDetail:(NSString *)url
{
    NSDictionary *responseDict = [super dictionaryFromHTTPResponseJSON:url];
    if([responseDict objectForKey:@"returnDictionary"]){
        return [iplbNews newsWithDictionary:[responseDict objectForKey:@"returnDictionary"]];
    }
    return nil;
    
}
@end
