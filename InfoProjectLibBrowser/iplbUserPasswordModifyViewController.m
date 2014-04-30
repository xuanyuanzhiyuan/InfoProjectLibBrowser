//
//  iplbUserPasswordModifyViewController.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-29.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbUserPasswordModifyViewController.h"
#import "iplbUserService.h"
#import "iplbUserLoginViewController.h"

@interface iplbUserPasswordModifyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswdTextField;
@property (weak, nonatomic) IBOutlet UITextField *theNewPasswdTextField;
@property (weak, nonatomic) IBOutlet UITextField *repNewPwdTextfield;

@end

@implementation iplbUserPasswordModifyViewController

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
    self.oldPasswdTextField.delegate = self;
    self.theNewPasswdTextField.delegate = self;
    self.repNewPwdTextfield.delegate = self;
    [self.oldPasswdTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelUserPasswordModify:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)modifyUserPassword:(id)sender {
    BOOL hasBlankInput = [self.oldPasswdTextField.text isEqualToString:@""]||[self.theNewPasswdTextField.text isEqualToString:@""]||[self.repNewPwdTextfield.text isEqualToString:@""];
    if(hasBlankInput){
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入原密码和新密码后再提交!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }else{
        if(![self.theNewPasswdTextField.text isEqualToString:self.repNewPwdTextfield.text]){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的新密码不一致,请检查您的输入!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }else{
            [self asyncModifyPasswdAndUpdateUI];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.oldPasswdTextField) {
        [self.theNewPasswdTextField becomeFirstResponder];
        return YES;
    }
    if (textField == self.theNewPasswdTextField) {
        [self.repNewPwdTextfield becomeFirstResponder];
        return YES;
    }
    if (textField == self.repNewPwdTextfield) {
        [self.repNewPwdTextfield resignFirstResponder];
        [self modifyUserPassword:self];
        return YES;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.shouldDismiss)
        [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void) asyncModifyPasswdAndUpdateUI
{
    static iplbOperationResult *result;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_sync(queue,^{
            result = [iplbUserService modifyUserPassword:self.theNewPasswdTextField.text oldPasswd:self.oldPasswdTextField.text];
        });
        dispatch_sync(dispatch_get_main_queue(),^{
            if(result.optResult){
//                [iplbUserService logout];
                self.shouldDismiss = YES;
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功，建议注销后重新登录!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@%@",@"密码修改失败,原因:",result.message];
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:msg
                                                                 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        });
    });
}
@end
