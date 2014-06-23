//
//  iplbProjectListViewController.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbProjectListViewController.h"
#import "iplbProjectsRepository.h"
#import "iplbProjectDetail.h"
#import "iplbProjectDetailViewController.h"
#import "iplbUserService.h"
#import "iplbUserLoginViewController.h"
#import "iplbUserPasswordModifyViewController.h"
#import "iplbConfiguration.h"
#import "UIImage+ImageScaleAndRoundConner.h"
#import "iplbProjectListTableCellTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>


@interface iplbProjectListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *productListTableView;
@property (strong, nonatomic) AVAudioPlayer *startRefreshAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *stopRefreshAudioPlayer;
@property BOOL refreshAciton;
@end

@implementation iplbProjectListViewController

NSArray *products;

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
        NSLog (@"Successfully received the test notification!");
        NSDictionary *dic = [notification userInfo];
        NSLog(@"category is %@",[dic valueForKey:@"categoryCode"]);
        NSString *code = [dic valueForKey:@"categoryCode"];
        if([code isEqualToString:@"All"]){
            self.categoryCode = nil;
        }else{
            self.categoryCode = [dic valueForKey:@"categoryCode"];
        }
        [self asyncRequestProjectsDataAndUpdateUI];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"projectListCell";
    iplbProjectListTableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[iplbProjectListTableCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    iplbProjectDetail *pd = [products objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showProdDetails"]){
        iplbProjectDetailViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        iplbProjectDetail *detail = [products objectAtIndex:myIndexPath.row];
        detailViewController.detailURL = detail.detailURL;
    }
}

- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath
{
    [self performSegueWithIdentifier:@"showProdDetails" sender:self];
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
    if(self.categoryCode){
        products = [resp getProjectInfosWithCategory:self.categoryCode];
    }else{
        products = [resp getAllProjectInfos];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
