//
//  iplbNewsDetailViewController.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-3-21.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iplbNewsDetailViewController : UIViewController
@property NSString *detailURL;
@property (nonatomic, strong) IBOutlet UIImageView *newsPictureImgView;
@property (nonatomic, strong) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@end
