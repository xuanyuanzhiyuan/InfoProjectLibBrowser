//
//  iplbProjectDetailViewController.h
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-17.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iplbProjectDetailViewController : UIViewController
@property NSString *detailURL;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIScrollView *pageScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITextView *descText;
@property (nonatomic, strong) IBOutlet UIImageView *iconImage;
@property (nonatomic, strong) IBOutlet UITextView *detailText;
@end
