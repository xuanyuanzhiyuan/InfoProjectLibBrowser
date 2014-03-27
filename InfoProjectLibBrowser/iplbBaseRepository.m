//
//  iplbBaseRepository.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-27.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbBaseRepository.h"
#include "ASIHTTPRequest.h"

@implementation iplbBaseRepository
-(NSMutableDictionary *) dictionaryFromHTTPResponseJSON:(NSString *)url
{
    NSMutableDictionary *responseDict = [NSMutableDictionary new];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    NSError *error = [request error];
    if(!error){
        [responseDict setObject:@1 forKey:@"didHTTPResponseCorrectly"];
        NSString *json = [request responseString];
        id resultObj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if(resultObj){
            [responseDict setObject:@0 forKey:@"isCorrectJSONFormat"];
            if([resultObj isKindOfClass:[NSDictionary class]]){
                [responseDict setObject:resultObj forKey:@"returnDictionary"];
            }
            if([resultObj isKindOfClass:[NSArray class]]){
                [responseDict setObject:resultObj forKey:@"returnArray"];
            }
        }else{
           [responseDict setObject:NO forKey:@"isCorrectJSONFormat"];
        }
    }else{
        [responseDict setObject:@0 forKey:@"didHTTPResponseCorrectly"];
    }
    return responseDict;
}

@end
