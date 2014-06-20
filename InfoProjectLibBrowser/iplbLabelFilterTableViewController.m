//
//  iplbLabelFilterTableViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-19.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbLabelFilterTableViewController.h"
#import "iplbProjectCategoryRepository.h"
#import "iplbProjectCategory.h"

@interface iplbLabelFilterTableViewController ()

@end

@implementation iplbLabelFilterTableViewController

NSArray *labels;

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
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [self asyncRequestProjectCategoriesAndUpdateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [labels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"labelCell"];
    }
    iplbProjectCategory *category = [labels objectAtIndex:indexPath.row];
    cell.textLabel.text = category.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

-(void) asyncRequestProjectCategoriesAndUpdateUI
{
    //异步请求数据
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_sync(queue,^{
            iplbProjectCategoryRepository *repo = [iplbProjectCategoryRepository new];
            labels = [repo getAllProjectCategories];

        });
        dispatch_sync(dispatch_get_main_queue(),^{
            if([labels count] == 0){
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务端响应异常,无法获取产品分类!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [self.refreshControl endRefreshing];
            }else{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }
        });
    });
}

- (IBAction)filterByLabels:(id)sender {
    NSMutableArray *selectedLabel = [NSMutableArray new];
    for (UITableViewCell *cell in [[self tableView] visibleCells]) {
        if (cell.selected) {
            NSIndexPath *index = [[self tableView] indexPathForCell:cell];
            iplbProjectCategory *category = [labels objectAtIndex:index.row];
            [selectedLabel addObject:category.code];
        }
    }
    //发送消息
     [[NSNotificationCenter defaultCenter] postNotificationName:@"projectCategorySelected" object:selectedLabel userInfo:nil];
}
@end
