//
//  iplbProjectLabelRepository.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-19.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbProjectLabelRepository.h"
#import "iplbProjectLabel.h"
#import "iplbConfiguration.h"

@implementation iplbProjectLabelRepository
-(NSMutableArray *) getAllLabels
{
    NSString *projectLabels = [NSString stringWithFormat:@"%@%@",[iplbConfiguration getConfiguration:@"ServerRoot"],[iplbConfiguration getConfiguration:@"ProjectLabels"]];
    NSDictionary *responseDict = [super dictionaryFromHTTPResponseJSON:projectLabels];
    NSMutableArray *labels = [NSMutableArray new];
    if([responseDict objectForKey:@"returnArray"]){
        NSArray* objects = [responseDict objectForKey:@"returnArray"];
        for (id obj in objects) {
            if([obj isKindOfClass:[NSDictionary class]]){
                [labels addObject:[iplbProjectLabel labelWithDictionary:obj]];
            }
        }
    }
    return labels;
}
@end
