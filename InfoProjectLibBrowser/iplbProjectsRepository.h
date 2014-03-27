//
//  iplbProjectsRepository.h
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iplbProjectDetail.h"

@interface iplbProjectsRepository : NSObject
-(NSMutableArray *) getAllProjectInfos;
-(NSMutableArray *) getProjectInfosWithCategory:(NSString *)categoryCode;
-(iplbProjectDetail *) getProjectDetailInfo:(NSString *)url;
@end
