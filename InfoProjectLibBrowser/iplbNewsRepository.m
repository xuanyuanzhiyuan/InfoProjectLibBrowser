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
+(NSMutableArray *) getAllNews
{
    /**
    NSDictionary *aProd = @{@"title":@"广东电信资源配置系统发布V1.2.5版本",@"desc":@"2014年3月15日发布V1.2.4版本",@"newsPicURL":@"http://img3.douban.com/view/photo/raw/public/p1346756970.jpg",@"detailURL":@"http://xxxx.xxx.xxxx/news/3432"};
    NSDictionary *bProd = @{@"title":@"基站信息系统发布2.0版本",@"desc":@"2014年3月15日发布V1.2.4版本",@"newsPicURL":@"http://img3.douban.com/view/photo/raw/public/p1346756970.jpg",@"detailURL":@"http://xxxx.xxx.xxxx/news/3432"};
    NSDictionary *cProd = @{@"title":@"广东电信规划设计院获得广东省企业技术中心称号",@"desc":@"2014年3月15日发布V1.2.4版本",@"newsPicURL":@"http://img3.douban.com/view/photo/raw/public/p1346756970.jpg",@"detailURL":@"http://xxxx.xxx.xxxx/news/3432"};;
    NSDictionary *dProd = @{@"title":@"广东电信规划设计院中标XX项目",@"desc":@"2014年3月15日发布V1.2.4版本",@"newsPicURL":@"http://img3.douban.com/view/photo/raw/public/p1346756970.jpg",@"detailURL":@"http://xxxx.xxx.xxxx/news/3432"};
    NSArray *data = [NSArray arrayWithObjects:aProd,bProd,cProd,dProd, nil];
     **/
    NSString *newsListUrl = [NSString stringWithFormat:@"%@%@",[iplbConfiguration getConfiguration:@"ServerRoot"],[iplbConfiguration getConfiguration:@"NewsList"]];
    NSString *newsJSON =[NSString stringWithContentsOfURL:[NSURL URLWithString:newsListUrl] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *newsDicArray = [NSJSONSerialization
                        JSONObjectWithData:[newsJSON dataUsingEncoding:NSUTF8StringEncoding]
                        options:0
                        error:nil];
    NSMutableArray *news = [NSMutableArray new];
    for (id obj in newsDicArray) {
        if([obj isKindOfClass:[NSDictionary class]]){
            [news addObject:[iplbNews newsSummaryWithDictionary:obj]];
        }
    }
    return news;
}

+(iplbNews *) getNewsDetail:(NSString *)url
{
    /**
    NSDictionary *projectDetailDic = @{@"title":@"广东电信规划设计院中标XX项目",@"desc":@"2014年3月15日发布V1.2.4版本",@"newsPicURL":@"http://img3.douban.com/view/photo/raw/public/p1346756970.jpg",@"content":@"通过布登勃洛克家族在垄断资产阶级家族的排挤、打击下逐渐衰落的历史描写，详细的揭示了资本主义的旧的刻意盘剥和新的掠夺兼并方式的激烈竞争和历史成败，成为德国19世纪后半期社会发展的艺术缩影。但因作者受叔本华、尼采哲学思想的影响，小说对帝国主义势力持无能为力的消极态度，对自由资产阶级抱无可奈何的哀惋情绪。"};
     **/
    NSString *newsDetailJSON =[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *newsDetailDic = [NSJSONSerialization
                             JSONObjectWithData:[newsDetailJSON dataUsingEncoding:NSUTF8StringEncoding]
                             options:0
                             error:nil];
    return [iplbNews newsWithDictionary:newsDetailDic];
}
@end
