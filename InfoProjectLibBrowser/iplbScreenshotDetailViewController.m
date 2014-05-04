//
//  iplbScreenshotDetailViewController.m
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-5-4.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbScreenshotDetailViewController.h"

@interface iplbScreenshotDetailViewController ()
- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
@end

@implementation iplbScreenshotDetailViewController
BOOL isMax;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (screenHeight-240)/2,screenWidth, 240)];
//    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,screenWidth, screenHeight)];
//    self.imageView.bounds = CGRectMake(0, 0, self.screenshot.size.width, self.screenshot.size.height);
    self.imageView.image = self.screenshot;
    self.scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.scrollView.contentSize = self.screenshot.size;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.imageView];
    [self.scrollView setDelegate:self];
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *tapToExit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissScreenshot)];
    tapToExit.numberOfTapsRequired = 1;
    tapToExit.numberOfTouchesRequired = 1;
    [tapToExit requireGestureRecognizerToFail:doubleTapRecognizer];
    [self.scrollView addGestureRecognizer:tapToExit];
    
    [self.view addSubview:self.scrollView];
    isMax = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    CGRect scrollViewFrame = self.scrollView.frame;
//    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
//    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
//    CGFloat minScale = MIN(scaleWidth, scaleHeight);
//    self.scrollView.minimumZoomScale = minScale;
    
//    self.scrollView.maximumZoomScale = 1.0f;
//    self.scrollView.zoomScale = minScale;

    [self centerScrollViewContents];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    NSLog(@"in double tap");
    if (isMax) {
        CGRect rectToZoomTo = CGRectMake(0, 0, self.screenshot.size.width, self.screenshot.size.height);
        [self.scrollView zoomToRect:rectToZoomTo animated:YES];
        isMax = NO;
    }else{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        CGRect rectToZoomTo = CGRectMake(0, (screenHeight-240)/2,screenWidth, 240);
        [self.scrollView zoomToRect:rectToZoomTo animated:YES];
        isMax = YES;
    }
}

- (void) dismissScreenshot
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}
@end
