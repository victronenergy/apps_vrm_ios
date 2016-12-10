//
//  SitesScrollViewController.m
//  VictronEnergy
//
//  Created by Thijs on 4/24/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionNegative,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
} ScrollDirection;

#import "SiteListTableViewController.h"
#import "SitesScrollViewController.h"
#import "SiteDetailViewController.h"
#import "SettingsDetailTableViewController.h"
#import "Data.h"
#import "KeychainItemWrapper.h"
#import "SVWebViewController.h"
#import "M2MLoginService.h"

@interface SitesScrollViewController ()

/// iPad - This property is used as a reference to to the split view controller's master popover controller.
@property (nonatomic, retain) UIPopoverController *masterPopoverController;
/// iPad - This property is used as a reference to to the split view controller's master view button item if it should be displayed.
@property (nonatomic, retain) UIBarButtonItem *masterViewBarButtonItem;

- (void)setupCommonViewComponents;

@end

@implementation SitesScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // Set the screen name on the tracker so that it is used in all hits sent from this screen.
    [tracker set:kGAIScreenName value:@"SiteSummary"];

    // Send a screenview.
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];

    // Initialize currentPage and siteIndex to -1 so we can check if a site detail has been selected already.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.currentPage = -1;
        self.siteIndex   = -1;
    }

    [self setupCommonViewComponents];
    [self initializeScrollView];
    [self loadSelectedView];
    self.view.backgroundColor = COLOR_BACKGROUND;
}

/** Setup several view components that re-occur on each Site Detail view.  */
- (void)setupCommonViewComponents
{
    self.navigationItem.title = NSLocalizedString(@"site_detail_title", @"site_detail_title");
    self.navigationItem.backBarButtonItem.title = NSLocalizedString(@"back_button_title", @"back_button_title");

    self.webviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.webviewButton setImage:[UIImage imageNamed:@"ic_menu_web.png"] forState:UIControlStateNormal];
    self.webviewButton.frame = CGRectMake(0.0, 0.0, [UIImage imageNamed:@"ic_menu_web.png"].size.width, [UIImage imageNamed:@"ic_menu_web.png"].size.height);

    [self.webviewButton addTarget:self action:@selector(webviewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonWebview = [[UIBarButtonItem alloc] initWithCustomView:self.webviewButton];
	self.navigationItem.rightBarButtonItem = rightButtonWebview;
}

- (void)initializeScrollView
{
    self.viewControllerArray = [[NSMutableArray alloc] init];
    [self resizeScrollView];
}

- (void)setSitesList:(NSArray *)sitesList
{
    _sitesList = sitesList;
    if ([sitesList count] > 0) {
        [self updateDetailViews];
    }
}

- (void)resizeScrollView
{
    NSInteger numberOfViews = [self.sitesList count];
    if (numberOfViews > 0) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * numberOfViews, 1);
    } else { // default to one single screen
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 1);
    }
}

/** Remove all loaded Site Details, and reload the Site Details for the currently selected Site. */
-(void)reloadScrollview
{
    // Reset the scroll view - remove all loaded site details
    for (SiteDetailViewController *vc in self.viewControllerArray) {
        if (![vc isEqual:[NSNull null]]) {
            [vc removeFromParentViewController];
            [vc.view removeFromSuperview];
        }
    }
    [self.viewControllerArray removeAllObjects];

    // Reload the currently selected site and it neighbours, so scrollview uses correct width in the new device orientation.
    [self resizeScrollView];

    // Build the content of the scrollview
    [self buildScrollViewContent];

    // Scroll to the selected site
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * self.siteIndex, 0) animated:NO];
}

-(void) updateDetailViews {
    NSUInteger index = 0;
    for (SiteDetailViewController *vc in self.viewControllerArray) {
        if (![vc isEqual:[NSNull null]]) {
            if (index < [self.sitesList count]) {
                vc.selectedSite = self.sitesList[index];
            }
        }
        index++;
    }
}

-(void)reloadScroll {
    NSLog(@"reload scroll");
    [self reloadScrollview];
}

-(void)buildScrollViewContent {
    // Loads a detail view controller for the selected site
    // and also for the two sites, if any, next to it in the site list.
    NSInteger numberOfViews = [self.sitesList count];
    for (int i = 0; i < numberOfViews; i++) {

        if (i == self.siteIndex || i == self.siteIndex -1 || i == self.siteIndex +1) {
            SiteDetailViewController *detailViewController = nil;

            if ([self.viewControllerArray count] > i && [self.viewControllerArray[i] isKindOfClass:[SiteDetailViewController class]]) {
                detailViewController = (SiteDetailViewController *)self.viewControllerArray[i];
            } else {
                detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
            }

            [self addChildViewController:detailViewController];

            CGFloat xOrigin = i * self.view.frame.size.width;

            detailViewController.selectedSite = [self.sitesList objectAtIndex:i];

            detailViewController.view.frame = CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height);
            detailViewController.selectedSiteInList = i;
            self.viewControllerArray[i] = detailViewController;
            [self.scrollView addSubview:detailViewController.view];
        } else {
            self.viewControllerArray[i] = [NSNull null];
        }
    }
    self.webviewButton.enabled = numberOfViews > 0 ? YES : NO;
}


/** Loads a detail view controller for the selected site
 *  and also for the two sites, if any, next to it in the site list. */
- (void)loadSelectedView
{
    // iPad - only load the site detail view (and his neighbours) if it is not currently being displayed
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ||
        self.currentPage != self.siteIndex) {

        // iPad - Move out of any sub screen of the site detail screen, like Historic Data or the Web view.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && self.currentPage != -1) {
            SiteDetailViewController *currentDetailViewController = (SiteDetailViewController *)[self.viewControllerArray objectAtIndex:self.currentPage];
            [currentDetailViewController.navigationController popToRootViewControllerAnimated:NO];
        }

        self.currentPage = self.siteIndex;

        // Remove all chilldviewcontrollers before adding new viewcontrollers
        for (UIViewController *controller in self.childViewControllers) {
            [controller removeFromParentViewController];
        }

        // Remove all the subviews (tableViews) from the scrollview before adding the new viewcontrollers
        for (UITableView *tableView in self.scrollView.subviews) {
            [tableView removeFromSuperview];
        }

        // Build the content of the scrollview
        [self buildScrollViewContent];

        // Scroll to the selected site
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [UIView animateWithDuration: 0.5
                             animations: ^{
                                 [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * self.siteIndex, 0) animated:NO];
                             }completion: ^(BOOL finished){
                             }
             ];
        } else {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * self.siteIndex, 0) animated:NO];
        }
    }
}

/** On rotation remove all loaded Site Details, and reload the Site Details for the currently selected Site. */
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"site scroll orientation");
    [self reloadScrollview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    M2MLoginService *loginService = [M2MLoginService sharedInstance];

    //TODO: This is needed if the left side of the splitview is hidden
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Note that in portrait mode it is necessary to present the login screen this way, because
        // the master view's viewDidAppear: will not be called until its popover is displayed.
        //if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation) && !loginService.loggedIn) {
            //[self performSegueWithIdentifier:@"iPadLoginPortraitSegue" sender:nil];
        //}
    //}
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    M2MLoginService *loginService = [M2MLoginService sharedInstance];

    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation) && loginService.loggedIn && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        // Reload the scrollview if we navigate back from e.g. Historic Data after we've just rotated the device.
        [self reloadScrollview];
    }
    
    
    NSLog(@"Site Scroll View Did Appear");
    
    //Reload the scrollview contents to prevent weird layout buggs
    [self reloadScrollview];
}

#pragma mark - Webview Button

-(void)webviewButtonPressed:(id)sender
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];

    if ([username isEqualToString:LOGIN_DEMO]) {
        username = LOGIN_DEMO_EMAIL;
        password = LOGIN_DEMO_PASSWORD;
    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%li",WEBVIEW_URL_REQUEST_SITE, (long)self.selectedSite.siteID]];
    NSString *body = [NSString stringWithFormat: @"username=%@&password=%@",username,password];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"GET"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];

    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURLRequest:request];
    webViewController.title = self.selectedSite.name;
    
    NSString *path = [NSString stringWithFormat:@"/installation/%ld/dashboard", (long)self.selectedSite.siteID];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] getToken:username password:password web:webViewController redirect:path controller:self];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController:webViewController animated:YES];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        /// Navigation controller that pushes the SVWebViewController, instead of a modal version.
        UINavigationController *modalNavigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
        modalNavigationController.navigationBar.translucent = NO;
        NSString *backButton = NSLocalizedString(@"back_button_webview", @"back_button_webview");
        webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backButton style:UIBarButtonItemStylePlain target:self action:@selector(backFromWebview)];
        [self presentViewController:modalNavigationController animated:YES completion:nil];
    }

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_BUTTON_PRESS
                                                           label:@"website_alarms_button"
                                                           value:nil] build]];
}

- (void)backFromWebview
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    self.webviewButton.enabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.sitesList count] > 0) {

        int newOffset = scrollView.contentOffset.x;
        int newPage = (int)(newOffset/(scrollView.frame.size.width));

        self.selectedSite = [self.sitesList objectAtIndex:newPage];
        UINavigationController *navigationController = [self.splitViewController.viewControllers firstObject];
        SiteListTableViewController *mvc = (SiteListTableViewController *)navigationController.topViewController;
        mvc.selectedSite = self.selectedSite;
        mvc.indexOfSelectedSiteInList = newPage;

        if (!self.masterViewBarButtonItem) {
            [mvc scrollSiteListToSite:newPage withDuration:0.5f];
        }

        self.siteIndex = newPage;
        self.currentPage = newPage;

        self.webviewButton.enabled = YES;

        ScrollDirection scrollDirection;
        if (self.lastContentOffset > scrollView.contentOffset.x){
            scrollDirection = ScrollDirectionRight;
        }else if (self.lastContentOffset < scrollView.contentOffset.x){
            scrollDirection = ScrollDirectionLeft;
        }else if (self.lastContentOffset == scrollView.contentOffset.x && self.lastContentOffset == 0){
            scrollDirection = ScrollDirectionNegative;
        }else {
            scrollDirection = ScrollDirectionNone;
        }
        self.lastContentOffset = scrollView.contentOffset.x;

        if (scrollDirection == ScrollDirectionRight || scrollDirection == ScrollDirectionLeft || scrollDirection == ScrollDirectionNegative) {

            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_GESTURE
                                                                  action:GA_WITH_ACTION_SWIPE
                                                                   label:@"site_swipe"
                                                                   value:nil] build]];

            NSInteger numberOfViews = [self.sitesList count];
            for (int i = 0; i < numberOfViews; i++) {

                if (i >= 0 && i <[self.sitesList count]) {

                    if (i == self.siteIndex || i == self.siteIndex -1 || i == self.siteIndex +1){
                        if ([self.viewControllerArray objectAtIndex:i] == [NSNull null]) {
                            SiteDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];

                            [self addChildViewController:detailViewController];

                            CGFloat xOrigin = i * self.view.frame.size.width;

                            detailViewController.selectedSite = [self.sitesList objectAtIndex:i];
                            detailViewController.view.frame = CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height);
                            detailViewController.selectedSiteInList = i;

                            [self.viewControllerArray replaceObjectAtIndex:i withObject:detailViewController];

                            [self.scrollView addSubview:detailViewController.view];
                        }
                    }
                    else{
                        if ([self.viewControllerArray objectAtIndex:i] != [NSNull null] ){
                            SiteDetailViewController *detailViewController = [self.viewControllerArray objectAtIndex:i];
                            [detailViewController removeFromParentViewController];
                            [detailViewController.view removeFromSuperview];
                        }
                        [self.viewControllerArray replaceObjectAtIndex:i withObject:[NSNull null]];
                    }
                }
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, self.oldY)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark UISplitViewDelegate

/** iPad - Hides the master view when rotating to portrait mode. */
- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    //TODO: Test
    return NO;
}

/** iPad - Going to portrait mode. */
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    // If the barButtonItem does not have a title (or image) adding it to a toolbar will do nothing.
    barButtonItem.image = [UIImage imageNamed:@"ic_menu"];

    self.masterPopoverController = pc;

    // Tell the detail view controller to show the master view button.
    self.masterViewBarButtonItem = barButtonItem;
}

/** iPad - Going to landscape mode. */
- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.masterPopoverController = nil;

    // Tell the detail view controller to remove the master view button.
    self.masterViewBarButtonItem = nil;
}

/**
 * iPad - Custom implementation for the masterViewBarButtonItem setter.
 * In addition to updating the _masterViewBarButtonItem ivar, it
 * reconfigures the toolbar to either show or hide the master view button.
*/
- (void)setMasterViewBarButtonItem:(UIBarButtonItem *)masterViewBarButtonItem
{
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
    if (masterViewBarButtonItem != _masterViewBarButtonItem) {
        if (masterViewBarButtonItem) {
            [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObject:masterViewBarButtonItem]  animated:NO];
        } else {
            [self.navigationItem setLeftBarButtonItem:nil animated:NO];
        }
        _masterViewBarButtonItem = masterViewBarButtonItem;
    }
}

/** iPad - Shows the popover of the master view if in portrait. */
- (void)showMasterPopoverInPortrait {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self.masterPopoverController presentPopoverFromBarButtonItem:self.masterViewBarButtonItem
                                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                                             animated:YES];
    }
}

/** iPad - Hides the popover of the master view if in portrait. */
- (void)hideMasterPopoverInPortrait {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

@end
