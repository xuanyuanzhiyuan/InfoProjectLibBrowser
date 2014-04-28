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
#import "iplbScreenshotsGalleryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface iplbProjectDetailViewController ()
@property(strong,nonatomic)iplbScreenshotsGalleryViewController *screenshotsGalleryViewController;

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
    hasFinishCreateTable = NO;
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
    self.screenshotsGalleryViewController = [[iplbScreenshotsGalleryViewController alloc] init];
    self.screenshotsGalleryViewController.screenShots = projectDetail.screenShots;
    self.screenshotsGalleryViewController.isDesktop = [projectDetail.platformType isEqualToString:@"desktop"];
    [self presentViewController:self.screenshotsGalleryViewController animated:YES completion:nil];
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
    frame.size.height = [contentHeight floatValue]+20;
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
            height = self.webViewHeight+20;
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
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 90, 90)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10;
        [imageView setImageWithURL:[NSURL URLWithString:projectDetail.iconURL]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [cell.contentView addSubview:imageView];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 8, 208, 28)];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        nameLabel.text = projectDetail.projectName;
        [cell.contentView addSubview:nameLabel];
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 25, 208, 70)];
        [descLabel setFont:[UIFont systemFontOfSize:12]];
        descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descLabel.numberOfLines = 0;
        descLabel.textColor = [UIColor darkGrayColor];
        descLabel.text = projectDetail.projectDesc;
        [cell.contentView addSubview:descLabel];
    }
    if (indexPath.section == 1 && !hasFinishCreateTable) {
        int screenShotWidth = 140;
        int screentShotHeight = 210;
        if([projectDetail.platformType isEqualToString:@"desktop"]){
            screenShotWidth = 280;
            screentShotHeight = 210;
        }
        int imageViewY = (250-screentShotHeight)/2;
        self.screenShotsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 0, 304, 250)];
        self.screenShotsScrollView.contentSize = CGSizeMake((screenShotWidth+10) * [projectDetail.screenShots count], screentShotHeight);
        int scrollWidth=0;
        for (NSString *screenshotsURL in projectDetail.screenShots){
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(scrollWidth, imageViewY, screenShotWidth, screentShotHeight)];
            [img setImageWithURL:[NSURL URLWithString:screenshotsURL]
                placeholderImage:[UIImage imageNamed:@"screen_placeholder.png"]];
            //手势识别,增加点击全屏显示功能
            UITapGestureRecognizer *guestRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickScreenShot:)];
            guestRecognizer.numberOfTapsRequired = 1;
            guestRecognizer.numberOfTouchesRequired = 1;
            [img addGestureRecognizer:guestRecognizer];
            [img setUserInteractionEnabled:YES];
            [self.screenShotsScrollView addSubview:img];
            scrollWidth = scrollWidth + (screenShotWidth+10);
        }
        [cell addSubview:self.screenShotsScrollView];
        hasFinishCreateTable = YES;
    }
    if (indexPath.section == 2) {
        self.detailInfoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(8, 0, 304, 300)];
        self.detailInfoWebView.scrollView.scrollEnabled = NO;
        self.detailInfoWebView.scrollView.bounces = NO;
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
