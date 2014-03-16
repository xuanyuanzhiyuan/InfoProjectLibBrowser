//
//  iplbProjectListViewController.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbProjectListViewController.h"
#import "iplbProjectsRepository.h"

@interface iplbProjectListViewController ()

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
    products = [NSArray arrayWithObjects:@"广东电信综合资源",@"深圳移动基站信息系统",@"广东电信光导航系统", nil];
    //下移20px，避免和status bar挤在一起
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    iplbProjectsRepository * resp = [iplbProjectsRepository new];
    [resp getAllProjectInfos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [products objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"news.png"];
    return cell;
}

@end
