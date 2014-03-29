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
#import <SDWebImage/UIImageView+WebCache.h>

@interface iplbProjectListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *productListTableView;

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
                action:@selector(asyncRequestProjectsDataAndUpdateUI)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
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
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
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
        self.categoryCode = [dic valueForKey:@"categoryCode"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    iplbProjectDetail *pd = [products objectAtIndex:indexPath.row];
    cell.textLabel.text = pd.projectName;
    cell.detailTextLabel.text = pd.projectDesc;
    [cell.imageView setImageWithURL:[NSURL URLWithString:pd.iconURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
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

- (IBAction)showActionSheet:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:@"修改密码",@"我的即时消息",nil];
    [actionSheet showFromBarButtonItem:self.actionButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index=> %i",buttonIndex);
    NSLog(@"You have pressed the %@ button", [actionSheet buttonTitleAtIndex:buttonIndex]);
    if (buttonIndex == 0) {
        [iplbUserService logout];
        //iplbUserLoginViewController *userLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"userLoginViewController"];
        //[self.navigationController pushViewController:userLoginViewController animated:YES];
        [self performSegueWithIdentifier:@"toLoginSegue" sender:self];
    }else if(buttonIndex==1){
        //显示密码修改界面
        [self performSegueWithIdentifier:@"showPasswordModifySegue" sender:self];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
@end
