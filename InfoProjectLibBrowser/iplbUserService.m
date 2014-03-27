//
//  iplbUserService.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-26.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbUserService.h"
#import "iplbConfiguration.h"
#import "iplbOperationResult.h"

@implementation iplbUserService
+(iplbOperationResult *) isValidUser:(NSString *)userCode password:(NSString *)aPassword
{
    NSString *userQueryRootURL = [NSURL URLWithString:
                                  [NSString stringWithFormat:@"%@%@",
                                   [iplbConfiguration getConfiguration:@"ServerRoot"],
                                   [iplbConfiguration getConfiguration:@"UserSearch"]]];
    NSString *userQueryURL = [NSString stringWithFormat:@"%@?userCode=%@&userPwd=%@",userQueryRootURL,userCode,aPassword];
    NSError *requestError;
    NSString *userInfoJSON =[NSString stringWithContentsOfURL:[NSURL URLWithString:userQueryURL] encoding:NSUTF8StringEncoding error:&requestError];
    iplbOperationResult *result = [iplbOperationResult new];
    if(!userInfoJSON){
        result.optResult = NO;
        result.message = @"服务器未响应,请稍后重试!";
    }else{
        NSDictionary *userInfoDic = [NSJSONSerialization
                                     JSONObjectWithData:[userInfoJSON dataUsingEncoding:NSUTF8StringEncoding]
                                     options:0
                                     error:nil];
        if(!userInfoDic){
            result.optResult = NO;
            result.message =@"服务端返回JSON格式异常";
        }else{
            NSNumber *jsonResult = [userInfoDic valueForKey:@"result"];
            if([jsonResult boolValue]){
                result.optResult = YES;
            }else{
                result.optResult = NO;
                result.message = [userInfoDic valueForKey:@"message"];
            }
        }
    }
    return result;
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
