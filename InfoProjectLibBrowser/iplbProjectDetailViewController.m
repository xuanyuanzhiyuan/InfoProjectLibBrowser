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
    self.pageScrollView.contentSize = CGSizeMake(300, 3000);
    iplbProjectsRepository * resp = [iplbProjectsRepository new];
	projectDetail = [resp getProjectDetailInfo:self.detailURL];
    self.detailText.text = projectDetail.detailInfo;
    self.nameLabel.text = projectDetail.projectName;
    self.descLabel.text = projectDetail.projectDesc;
    NSURL *url = [NSURL URLWithString:projectDetail.iconURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.iconImage.image = [[UIImage alloc] initWithData:data];
    //显示截图
    self.scrollView.contentSize = CGSizeMake(150 * [projectDetail.screenShots count], 200);
    int scrollWidth=0;
    for (NSString *screenshotsURL in projectDetail.screenShots){
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(scrollWidth, 0, 150, 200)];
        NSURL *url = [NSURL URLWithString:screenshotsURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        img.image = [[UIImage alloc] initWithData:data];
        [self.scrollView addSubview:img];
        scrollWidth = scrollWidth + 150;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
