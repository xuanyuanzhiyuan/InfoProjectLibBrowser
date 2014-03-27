//
//  iplbProjectCategory.h
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-27.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iplbProjectCategory : NSObject
@property NSString *name;
@property NSString *code;
+(iplbProjectCategory *) categoryWithDictionary:(NSDictionary *)dic;
@end
