//
//  iplbiPadProjectListTableViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-3.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbiPadProjectListTableViewController.h"
#import "iplbProjectsRepository.h"
#import "iplbProjectDetail.h"
#import "iplbProjectDetailViewController.h"
#import "iplbUserService.h"
#import "iplbUserLoginViewController.h"
#import "iplbUserPasswordModifyViewController.h"
#import "iplbConfiguration.h"
#import "UIImage+ImageScaleAndRoundConner.h"
#import "iplbiPadProjectListTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface iplbiPadProjectListTableViewController ()
@property (strong, nonatomic) AVAudioPlayer *startRefreshAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *stopRefreshAudioPlayer;
@property BOOL refreshAciton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtnItem;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property UIView *shadowLayer;
@end

@implementation iplbiPadProjectListTableViewController

NSArray *products;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册消息监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCategorySelectedNotification:) name:@"projectCategorySelected" object:nil];
    //下拉刷新
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新产品列表"];
    [refresh addTarget:self
                action:@selector(playStartSoundAndRefresh)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    //登录判断
    isPassLoginView = ![iplbUserService isUserNeedLogin];
    //audio player
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"refresh_pull" ofType:@"caf"];
    if (soundPath) {
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        self.startRefreshAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    }
    NSString *stopSoundPath = [[NSBundle mainBundle] pathForResource:@"refresh_release" ofType:@"caf"];
    if (stopSoundPath) {
        NSURL *stopSoundURL = [NSURL fileURLWithPath:stopSoundPath];
        self.stopRefreshAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:stopSoundURL error:nil];
    }
    self.refreshAciton = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) playStartSoundAndRefresh
{
    self.refreshAciton = YES;
    [self.startRefreshAudioPlayer play];
    [self asyncRequestProjectsDataAndUpdateUI];
}

-(void) playStopSound
{
    if(self.refreshAciton){
        self.refreshAciton = NO;
        [self.stopRefreshAudioPlayer play];
    }
}

-(void) asyncRequestProjectsDataAndUpdateUI
{
    //异步请求数据
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_sync(queue,^{
            [self loadProjectsList];
        });
        dispatch_sync(dispatch_get_main_queue(),^{
            if([products count] == 0){
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:@"网络连接异常,无法获取产品列表!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [self.refreshControl endRefreshing];
            }else{
                [self.refreshControl endRefreshing];
                [self playStopSound];
                [self.tableView reloadData];
            }
        });
    });
}

- (void) receiveCategorySelectedNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"projectCategorySelected"]){
        NSLog (@"Successfully received the label notification!");
        NSMutableArray *labels = [notification object];
        if ([labels count] == 0) {
            return;
        }else{
            NSMutableString *labelStrs = [NSMutableString new];
            for (NSString *label in labels) {
                [labelStrs appendString:label];
                [labelStrs appendString:@","];
            }
            self.filterLabels = labelStrs;
            NSLog(@"labels is %@",labelStrs);
        }
        [self.masterPopoverController dismissPopoverAnimated:YES];
        [self.shadowLayer removeFromSuperview];
        [self asyncRequestProjectsDataAndUpdateUI];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"projectListCell";
    iplbiPadProjectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[iplbiPadProjectListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    iplbProjectDetail *pd = [products objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = pd.projectName;
    cell.detailTextLabel.text = pd.projectDesc;
    UIImage *holder = [[UIImage imageNamed:@"placeholder.png"] imageScaledToRoundConnerSize:CGSizeMake(30, 30)];
    [cell.imageView setImageWithURL:[NSURL URLWithString:pd.iconURL]
                   placeholderImage:holder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       //image = [image imageScaledToRoundConnerSize:CGSizeMake(30, 30)];
                   }];
    //图标圆角
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    //边框和阴影
    // A thin border.
    cell.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.imageView.layer.borderWidth = 0.3;
    // Drop shadow.
    cell.imageView.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.imageView.layer.shadowOpacity = 1.0;
    cell.imageView.layer.shadowRadius = 7.0;
    cell.imageView.layer.shadowOffset = CGSizeMake(0, 4);
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //导航栏背景色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:2.0/255.0 green:123.0/255.0 blue:254.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    if(isPassLoginView)
        [self asyncRequestProjectsDataAndUpdateUI];
    
}

- (void) loadProjectsList
{
    iplbProjectsRepository * resp = [iplbProjectsRepository new];
    //获取项目列表
    if(self.filterLabels){
        products = [resp getProjectInfosWithCategory:self.filterLabels];
    }else{
        products = [resp getAllProjectInfos];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc
{
    NSLog(@"Will hide left side");
    self.masterPopoverController = pc;
    self.menuBtnItem = barButtonItem;
    [pc setDelegate:self];
    barButtonItem.title = @"菜单";
    
    
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSLog(@"Will show left side");
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
    self.menuBtnItem = nil;
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController
{
    NSLog(@"xxxxxxxx");
    NSLog(@"obj is %@",aViewController);
    if (!self.shadowLayer) {
        self.shadowLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 5000)];
        [self.shadowLayer setTag:108];
        [self.shadowLayer setBackgroundColor:[UIColor blackColor]];
        [self.shadowLayer setAlpha:0.5                                                ];
    }
    [self.view addSubview:self.shadowLayer];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"yyyyyyyy");
    [self.shadowLayer removeFromSuperview];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showProjectDetailSegue"]){
        iplbProjectDetailViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        iplbProjectDetail *detail = [products objectAtIndex:myIndexPath.row];
        detailViewController.detailURL = detail.detailURL;
    }
}
@end
