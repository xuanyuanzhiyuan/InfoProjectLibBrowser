//
//  iplbConfiguration.h
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iplbConfiguration : NSObject
+(NSString *) getConfiguration:(NSString *) key;
+(void) saveConfiguration:(NSString *)key value:(NSString *) aValue;
+(void) saveConfigurationWithDictionary:(NSDictionary *)dic;
+(void) removeConfiguration:(NSString *) key;
@end
