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
    NSLog(@"%@",[iplbConfiguration getConfiguration:@"ServerRoot"]);
    NSString *projectsAllUrlStr = [NSString stringWithFormat:@"%@%@",[iplbConfiguration getConfiguration:@"ServerRoot"],[iplbConfiguration getConfiguration:@"ProjectList"]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:projectsAllUrlStr]];
    [request startSynchronous];
    NSError *error = [request error];
    NSMutableArray *products = [NSMutableArray new];
    if(!error){
        NSString *projectInfosJSON = [request responseString];
        NSArray* objects = [NSJSONSerialization
                            JSONObjectWithData:[projectInfosJSON dataUsingEncoding:NSUTF8StringEncoding]
                            options:0
                            error:nil];
        for (id obj in objects) {
            if([obj isKindOfClass:[NSDictionary class]]){
                [products addObject:[iplbProjectDetail projectSummaryWithDictionary:obj]];
            }
        }
        NSLog(@"count=>%lu",(unsigned long)[objects count]);
    }
    return products;
}

-(iplbProjectDetail *) getProjectDetailInfo:(NSString *)url
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    NSError *error = [request error];
    if(!error){
        NSString *projectDetailJSON = [request responseString];
        NSDictionary *projectDetailDic = [NSJSONSerialization
                                          JSONObjectWithData:[projectDetailJSON dataUsingEncoding:NSUTF8StringEncoding]
                                          options:0
                                          error:nil];
        return [iplbProjectDetail projectDetailWithDictionary:projectDetailDic];
    }
    return nil;
}

-(NSMutableArray *) getProjectInfosWithCategory:(NSString *)categoryCode
{
    NSString *projectsCategoryUrlStr = [NSString stringWithFormat:@"%@%@/%@",[iplbConfiguration getConfiguration:@"ServerRoot"],[iplbConfiguration getConfiguration:@"ProjectList"],categoryCode];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:projectsCategoryUrlStr]];
    [request startSynchronous];
    NSError *error = [request error];
    NSMutableArray *products = [NSMutableArray new];
    if(!error){
        NSString *projectInfosJSON = [request responseString];
        NSArray* objects = [NSJSONSerialization
                            JSONObjectWithData:[projectInfosJSON dataUsingEncoding:NSUTF8StringEncoding]
                            options:0
                            error:nil];
        for (id obj in objects) {
            if([obj isKindOfClass:[NSDictionary class]]){
                [products addObject:[iplbProjectDetail projectSummaryWithDictionary:obj]];
            }
        }
    }
    return products;
}

@end
