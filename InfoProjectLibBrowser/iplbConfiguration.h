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
+(NSString *) getUserLoginInfo:(NSString *) key;
+(void) saveUserLongInfo:(NSString *)key value:(NSString *) aValue fileName:(NSString *)aFileName;
+(void) saveConfigurationWithDictionary:(NSDictionary *)dic;
+(void) removeUserLoginInfo:(NSString *)fileName;
+(void) removeConfiguration:(NSString *) key;
@end
