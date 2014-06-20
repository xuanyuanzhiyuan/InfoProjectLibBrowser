//
//  iplbAppDelegate.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-16.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "iplbAppDelegate.h"
#import "iplbUserLoginViewController.h"
#import "iplbUserService.h"
#import "iplbiPadProjectListTableViewController.h"

@implementation iplbAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navController = [splitViewController.viewControllers objectAtIndex:1];
        iplbiPadProjectListTableViewController *projectListViewController = [navController.childViewControllers objectAtIndex:0];
        [splitViewController setDelegate:projectListViewController];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (!isPassLoginView) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            iplbUserLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"userLoginViewController"];
            [self.window.rootViewController presentViewController:loginViewController animated:NO completion:nil];
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            iplbUserLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"iPadUserLoginViewController"];
            [self.window.rootViewController presentViewController:loginViewController animated:NO completion:nil];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
