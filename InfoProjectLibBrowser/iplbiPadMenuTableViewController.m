//
//  iplbiPadMenuTableViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-4.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbiPadMenuTableViewController.h"
#import "iplbUserService.h"
#import "iplbUserLoginViewController.h"
#import "iplbConfiguration.h"

@interface iplbiPadMenuTableViewController ()

@end

@implementation iplbiPadMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *logoutTitle = [NSString stringWithFormat:@"注销[%@]",[iplbConfiguration getUserLoginInfo:@"LoginUserName"]];
    self.menu = @[@"标签",@"消息",@"修改密码",logoutTitle];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.menu objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"showLabelFilterSegue" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"showNewsListSegue" sender:self];
            break;
        case 2:
            [self.rootController performSegueWithIdentifier:@"showLoginSegue" sender:self];
            [iplbUserService logout];
            break;
        case 3:
            [self performSegueWithIdentifier:@"showNewsListSegue" sender:self];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //导航栏背景色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:2.0/255.0 green:123.0/255.0 blue:254.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}

@end
