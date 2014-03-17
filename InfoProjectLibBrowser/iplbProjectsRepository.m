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

@implementation iplbProjectsRepository
-(NSMutableArray *) getAllProjectInfos
{
    NSLog(@"%@",[iplbConfiguration getConfiguration:@"ServerRootURL"]);
    NSString *projectInfosJSON =[NSString stringWithContentsOfURL:[NSURL URLWithString:[iplbConfiguration getConfiguration:@"ServerRootURL"]] encoding:NSUTF8StringEncoding error:nil];
    /**
    NSArray* objects = [NSJSONSerialization
                       JSONObjectWithData:[projectInfosJSON dataUsingEncoding:NSUTF8StringEncoding]
                       options:0
                       error:nil];
     */
    //测试数据
    NSDictionary *aProd = @{@"name":@"广东电信资源配置系统",@"desc":@"广东电信MBOSS子系统之一的资源配置系统",@"iconURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg",@"detailURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg"};
    NSDictionary *bProd = @{@"name":@"广东电信室内覆盖系统",@"desc":@"广东电信MBOSS子系统之一的资源配置系统",@"iconURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg",@"detailURL":@"http://img1.xcar.com.cn/"};
    NSDictionary *cProd = @{@"name":@"深圳移动基站信息系统",@"desc":@"广东电信MBOSS子系统之一的资源配置系统",@"iconURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg",@"detailURL":@"http://img1.xcar.com.cn/"};;
    NSDictionary *dProd = @{@"name":@"广东移动新一代综合资源系统",@"desc":@"广东电信MBOSS子系统之一的资源配置系统",@"iconURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg",@"detailURL":@"http://img1.xcar.com.cn/drive/"};;
    NSArray *objects = [NSArray arrayWithObjects:aProd,bProd,cProd,dProd, nil];
    NSMutableArray *products = [NSMutableArray new];
    for (id obj in objects) {
        if([obj isKindOfClass:[NSDictionary class]]){
            [products addObject:[iplbProjectDetail productWithDictionary:obj]];
        }
    }
    NSLog(@"count=>%lu",(unsigned long)[objects count]);
    return products;
}

@end
