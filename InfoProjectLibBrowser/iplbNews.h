//
//  iplbNews.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-21.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iplbNews : NSObject
@property NSString *detailURL;
@property NSString *title;
@property NSString *summary;
@property NSString *newsPictureURL;
@property NSString *content;
+(iplbNews *) newsWithDictionary:(NSDictionary *)dic;
+(iplbNews *) newsSummaryWithDictionary:(NSDictionary *)dic;
@end
