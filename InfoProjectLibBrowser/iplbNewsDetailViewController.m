//
//  iplbNewsDetailViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-21.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbNewsDetailViewController.h"
#import "iplbNewsRepository.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface iplbNewsDetailViewController ()

@end

@implementation iplbNewsDetailViewController
iplbNews *newsDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    iplbNewsRepository *repo = [iplbNewsRepository new];
    newsDetail = [repo getNewsDetail:self.detailURL];
    if(newsDetail.newsPictureURL&&[newsDetail.newsPictureURL isKindOfClass:[NSString class]]){
        [self.newsPictureImgView setImageWithURL:[NSURL URLWithString:newsDetail.newsPictureURL]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }else{
        [self.newsPictureImgView setFrame:CGRectMake(0, 0, 0, 0)];
        //        [self.contentTextView setFrame:CGRectMake(6, 67, 308, 300)];
    }
        [self.contentWebView loadHTMLString:newsDetail.content baseURL:nil];
    self.titleLabel.text = newsDetail.title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(newsDetail.newsPictureURL&&[newsDetail.newsPictureURL isKindOfClass:[NSString class]]){
        if (indexPath.section==0&&indexPath.row==0) {
            return 150;
        }
        if (indexPath.section==0&&indexPath.row==1) {
            return 300;
        }
    }else{
        if (indexPath.section==0&&indexPath.row==0) {
            return 0;
        }
        if (indexPath.section==0&&indexPath.row==1) {
            return 450;
        }
    }
    return 0;
}
@end
