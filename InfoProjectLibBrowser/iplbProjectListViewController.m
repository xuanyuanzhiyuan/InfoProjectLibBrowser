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
#import <SDWebImage/UIImageView+WebCache.h>

@interface iplbProjectListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButtonItem;
@property (strong, nonatomic) IBOutlet UITableView *productListTableView;

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
    //下移20px，避免和status bar挤在一起
//    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    iplbProjectsRepository * resp = [iplbProjectsRepository new];
    //获取项目列表
    if(self.categoryCode){
        products = [resp getProjectInfosWithCategory:self.categoryCode];    
    }else{
        products = [resp getAllProjectInfos];
    }
    if(!products){
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:@"网络错误,请稍后重试!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        exit(0);
    }
    //注册消息监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCategorySelectedNotification:) name:@"projectCategorySelected" object:nil];
}

- (void) receiveCategorySelectedNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"projectCategorySelected"]){
        NSLog (@"Successfully received the test notification!");
        NSDictionary *dic = [notification userInfo];
        NSLog(@"category is %@",[dic valueForKey:@"categoryCode"]);
        self.categoryCode = [dic valueForKey:@"categoryCode"];
        [self.tableView reloadData];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        iplbUserLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"userLoginViewController"];
    }else if(buttonIndex==1){
        //显示密码修改界面
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
@end
