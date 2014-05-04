//
//  iplbScreenshotDetailViewController.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-5-4.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iplbScreenshotDetailViewController : UIViewController<UIScrollViewDelegate>
@property UIImage *screenshot;
@property UIScrollView *scrollView;
@property UIImageView *imageView;
@end
