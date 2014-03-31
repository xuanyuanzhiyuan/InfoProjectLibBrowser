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
    /**
    NSArray *screenShotURLs = @[@"http://img3.douban.com/view/movie_poster_cover/spst/public/p2174990264.jpg",@"http://img3.douban.com/view/photo/photo/public/p2168015570.jpg",@"http://img5.douban.com/view/photo/photo/public/p2168015558.jpg"];
    NSDictionary *responseDict = @{@"name":@"轩辕软件测试系统",@"desc":@"LWILY",@"iconURL":@"http://img5.douban.com/view/photo/photo/public/p2168015558.jpg",@"screenShotURLs":screenShotURLs};
    return [iplbProjectDetail projectDetailWithDictionary:responseDict];
      **/
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
    /**
    NSDictionary *responseDict = @{@"name":@"软件测试系统",@"desc":@"testlw",@"iconURL":@"http://img3.douban.com/view/movie_poster_cover/spst/public/p2174990264.jpg"};
    NSMutableArray *products = [NSMutableArray new];
    [products addObject:[iplbProjectDetail projectSummaryWithDictionary:responseDict]];
    return products;
     **/
}
@end
