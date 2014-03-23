//
//  iplbUserLoginViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-23.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbUserLoginViewController.h"

@interface iplbUserLoginViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
  	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
