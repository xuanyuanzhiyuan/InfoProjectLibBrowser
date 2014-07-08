//
//  iplbProjectLabel.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-19.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbProjectLabel.h"

@implementation iplbProjectLabel
+(iplbProjectLabel *) labelWithDictionary:(NSDictionary *)dic
{
    iplbProjectLabel *label = [[iplbProjectLabel alloc] init];
    label.label = [dic valueForKey:@"label"];
    return label;
}
@end
