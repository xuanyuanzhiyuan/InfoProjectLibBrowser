//
//  iplbUserService.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-26.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbUserService.h"
#import "iplbConfiguration.h"

@implementation iplbUserService
+(BOOL) isValidUser:(NSString *)userCode password:(NSString *)aPassword
{
    NSString *userQueryRootURL = [NSURL URLWithString:
                                  [NSString stringWithFormat:@"%@%@",
                                   [iplbConfiguration getConfiguration:@"ServerRoot"],
                                   [iplbConfiguration getConfiguration:@"UserSearch"]]];
    NSString *userQueryURL = [NSString stringWithFormat:@"%@?userCode=%@&userPwd=%@",userQueryRootURL,userCode,aPassword];
    NSString *userInfoJSON =[NSString stringWithContentsOfURL:[NSURL URLWithString:userQueryURL] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *userInfoDic = [NSJSONSerialization
                                      JSONObjectWithData:[userInfoJSON dataUsingEncoding:NSUTF8StringEncoding]
                                      options:0
                                      error:nil];
    NSString *result = [userInfoDic valueForKey:@"result"];
    if([result isEqualToString:@"true"]){
        return YES;
    }
    return NO;
}

+(BOOL) isUserNeedLogin
{
    NSString *loginInfo = [iplbConfiguration getConfiguration:@"LoginUserCode"];
    return loginInfo == nil;
}

+(void) writeUserLoginInfo:(NSString *)userCode userName:(NSString *)aUsername
{
    NSDictionary *dic = @{@"LoginUserCode":userCode,@"LoginUserName":aUsername};
    [iplbConfiguration saveConfigurationWithDictionary:dic];
}

+(void) logout
{
    [iplbConfiguration removeConfiguration:@"LoginUserCode"];
    [iplbConfiguration removeConfiguration:@"LoginUserName"];
}
@end
