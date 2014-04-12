//
//  iplbProjectDetailViewController.h
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-17.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iplbProjectDetailViewController : UITableViewController<UITableViewDelegate,UIWebViewDelegate>
{
BOOL isFullScreen;
CGRect prevFrame;
}
@property NSString *detailURL;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIScrollView *pageScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *descLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIWebView *detailTextWebView;
@end
