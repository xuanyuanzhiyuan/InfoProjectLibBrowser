//
//  iplbProjectCategory.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-27.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbProjectCategory.h"

@implementation iplbProjectCategory
+(iplbProjectCategory *) categoryWithDictionary:(NSDictionary *)dic
{
    iplbProjectCategory *category = [iplbProjectCategory new];
    category.name = [dic valueForKey:@"name"];
    category.code = [dic valueForKey:@"code"];
    return category;
}
@end
