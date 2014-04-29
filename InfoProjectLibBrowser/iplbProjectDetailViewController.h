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
