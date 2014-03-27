//
//  iplbProjectCategoryRepository.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-27.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbProjectCategoryRepository.h"
#import "iplbConfiguration.h"
#import "iplbProjectCategory.h"

@implementation iplbProjectCategoryRepository
-(NSMutableArray *) getAllProjectCategories
{
        NSString *projectCategories = [NSString stringWithFormat:@"%@%@",[iplbConfiguration getConfiguration:@"ServerRoot"],[iplbConfiguration getConfiguration:@"ProjectCategories"]];
    NSDictionary *responseDict = [super dictionaryFromHTTPResponseJSON:projectCategories];
    NSMutableArray *categories = [NSMutableArray new];
    if([responseDict objectForKey:@"returnArray"]){
        NSArray* objects = [responseDict objectForKey:@"returnArray"];
        for (id obj in objects) {
            if([obj isKindOfClass:[NSDictionary class]]){
                [categories addObject:[iplbProjectCategory categoryWithDictionary:obj]];
            }
        }
    }
    return categories;
}
@end
