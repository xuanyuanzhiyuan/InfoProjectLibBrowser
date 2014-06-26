//
//  iplbiPadProjectDetailViewController.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-20.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iplbiPadProjectDetailViewController : UITableViewController<UITableViewDelegate,UIWebViewDelegate>
{
    BOOL isFullScreen;
    BOOL titleRowCreated;
    BOOL screenShotsRowCreated;
    BOOL descInfoRowCreated;
    CGRect prevFrame;
}
@property NSString *detailURL;
@property UIScrollView *screenShotsScrollView;
@property UIWebView *detailInfoWebView;
@property CGFloat webViewHeight;
@end
