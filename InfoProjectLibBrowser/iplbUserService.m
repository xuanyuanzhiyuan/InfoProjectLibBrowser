//
//  iplbUserService.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-26.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbUserService.h"
#import "iplbConfiguration.h"
#import "iplbOperationResult.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation iplbUserService
+(iplbOperationResult *) isValidUser:(NSString *)userCode password:(NSString *)aPassword
{
    NSString *userQueryRootURL = [NSURL URLWithString:
                                  [NSString stringWithFormat:@"%@%@",
                                   [iplbConfiguration getConfiguration:@"ServerRoot"],
                                   [iplbConfiguration getConfiguration:@"UserSearch"]]];
    NSString *userQueryURL = [NSString stringWithFormat:@"%@?userCode=%@&userPwd=%@",userQueryRootURL,userCode,aPassword];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:userQueryURL]];
    [request startSynchronous];
    NSError *error = [request error];
    iplbOperationResult *result = [iplbOperationResult new];
    if(!error){
        NSString *json = [request responseString];
        NSDictionary *userInfoDic = [NSJSONSerialization
                                     JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
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
    }else{
        result.optResult = NO;
        result.message = @"服务器响应异常，请稍后重试!";
    }
    return result;
}

+(BOOL) isUserNeedLogin
{
    NSString *loginInfo = [iplbConfiguration getUserLoginInfo:@"LoginUserCode"];
    return loginInfo == nil;
}

+(void) writeUserLoginInfo:(NSString *)userCode;
{
    [iplbConfiguration saveUserLongInfo:@"LoginUserCode" value:userCode fileName:[iplbConfiguration getConfiguration:@"UserLoginFileName"]];
}

+(void) logout
{
    [iplbConfiguration removeConfiguration:@"LoginUserCode"];
    [iplbConfiguration removeConfiguration:@"LoginUserName"];
}

+(iplbOperationResult *) modifyUserPassword:(NSString *)aNewPasswd oldPasswd:(NSString *)aOldPassword
{
    iplbOperationResult *result = [iplbOperationResult new];
    NSString *userCode = [iplbConfiguration getUserLoginInfo:@"LoginUserCode"];
    if(!userCode){
        result.optResult = NO;
        result.message = @"用户并未登录!";
        return result;
    }
    NSString *userQueryRootURL = [NSURL URLWithString:
                                  [NSString stringWithFormat:@"%@%@",
                                   [iplbConfiguration getConfiguration:@"ServerRoot"],
                                   [iplbConfiguration getConfiguration:@"UserInfo"]]];
    NSString *userInfoURL = [NSString stringWithFormat:@"%@/%@/changepwd",userQueryRootURL,userCode];
    //ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:userInfoURL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:userInfoURL]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:userCode forKey:@"userCode"];
    [request setPostValue:aNewPasswd forKey:@"newPassword"];
    [request setPostValue:aOldPassword forKey:@"userPwd"];
    [request startSynchronous];
    NSError *error = [request error];
    if(!error){
        NSString *json = [request responseString];
        NSDictionary *userInfoDic = [NSJSONSerialization
                                     JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
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
    }else{
        result.optResult = NO;
        result.message = @"服务器响应异常，请稍后重试!";
    }
    return result;
}
@end
