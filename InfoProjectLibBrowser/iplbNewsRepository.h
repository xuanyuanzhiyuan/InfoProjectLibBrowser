//
//  iplbNewsRepository.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-21.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iplbNews.h"
#import "iplbBaseRepository.h"

@interface iplbNewsRepository : iplbBaseRepository
-(NSMutableArray *) getAllNews;
-(iplbNews *) getNewsDetail:(NSString *)url;
@end
