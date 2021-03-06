//
//  iplbNewsDetailViewController.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-21.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iplbNewsDetailViewController : UITableViewController<UITableViewDelegate,UIWebViewDelegate>
@property NSString *detailURL;
@property (nonatomic, strong) IBOutlet UIImageView *newsPictureImgView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@end
