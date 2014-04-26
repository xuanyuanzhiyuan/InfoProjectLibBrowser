//
//  iplbScreenshotsGalleryViewController.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-4-26.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import "iplbScreenshotsGalleryViewController.h"
#import "iCarousel.h"
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
    _carousel.type = iCarouselTypeInvertedWheel;
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
    closeButton.frame = CGRectMake(55, 440, 210, 30);
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
    if (view == nil)
    {
        int screenShotWidth = 90;
        int screentShotHeight = 160;
        if(self.isDesktop){
            screenShotWidth = 280;
            screentShotHeight = 210;
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

}
@end
