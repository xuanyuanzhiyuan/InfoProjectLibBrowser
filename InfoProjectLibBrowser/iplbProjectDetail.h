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
@property NSString *ProjectDesc;
@property NSString *iconURL;
@property NSString *detailURL;
+(iplbProjectDetail *) productWithDictionary:(NSDictionary *)dic;
@end
