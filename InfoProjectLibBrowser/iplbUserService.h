//
//  iplbUserService.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-26.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iplbOperationResult.h"

@interface iplbUserService : NSObject
+(iplbOperationResult *) isValidUser:(NSString *)userCode password:(NSString *) aPassword;
+(BOOL) isUserNeedLogin;
+(void) writeUserLoginInfo:(NSString *)userCode;
+(void) logout;
+(iplbOperationResult *) modifyUserPassword:(NSString *)aNewPasswd oldPasswd:(NSString *) aOldPassword;
@end
