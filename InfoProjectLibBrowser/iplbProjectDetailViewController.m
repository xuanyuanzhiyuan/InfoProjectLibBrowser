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
            [self.screenShotsScrollView addSubview:imgView];
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
    //设置字体
    int fontSize = 80;
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    [aWebView stringByEvaluatingJavaScriptFromString:jsString];
    //设置WebView高度
//    CGRect frame = aWebView.frame;
//    frame.size.height = 1;
//    aWebView.frame = frame;
//    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    aWebView.frame = frame;


    
//    [self.tableView beginUpdates];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
    //change height
    NSString *contentHeight = [self.detailInfoWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
    CGRect frame = self.detailInfoWebView.frame;
    frame.size.height = 1;
    self.detailInfoWebView.frame = frame;
    frame.size.height = [contentHeight floatValue];
    self.detailInfoWebView.frame = frame;
    self.webViewHeight = [contentHeight intValue];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 90;
    if (indexPath.section == 0) {
        height = 105;
    }
    if (indexPath.section == 1) {
        height = 250;
    }
    if (indexPath.section == 2) {
        if (!self.webViewHeight) {
            height = 300;
        }else{
            height = self.webViewHeight;
        }
    }
    NSLog(@"table row %li height %f",indexPath.section,height);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailIconCell"];
    }
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailScreenshotsCell"];
    }
    if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailInfoCell"];
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    if (indexPath.section == 0) {
        //create header row
        cell.imageView.frame = CGRectMake(8,8,90,90);
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 10;
        [cell.imageView setImageWithURL:[NSURL URLWithString:projectDetail.iconURL]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.textLabel.text = projectDetail.projectName;
    }
    if (indexPath.section == 1) {
        self.screenShotsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 0, 304, 320)];
        self.screenShotsScrollView.contentSize = CGSizeMake(160 * [projectDetail.screenShots count], 250);
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
            [self.screenShotsScrollView addSubview:img];
            scrollWidth = scrollWidth + 160;
        }
        [cell addSubview:self.screenShotsScrollView];
    }
    if (indexPath.section == 2) {
        self.detailInfoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(8, 0, 304, 300)];
        [self.detailInfoWebView loadHTMLString:projectDetail.detailInfo baseURL:nil];
        [self.detailInfoWebView setDelegate:self];
        [cell addSubview:self.detailInfoWebView];
    }
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = nil;
    switch (section) {
        case 0:
            sectionTitle = @"";
            break;
        case 1:
            sectionTitle = @"运行截图";
            break;
        case 2:
            sectionTitle = @"详情";
            break;
        default:
            sectionTitle = @" 未知";
            break;
    }
    return sectionTitle;
}
@end
