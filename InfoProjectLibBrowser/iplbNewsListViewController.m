//
//  iplbNewsListViewController.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbNewsListViewController.h"
#import "iplbNewsDetailViewController.h"
#import "iplbNews.h"
#import "iplbNewsRepository.h"

@interface iplbNewsListViewController ()

@end

@implementation iplbNewsListViewController

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
    iplbNews *newsDetail = [news objectAtIndex:indexPath.row];
    cell.textLabel.text = newsDetail.title;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showNewsDetail"]){
        iplbNewsDetailViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        iplbNews *newsDetail = [news objectAtIndex:myIndexPath.row];
        detailViewController.detailURL = newsDetail.detailURL;
    }
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
    [self asyncRequestNewsAndUpdateUI];
}

@end
