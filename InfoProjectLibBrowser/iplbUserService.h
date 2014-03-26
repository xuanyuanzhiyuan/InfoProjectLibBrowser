//
//  iplbUserService.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-26.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iplbUserService : NSObject
+(BOOL) isValidUser:(NSString *)userCode password:(NSString *) aPassword;
+(BOOL) isUserNeedLogin;
+(void) writeUserLoginInfo:(NSString *)userCode userName:(NSString *) aUsername;
+(void) logout;
@end
