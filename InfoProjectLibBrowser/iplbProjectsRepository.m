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
    NSLog(@"%@",[iplbConfiguration getConfiguration:@"ServerRoot"]);
    NSString *projectsAllUrlStr = [NSString stringWithFormat:@"%@%@",[iplbConfiguration getConfiguration:@"ServerRoot"],[iplbConfiguration getConfiguration:@"ProjectList"]];
    NSString *projectInfosJSON =[NSString stringWithContentsOfURL:[NSURL URLWithString:projectsAllUrlStr] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* objects = [NSJSONSerialization
                       JSONObjectWithData:[projectInfosJSON dataUsingEncoding:NSUTF8StringEncoding]
                       options:0
                       error:nil];
    
    //测试数据
    /**
    NSDictionary *aProd = @{@"name":@"广东电信资源配置系统",@"desc":@"广东电信MBOSS核心系统",@"iconURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg",@"detailURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg"};
    NSDictionary *bProd = @{@"name":@"广东电信室内覆盖系统",@"desc":@"室内覆盖专家系统",@"iconURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg",@"detailURL":@"http://img1.xcar.com.cn/"};
    NSDictionary *cProd = @{@"name":@"深圳移动基站信息系统",@"desc":@"基站管理配置系统",@"iconURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg",@"detailURL":@"http://img1.xcar.com.cn/"};;
    NSDictionary *dProd = @{@"name":@"湖南电信号百系统",@"desc":@"号百管理系统",@"iconURL":@"http://img1.xcar.com.cn/drive/10628/10703/20140117163830227661.jpg",@"detailURL":@"http://img1.xcar.com.cn/drive/"};;
    NSArray *objects = [NSArray arrayWithObjects:aProd,bProd,cProd,dProd, nil];
     */
    NSMutableArray *products = [NSMutableArray new];
    for (id obj in objects) {
        if([obj isKindOfClass:[NSDictionary class]]){
            [products addObject:[iplbProjectDetail projectSummaryWithDictionary:obj]];
        }
    }
    NSLog(@"count=>%lu",(unsigned long)[objects count]);
    return products;
}

-(iplbProjectDetail *) getProjectDetailInfo:(NSString *)url
{
    NSString *projectDetailJSON =[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",projectDetailJSON);
    NSDictionary *projectDetailDic = [NSJSONSerialization
                        JSONObjectWithData:[projectDetailJSON dataUsingEncoding:NSUTF8StringEncoding]
                        options:0
                        error:nil];
    /**
    NSArray *screenShots = @[@"http://img3.douban.com/view/photo/raw/public/p1346756970.jpg",@"http://img3.douban.com/view/photo/raw/public/p1346756970.jpg",@"http://img3.douban.com/view/photo/raw/public/p1346756970.jpg"];
    NSDictionary *projectDetailDic = @{@"name":@"广东电信资源配置系统",@"desc":@"广东电信MBOSS核心系统",@"iconURL":@"http://img3.douban.com/view/photo/raw/public/p1346756970.jpg",@"detailInfo":@"为了应对愈演愈烈的温室效应，世界各国在2014年发射了代号CW-7的冷冻剂，谁知却将地球推入了万劫不复的极寒深渊。大多数的人类死于寒冷与恐慌，只有为数不多的数千人登上了威尔福德工业开发的列车，成为永不停歇的流浪者。这列火车借助威尔福德（艾德·哈里斯 Ed Harris 饰）开发的永动引擎，并且配备各种完备设施，在之后的十七年里构建了属于自己的独立生态系统，周而复始旋转在43.8万公里的漫长旅途中。生活在末尾车厢的底层人民一直饱受压迫，为了争取自由和权力，他们在过去发起过多次暴动，但无疑例外均以失败告终。这一次，拥有领袖气质的柯蒂斯（克里斯·埃文斯 Chris Evans 饰）试图找到被囚禁的安保设计师南宫民秀（宋康昊 饰），借助他之手打开通往首节车厢的重重大门，推翻威尔福德的统治。",@"screenShots":screenShots};
     **/
    return [iplbProjectDetail projectDetailWithDictionary:projectDetailDic];
}

@end
