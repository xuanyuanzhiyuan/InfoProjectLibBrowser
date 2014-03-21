//
//  iplbNewsDetailViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-21.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbNewsDetailViewController.h"
#import "iplbNewsRepository.h"

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
    newsDetail = [iplbNewsRepository getNewsDetail:self.detailURL];
    if(newsDetail.newsPictureURL){
        NSURL *url = [NSURL URLWithString:newsDetail.newsPictureURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.newsPictureImgView.image = [[UIImage alloc] initWithData:data];
    }else{
        [self.newsPictureImgView setFrame:CGRectMake(0, 0, 0, 0)];
        [self.contentTextView setFrame:CGRectMake(6, 67, 308, 300)];
    }
    self.contentTextView.text = newsDetail.content;
    self.titleLabel.text = newsDetail.title;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
