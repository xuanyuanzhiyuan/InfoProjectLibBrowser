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
    products = [resp getAllProjectInfos];
    //注册消息监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCategorySelectedNotification:) name:@"projectCategorySelected" object:nil];
}

- (void) receiveCategorySelectedNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"projectCategorySelected"]){
        NSLog (@"Successfully received the test notification!");
        NSDictionary *dic = [notification userInfo];
        NSLog(@"category is %@",[dic valueForKey:@"categoryName"]);
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
    NSURL *url = [NSURL URLWithString:pd.iconURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.imageView.image = [[UIImage alloc] initWithData:data];
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
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改密码",@"我的即时消息",nil];
    [actionSheet showFromBarButtonItem:self.actionButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index=> %i",buttonIndex);
    NSLog(@"You have pressed the %@ button", [actionSheet buttonTitleAtIndex:buttonIndex]);
    if(buttonIndex==0){
        //显示密码修改界面
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
@end
