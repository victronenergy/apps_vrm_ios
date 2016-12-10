//
//  AppDelegate.m
//  Victron Energy
//
//  Created by Thijs on 3/5/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "AppDelegate.h"
#import "SiteListTableViewController.h"
#import "SitesScrollViewController.h"
#import "SiteDetailViewController.h"
#import "GAI.h"
#import "NSDate+TimeAgo.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[CrashlyticsKit]];

    // Override point for customization after application launch.

    [[UINavigationBar appearance]setBarTintColor:COLOR_NAV_BAR];
    [[UINavigationBar appearance]setTintColor:COLOR_DARK_GREY];
    
    self.globalEmail = [[NSMutableString alloc] init];

    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-36047521-1"];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];


    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                          NSForegroundColorAttributeName: BACK_BUTTON_TEXT_COLOR,
                                                          NSFontAttributeName: BACK_BUTTON_TEXT_FONT
                                                          } forState:UIControlStateNormal];

    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: LABEL_HEADERS_TEXT_COLOR,
                                                            NSFontAttributeName: LABEL_HEADERS_TEXT_FONT}];

    // Setup splitview controller:
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers firstObject];
        SiteListTableViewController *mvc = (SiteListTableViewController *)navigationController.topViewController;
        splitViewController.delegate = mvc.detailViewManager;
        mvc.detailViewManager.splitViewController = splitViewController;
        mvc.detailViewManager.navigationController.navigationBar.translucent = NO;
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    UIBackgroundTaskIdentifier backgroundIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void) {
    }];
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
