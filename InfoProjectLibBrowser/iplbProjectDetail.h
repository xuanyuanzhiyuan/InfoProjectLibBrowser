//
//  iplbProjectDetail.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iplbProjectDetail : NSObject
@property NSString *projectName;
@property NSString *projectDesc;
@property NSString *iconURL;
@property NSString *detailURL;
@property NSString *detailInfo;
@property NSArray *screenShots;
+(iplbProjectDetail *) projectSummaryWithDictionary:(NSDictionary *) dic;
+(iplbProjectDetail *) projectDetailWithDictionary:(NSDictionary *) dic;
@end
