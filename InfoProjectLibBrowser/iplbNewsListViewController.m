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
    news = [iplbNewsRepository getAllNews];
//    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
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

@end
