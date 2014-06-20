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
    label.chnName = [dic valueForKey:@"chnName"];
    label.labelCode = [dic valueForKey:@"labelCode"];
    return label;
}
@end
