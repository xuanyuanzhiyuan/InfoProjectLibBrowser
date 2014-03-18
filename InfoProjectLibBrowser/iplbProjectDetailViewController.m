//
//  iplbProjectDetailViewController.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-17.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbProjectDetailViewController.h"
#import "iplbProjectDetail.h"
#import "iplbProjectsRepository.h"

@interface iplbProjectDetailViewController ()

@end

@implementation iplbProjectDetailViewController

iplbProjectDetail *projectDetail;

@synthesize scrollView;
@synthesize pageControl;
@synthesize nameLabel;
@synthesize descText;
@synthesize iconImage;
@synthesize detailText;

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
    iplbProjectsRepository * resp = [iplbProjectsRepository new];
	projectDetail = [resp getProjectDetailInfo:self.detailURL];
    self.detailText.text = projectDetail.detailInfo;
    self.nameLabel.text = projectDetail.projectName;
    self.descText.text = projectDetail.projectDesc;
    NSURL *url = [NSURL URLWithString:projectDetail.iconURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.iconImage.image = [[UIImage alloc] initWithData:data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
