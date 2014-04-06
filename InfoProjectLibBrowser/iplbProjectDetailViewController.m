//
//  iplbProjectDetailViewController.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-17.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbProjectDetailViewController.h"
#import "iplbProjectDetail.h"
#import "iplbProjectsRepository.h"
#import "iplbAppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface iplbProjectDetailViewController ()

@end

@implementation iplbProjectDetailViewController

iplbProjectDetail *projectDetail;

BOOL hasTapEventResponsing = NO;

@synthesize scrollView;
@synthesize pageScrollView;
@synthesize pageControl;
@synthesize nameLabel;
@synthesize descLabel;
@synthesize iconImage;
@synthesize detailText;
@synthesize detailTextWebView;

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
    isFullScreen = NO;
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
    [self.detailTextWebView loadHTMLString:projectDetail.detailInfo baseURL:nil];
    //调整WebView高度(delegate方式)
    self.detailTextWebView.delegate = self;
    self.nameLabel.text = projectDetail.projectName;
    self.descLabel.text = projectDetail.projectDesc;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = 10;
    [self.iconImage setImageWithURL:[NSURL URLWithString:projectDetail.iconURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    //显示截图
    self.scrollView.contentSize = CGSizeMake(160 * [projectDetail.screenShots count], 250);
    int scrollWidth=0;
    for (NSString *screenshotsURL in projectDetail.screenShots){
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(scrollWidth, 0, 150, 250)];
        [img setImageWithURL:[NSURL URLWithString:screenshotsURL]
            placeholderImage:[UIImage imageNamed:@"screen_placeholder.png"]];
        //手势识别,增加点击全屏显示功能
        UITapGestureRecognizer *guestRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickScreenShot:)];
        guestRecognizer.numberOfTapsRequired = 1;
        guestRecognizer.numberOfTouchesRequired = 1;
        [img addGestureRecognizer:guestRecognizer];
        [img setUserInteractionEnabled:YES];
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

-(void) clickScreenShot:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%@", [gestureRecognizer view]);
    if(hasTapEventResponsing)
        return;
    UIImageView *imgView = (UIImageView *)[gestureRecognizer view];
    iplbAppDelegate *appDelegate = (iplbAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIImageView *copyImgView = imgView;
    [appDelegate.window addSubview:copyImgView];
    //进入全屏
    if (!isFullScreen) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            //save previous frame
            prevFrame = imgView.frame;
            [copyImgView setFrame:[[UIScreen mainScreen] bounds]];
            //[copyImgView setFrame:CGRectMake(0, 0, imgView.image.size.width, imgView.image.size.height)];
            hasTapEventResponsing = YES;
        }completion:^(BOOL finished){
            isFullScreen = YES;
            hasTapEventResponsing = NO;

        }];
        return;
    }else{
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [self.scrollView addSubview:imgView];
            [imgView setFrame:prevFrame];
            hasTapEventResponsing = YES;
        }completion:^(BOOL finished){
            isFullScreen = NO;
            hasTapEventResponsing = NO;
            
        }];
        return;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    int fontSize = 80;
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    [aWebView stringByEvaluatingJavaScriptFromString:jsString];
}
@end
