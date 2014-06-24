//
//  iplbiPadNewContentViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-24.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbiPadNewContentViewController.h"

@interface iplbiPadNewContentViewController ()
@property UITextView *textview;

@end

@implementation iplbiPadNewContentViewController

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
    self.textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 350, 180)];
    self.textview.text = self.newsContent;
    [self.view addSubview:self.textview];
    
    [self.textview sizeToFit]; //added
    [self.textview layoutIfNeeded]; //added
    CGRect frame = self.textview.frame;
    [self.textview setFrame:frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(iplbiPadNewContentViewController *) initWithNewContent:(NSString *) content
{
    self = [super init];
    if (self) {
        [self setNewsContent:content];
    }
    return self;
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

@end
