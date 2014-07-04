//
//  iplbiPadProjectDetailViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-20.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbiPadProjectDetailViewController.h"
#import "iplbProjectDetail.h"
#import "iplbProjectsRepository.h"
#import "iplbAppDelegate.h"
#import "iplbScreenshotsGalleryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface iplbiPadProjectDetailViewController ()
@property(strong,nonatomic)iplbScreenshotsGalleryViewController *screenshotsGalleryViewController;
@end

@implementation iplbiPadProjectDetailViewController
iplbProjectDetail *pd;

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
    titleRowCreated = NO;
    screenShotsRowCreated = NO;
    descInfoRowCreated = NO;
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
    pd = [resp getProjectDetailInfo:self.detailURL];
}

-(void) clickScreenShot:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%@", [gestureRecognizer view]);
    self.screenshotsGalleryViewController = [[iplbScreenshotsGalleryViewController alloc] init];
    self.screenshotsGalleryViewController.screenShots = pd.screenShots;
    self.screenshotsGalleryViewController.isDesktop = [pd.platformType isEqualToString:@"desktop"];
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
        height = 115;
    }
    if (indexPath.section == 1) {
        height = 355;
    }
    if (indexPath.section == 2) {
        if (!self.webViewHeight) {
            height = 300;
        }else{
            height = self.webViewHeight+20;
        }
    }
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
    if (indexPath.section == 0 && !titleRowCreated) {
        //create header row
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 100,100)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10;
        [imageView setImageWithURL:[NSURL URLWithString:pd.iconURL]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [cell.contentView addSubview:imageView];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 8, 500, 28)];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        nameLabel.text = pd.projectName;
        [cell.contentView addSubview:nameLabel];
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 25, 600, 70)];
        [descLabel setFont:[UIFont systemFontOfSize:12]];
        descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descLabel.numberOfLines = 0;
        descLabel.textColor = [UIColor darkGrayColor];
        descLabel.text = pd.projectDesc;
        [cell.contentView addSubview:descLabel];
        titleRowCreated = YES;
    }
    if (indexPath.section == 1 && !screenShotsRowCreated) {
        int screenShotWidth = 210;
        int screentShotHeight = 315;
        if([pd.platformType isEqualToString:@"desktop"]){
            screenShotWidth = 440;
            screentShotHeight = 315;
        }
        int imageViewY = (355-screentShotHeight)/2;
        self.screenShotsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 0, 752, 355)];
        self.screenShotsScrollView.contentSize = CGSizeMake((screenShotWidth+10) * [pd.screenShots count], screentShotHeight);
        int scrollWidth=0;
        for (NSString *screenshotsURL in pd.screenShots){
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
        screenShotsRowCreated = YES;
    }
    if (indexPath.section == 2 && !descInfoRowCreated) {
        self.detailInfoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(8, 0, 752, 300)];
        self.detailInfoWebView.scrollView.scrollEnabled = NO;
        self.detailInfoWebView.scrollView.bounces = NO;
        [self.detailInfoWebView loadHTMLString:pd.detailInfo baseURL:nil];
        [self.detailInfoWebView setDelegate:self];
        [cell addSubview:self.detailInfoWebView];
        descInfoRowCreated = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        titleRowCreated = NO;
    }
    if (indexPath.section == 1) {
        screenShotsRowCreated = NO;
    }
    if (indexPath.section == 2) {
        descInfoRowCreated = NO;
    }
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
