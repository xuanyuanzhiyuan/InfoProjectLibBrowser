//
//  iplbProjectCategoriesViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-22.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbProjectCategoriesViewController.h"

@interface iplbProjectCategoriesViewController ()

@end

@implementation iplbProjectCategoriesViewController
NSArray *categories;
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
	categories = @[@"全部",@"电信资源产品线",@"移动资源产品线"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"projectCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    return cell;
}

@end
