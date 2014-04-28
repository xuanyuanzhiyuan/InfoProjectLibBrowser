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
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

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
    self.userCode.delegate = self;
    [self.userCode becomeFirstResponder];
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
        //异步操作
        [self.loginButton setUserInteractionEnabled:NO];
        [self asyncRequestProjectCategoriesAndUpdateUI];
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名和密码后再提交" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.userCode){
        [self.password becomeFirstResponder];
    }
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


-(void) asyncRequestProjectCategoriesAndUpdateUI
{
    static iplbOperationResult *isValidUser;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_sync(queue,^{
            isValidUser = [iplbUserService isValidUser:self.userCode.text password:self.password.text];
        });
        dispatch_sync(dispatch_get_main_queue(),^{
            if (isValidUser.optResult) {
                //修改登录全局变量
                isPassLoginView = YES;
                //登录结果写入plist
                [iplbUserService writeUserLoginInfo:isValidUser.userCode userName:isValidUser.userName];
                self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:isValidUser.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [self.loginButton setUserInteractionEnabled:YES];
            }
        });
    });
}
@end
