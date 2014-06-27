//
//  iplbScreenshotsGalleryViewController.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-4-26.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbScreenshotsGalleryViewController.h"
#import "iCarousel.h"
#import "iplbScreenshotDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface iplbScreenshotsGalleryViewController () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) iCarousel *carousel;
@end

@implementation iplbScreenshotsGalleryViewController

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

    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	backgroundView.image = [UIImage imageNamed:@"background.png"];
	[self.view addSubview:backgroundView];
    
    _carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
	_carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _carousel.type = self.isDesktop?iCarouselTypeRotary:iCarouselTypeCoverFlow2;
	_carousel.delegate = self;
	_carousel.dataSource = self;
    
	//add carousel to view
	[self.view addSubview:_carousel];
    
    //close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton addTarget:self
               action:@selector(closeGallery)
     forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"退出截图浏览" forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        closeButton.frame = CGRectMake(279, 934, 210, 30);
    }else{
        closeButton.frame = CGRectMake(55, 440, 210, 30);
    }
    [self.view addSubview:closeButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) closeGallery
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
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

//datasource
- (NSUInteger )numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.screenShots count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (view == nil){
        int screenShotWidth = 200;
        int screentShotHeight = 300;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            screenShotWidth = 360;
            screentShotHeight = 540;
            if(self.isDesktop){
                screenShotWidth = 504;
                screentShotHeight = 378;
            }
        }else{
            if(self.isDesktop){
                screenShotWidth = 280;
                screentShotHeight = 210;
            }
        }
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenShotWidth, screentShotHeight)];
        UIImageView *imgView = (UIImageView *)view;
        [imgView setImageWithURL:[NSURL URLWithString:[self.screenShots objectAtIndex:index]]
                placeholderImage:[UIImage imageNamed:@"screen_placeholder.png"]];
    }
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"picture is click...");
    UIImageView *view = (UIImageView *)[carousel itemViewAtIndex:index];
    iplbScreenshotDetailViewController *detailViewController = [[iplbScreenshotDetailViewController alloc] init];
    detailViewController.screenshot = view.image;
    detailViewController.isDesktop = self.isDesktop;
    [self presentViewController:detailViewController animated:YES completion:nil];

}
@end
