//
//  iplbProjectCategoriesViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-22.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbProjectCategoriesViewController.h"
#import "iplbProjectLabel.h"
#import "iplbProjectLabelRepository.h"

@interface iplbProjectCategoriesViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelSelectCategoryBI;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *uiVew;

@end

@implementation iplbProjectCategoriesViewController
NSArray *labels;
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
    //下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新标签"];
    [self.refreshControl addTarget:self
                action:@selector(asyncRequestProjectCategoriesAndUpdateUI)
      forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    //self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
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
    return [labels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"projectCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    iplbProjectLabel *label = [labels objectAtIndex:indexPath.row];
    cell.textLabel.text = label.label;
    return cell;
}

- (IBAction)cancelProductCategory:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) asyncRequestProjectCategoriesAndUpdateUI
{
    //异步请求数据
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_sync(queue,^{
            iplbProjectLabelRepository *repo = [iplbProjectLabelRepository new];
            labels = [repo getAllLabels];
        });
        dispatch_sync(dispatch_get_main_queue(),^{
            [self.cancelSelectCategoryBI setEnabled:YES];
            if([labels count] == 0){
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务端响应异常,无法获取产品标签!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [self.refreshControl endRefreshing];
            }else{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //导航栏背景色
    [self.naviBar setBarTintColor:[UIColor colorWithRed:2.0/255.0 green:123.0/255.0 blue:254.0/255.0 alpha:1]];
    [self.naviBar setTintColor:[UIColor whiteColor]];
    [self.naviBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.uiVew setTintColor:[UIColor colorWithRed:2.0/255.0 green:123.0/255.0 blue:254.0/255.0 alpha:1]];
    [self.uiVew setBackgroundColor:[UIColor colorWithRed:2.0/255.0 green:123.0/255.0 blue:254.0/255.0 alpha:1]];
    [self asyncRequestProjectCategoriesAndUpdateUI];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (IBAction)filterByLabels:(id)sender {
    NSMutableArray *selectedLabel = [NSMutableArray new];
    for (UITableViewCell *cell in [[self tableView] visibleCells]) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            NSIndexPath *index = [[self tableView] indexPathForCell:cell];
            iplbProjectLabel *label = [labels objectAtIndex:index.row];
            [selectedLabel addObject:label.label];
        }
    }
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"projectCategorySelected" object:selectedLabel userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
