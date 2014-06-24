//
//  iplbiPadNewsListTableViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-19.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbiPadNewsListTableViewController.h"
#import "iplbNews.h"
#import "iplbNewsRepository.h"
#import "iplbiPadNewContentViewController.h"

@interface iplbiPadNewsListTableViewController ()
@property UIPopoverController *popoverViewController;
@end

@implementation iplbiPadNewsListTableViewController

NSMutableArray *news;

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
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新消息列表"];
    [refresh addTarget:self
                action:@selector(asyncRequestNewsAndUpdateUI)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [news count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *newListCellIdentifier = @"newListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newListCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newListCellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    iplbNews *newsDetail = [news objectAtIndex:indexPath.row];
    cell.textLabel.text = newsDetail.title;
//    cell.detailTextLabel.textColor = [UIColor grayColor];
//    cell.detailTextLabel.text = newsDetail.content;
//    cell.detailTextLabel.numberOfLines = 1;
//    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    return cell;
}

-(void) asyncRequestNewsAndUpdateUI
{
    //异步请求数据
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_sync(queue,^{
            iplbNewsRepository *repo = [iplbNewsRepository new];
            news = [repo getAllNews];
        });
        dispatch_sync(dispatch_get_main_queue(),^{
            if([news count] == 0){
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:@"网络连接异常,无法获取消息列表!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [self.refreshControl endRefreshing];
            }else{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //导航栏背景色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:2.0/255.0 green:123.0/255.0 blue:254.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self asyncRequestNewsAndUpdateUI];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect rect=CGRectMake(0,0,25,25);
    iplbNews *new = [news objectAtIndex:indexPath.row];
    iplbiPadNewContentViewController *contentViewController = [[iplbiPadNewContentViewController alloc] initWithNewContent:new.content];
    self.popoverViewController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
    self.popoverViewController.popoverContentSize = CGSizeMake(350, 180);
    [self.popoverViewController presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

@end
