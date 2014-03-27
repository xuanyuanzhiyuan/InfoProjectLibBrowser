//
//  iplbProjectsRepository.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbProjectsRepository.h"
#import "iplbConfiguration.h"
#import "iplbProjectDetail.h"
#import "ASIHTTPRequest.h"

@implementation iplbProjectsRepository
-(NSMutableArray *) getAllProjectInfos
{
    NSString *projectsAllUrlStr = [NSString stringWithFormat:@"%@%@",[iplbConfiguration getConfiguration:@"ServerRoot"],[iplbConfiguration getConfiguration:@"ProjectList"]];
    return [self getProjectInfosWithURL:projectsAllUrlStr];
}

-(iplbProjectDetail *) getProjectDetailInfo:(NSString *)url
{
    NSDictionary *responseDict = [super dictionaryFromHTTPResponseJSON:url];
    if([responseDict objectForKey:@"returnDictionary"]){
        return [iplbProjectDetail projectDetailWithDictionary:[responseDict objectForKey:@"returnDictionary"]];
    }
    return nil;
}

-(NSMutableArray *) getProjectInfosWithCategory:(NSString *)categoryCode
{
    NSString *projectsCategoryUrlStr = [NSString stringWithFormat:@"%@%@/%@",[iplbConfiguration getConfiguration:@"ServerRoot"],[iplbConfiguration getConfiguration:@"ProjectList"],categoryCode];
    return [self getProjectInfosWithURL:projectsCategoryUrlStr];
}

-(NSMutableArray *) getProjectInfosWithURL:(NSString *)url
{
    NSDictionary *responseDict = [super dictionaryFromHTTPResponseJSON:url];
    NSMutableArray *products = [NSMutableArray new];
    if([responseDict objectForKey:@"returnArray"]){
        NSArray* objects = [responseDict objectForKey:@"returnArray"];
        for (id obj in objects) {
            if([obj isKindOfClass:[NSDictionary class]]){
                [products addObject:[iplbProjectDetail projectSummaryWithDictionary:obj]];
            }
        }
    }
    return products;
}
@end
