//
//  iplbiPadProjectListTableViewController.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-3.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iplbiPadProjectListTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,UISplitViewControllerDelegate,UIPopoverControllerDelegate>
@property NSString *filterLabels;
extern BOOL isPassLoginView;
@end
