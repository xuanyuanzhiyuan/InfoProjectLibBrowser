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
#import <SDWebImage/UIImageView+WebCache.h>

@interface iplbProjectDetailViewController ()

@end

@implementation iplbProjectDetailViewController

iplbProjectDetail *projectDetail;

@synthesize scrollView;
@synthesize pageScrollView;
@synthesize pageControl;
@synthesize nameLabel;
@synthesize descLabel;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    iplbProjectsRepository * resp = [iplbProjectsRepository new];
	projectDetail = [resp getProjectDetailInfo:self.detailURL];
    self.detailText.text = projectDetail.detailInfo;
    self.nameLabel.text = projectDetail.projectName;
    self.descLabel.text = projectDetail.projectDesc;
    [self.iconImage setImageWithURL:[NSURL URLWithString:projectDetail.iconURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    //显示截图
    self.scrollView.contentSize = CGSizeMake(160 * [projectDetail.screenShots count], 250);
    int scrollWidth=0;
    for (NSString *screenshotsURL in projectDetail.screenShots){
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(scrollWidth, 0, 150, 250)];
        [img setImageWithURL:[NSURL URLWithString:screenshotsURL]
            placeholderImage:[UIImage imageNamed:@"screen_placeholder.png"]];
        [self.scrollView addSubview:img];
        scrollWidth = scrollWidth + 160;
    }
    [self.detailText sizeToFit];
    [self.detailText layoutIfNeeded];
    CGRect frame = self.detailText.frame;
    frame.size.height = self.detailText.contentSize.height;
    self.detailText.frame = frame;
    self.pageScrollView.contentSize = CGSizeMake(300, 3000);
}
@end
