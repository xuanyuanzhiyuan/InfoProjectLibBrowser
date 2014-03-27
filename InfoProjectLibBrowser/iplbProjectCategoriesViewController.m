//
//  iplbProjectCategoriesViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-22.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbProjectCategoriesViewController.h"
#import "iplbProjectCategoryRepository.h"
#import "iplbProjectCategory.h"

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
    iplbProjectCategoryRepository *repo = [iplbProjectCategoryRepository new];
    categories = [repo getAllProjectCategories];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
}

-(void)viewDidAppear:(BOOL)animated
{
    
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
    iplbProjectCategory *category = [categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    iplbProjectCategory *category = [categories objectAtIndex:indexPath.row];
    NSDictionary *dic = @{@"categoryCode":category.code};
    //发送消息
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"projectCategorySelected" object:nil userInfo:dic];
    }];
}
- (IBAction)cancelProductCategory:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
