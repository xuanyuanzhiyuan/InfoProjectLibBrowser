//
//  iplbUserLoginViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-23.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbUserLoginViewController.h"
#import "iplbUserService.h"
#import "iplbOperationResult.h"

@interface iplbUserLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userCode;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation iplbUserLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.password.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    BOOL hasInputAll = YES;
    if([self.userCode.text isEqualToString:@""]){
        self.userCode.layer.cornerRadius = 8.0f;
        self.userCode.layer.masksToBounds = YES;
        self.userCode.layer.borderColor = [[UIColor redColor] CGColor];
        self.userCode.layer.borderWidth = 1.0f;
        hasInputAll = NO;
    }
    if([self.password.text isEqualToString:@""]){
        self.password.layer.cornerRadius = 8.0f;
        self.password.layer.masksToBounds = YES;
        self.password.layer.borderColor = [[UIColor redColor] CGColor];
        self.password.layer.borderWidth = 1.0f;
        hasInputAll = NO;
    }
    if(hasInputAll){
        iplbOperationResult *isValidUser = [iplbUserService isValidUser:self.userCode.text password:self.password.text];
        if (isValidUser.optResult) {
            //登录结果写入plist
            [iplbUserService writeUserLoginInfo:self.userCode.text userName:self.userCode.text ];
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:isValidUser.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名和密码后再提交" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.password) {
        [textField resignFirstResponder];
        [self login:nil];
        return YES;
    }
    return YES;
}
- (IBAction)skipLogin:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
