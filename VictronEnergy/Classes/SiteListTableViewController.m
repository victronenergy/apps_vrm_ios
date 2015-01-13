//
//  SiteListTable.m
//  Victron Energy
//
//  Created by Victron Energy on 3/12/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "SiteListTableViewController.h"
#import "SitesOKCell.h"
#import "SitesWithAlarmCell.h"
#import "SitesOutDatedCell.h"
#import "Tools.h"
#import "SiteInfo.h"
#import "Data.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "SiteDetailViewController.h"
#import "SitesScrollViewController.h"
#import "AttributesInfo.h"
#import "KeychainItemWrapper.h"
#import "SVWebViewController.h"
#import "LoginViewController.h"
#import "NoSitesAvailableCell.h"
#import "M2MAboutViewController.h"

const float kSearchBarHeight = 44.0f;

@implementation SiteListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // Set the screen name on the tracker so that it is used in all hits sent from this screen.
    [tracker set:kGAIScreenName value:@"SiteList"];

    // Send a screenview.
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];

    self.sitesAlarmsCount = 0;
    self.sitesOkCount = 0;
    self.sitesOldCount = 0;
    self.sitesAlarmsArray = [[NSMutableArray alloc]init];
    self.sitesOkArray = [[NSMutableArray alloc]init];
    self.sitesOldArray = [[NSMutableArray alloc]init];

    self.sitesList = [NSMutableArray new];
    self.sitesListResults = [NSMutableArray new];

    self.selectedSite = nil;
    self.isShowingSearchResults = NO;

    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = COLOR_BACKGROUND;

    self.sitesSearchBar.placeholder = NSLocalizedString(@"searchbar_placeholdertext", @"searchbar_placeholdertext");
    self.sitesSearchBar.backgroundImage = [UIImage imageNamed:@"bar_search_background.png"];

    [self.tableView setSeparatorColor:[UIColor clearColor]];

    UIImage *clearText = [UIImage imageNamed:@"button_exitsearch.png"];
    [self.sitesSearchBar setImage:clearText forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];

    UIImage *searchIcon = [UIImage imageNamed:@"icon_search.png"];
    [self.sitesSearchBar setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    for (SiteListTableViewController *searchBarSubview in [_sitesSearchBar subviews]) {

        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {

            @try {
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
                [(UITextField *)searchBarSubview setEnablesReturnKeyAutomatically:NO];
            }
            @catch (NSException * e) {

            }
        }
    }

    if (_refreshHeaderView == nil) {

		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc]
                                           initWithFrame:CGRectMake(0.0f,
                                                                0.0f - self.tableView.bounds.size.height,
                                                                    self.view.frame.size.width,
                                                                    self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewWithData:) name:NOTIFICATION_SITE_LIST object:nil];

    self.navigationItem.backBarButtonItem.title = NSLocalizedString(@"back_button_title", @"back_button_title");
    self.navigationItem.title = NSLocalizedString(@"site_summary_title", @"site_summary_title");

    self.aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.aboutButton setImage:[UIImage imageNamed:@"ic_about_default"] forState:UIControlStateNormal];
    self.aboutButton.frame = CGRectMake(0.0, 0.0, [UIImage imageNamed:@"ic_about_default"].size.width, [UIImage imageNamed:@"ic_about_default"].size.height);
    [self.aboutButton addTarget:self action:@selector(aboutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.webviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.webviewButton setImage:[UIImage imageNamed:@"ic_menu_web.png"] forState:UIControlStateNormal];
    self.webviewButton.frame = CGRectMake(0.0, 0.0, [UIImage imageNamed:@"ic_menu_web.png"].size.width, [UIImage imageNamed:@"ic_menu_web.png"].size.height);
    [self.webviewButton addTarget:self action:@selector(webViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightButtonWebview = [[UIBarButtonItem alloc] initWithCustomView:self.webviewButton];
    UIBarButtonItem *rightButtonAbout = [[UIBarButtonItem alloc] initWithCustomView:self.aboutButton];

    self.navigationItem.rightBarButtonItems = @[rightButtonWebview,rightButtonAbout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self scrollSiteListToSite:self.indexOfSelectedSiteInList withDuration:0.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![Data sharedData].userIsLoggedIn) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    } else {
        [self reloadTableViewDataSource];
    }
}

/** iPad - get a reference to the Splitview's detail view manager */
- (SitesScrollViewController *)detailViewManager
{
    if (_detailViewManager) {
        return _detailViewManager;
    }
    _detailViewManager = (SitesScrollViewController *)[[self.splitViewController.viewControllers lastObject]topViewController];
    return _detailViewManager;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // iPad - If the user has just logged in, select the first site and show its detail view.
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
        (!self.selectedSite) &&
        [indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row &&
        !self.isShowingSearchResults) {
        // End of loading table view means we have site info to select.
        [self loadFirstSiteDetailView];
        // Having the number of sites we can resize the scrollview for the number of required views.
        [self.detailViewManager resizeScrollView];
    }
}

/** iPad - Tells the detail view manager to shows the detail view of the first site in the list.
 * NOTE: we do this without invoking tableview:didSelectRowAtIndexPath: to prevent polluting Google Analytics. */
- (void)loadFirstSiteDetailView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && self.indexPathSite && ([self.sitesList count] > 0)) {

        // Send relevant Site Info to the detail view manager.
        self.detailViewManager.selectedSite = [self.sitesListResults objectAtIndex:self.indexPathSite.row];
        self.detailViewManager.siteIndex = self.indexPathSite.row;
        self.detailViewManager.sitesList = self.sitesListResults;

        // Tell the detail view manager to load the selected detail view controller.
        [self.detailViewManager loadSelectedView];
    }
}

- (NSIndexPath *)getIndexPathForSelectedSite:(int)sitePositionInSiteDetails{
    NSIndexPath *indexPathSite;

    if ([self.tableView numberOfRowsInSection:0] > sitePositionInSiteDetails) {
        indexPathSite = [NSIndexPath indexPathForRow:sitePositionInSiteDetails
                                           inSection:0];
    } else if (([self.tableView numberOfRowsInSection:0] + [self.tableView numberOfRowsInSection:1]) > sitePositionInSiteDetails) {
        indexPathSite = [NSIndexPath indexPathForRow:(sitePositionInSiteDetails - [self.tableView numberOfRowsInSection:0])
                                           inSection:1];
    } else if (([self.tableView numberOfRowsInSection:0] + [self.tableView numberOfRowsInSection:1] + [self.tableView numberOfRowsInSection:2]) > sitePositionInSiteDetails) {
        indexPathSite = [NSIndexPath indexPathForRow:(sitePositionInSiteDetails - [self.tableView numberOfRowsInSection:0] - [self.tableView numberOfRowsInSection:1])
                                           inSection:2];
    }

    return indexPathSite;
}

- (void)scrollSiteListToSite:(int)sitePositionInSiteDetails withDuration:(float)duration
{
    self.indexPathSite = [self getIndexPathForSelectedSite:sitePositionInSiteDetails];

    // We use this animateWithDuration because then we have a smooth scrolling, if we use scrollToRowAtIndexPath:animated:YES it stammers
    [UIView animateWithDuration: duration
                     animations: ^{
                         [self.tableView scrollToRowAtIndexPath:self.indexPathSite atScrollPosition:UITableViewScrollPositionNone animated:NO];
                     }completion: ^(BOOL finished){
                         // After we scrolled to the row we selected it
                         [self.tableView selectRowAtIndexPath:self.indexPathSite
                                                     animated:NO
                                               scrollPosition:UITableViewScrollPositionNone];
                     }
     ];
}


- (IBAction)logOutButtonPressed:(id)sender {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *logoutMessage = [NSString stringWithFormat:NSLocalizedString(@"log_out_button", @"log_out_button"),username];

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:logoutMessage
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                              action:GA_WITH_ACTION_BUTTON_PRESS
                                                               label:@"logout_button"
                                                               value:nil] build]];

        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
        [keychainItem resetKeychainItem];
        [Data sharedData].sessionId = nil;
        [Data sharedData].userIsDemoUser = NO;

        UIViewController *presentingVC;
        // Determine if we should present the modal login screen from our self (iPhone) or the SplitViewController (iPad)
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            presentingVC = self;
        } else {
            presentingVC = self.splitViewController;
            // iPad - If we are in portrait we will hide the master view popover before we present the login screen,
            // so that on dismissal of the login view the master popover will slide in.
            [self.detailViewManager hideMasterPopoverInPortrait];
        }

        // We want to show the login screen *animated*, so instead of simply using performSegueWithIdentifier:: we do the following:
        LoginViewController *vc =  (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewNavigationController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];

        [presentingVC presentViewController:vc animated:YES completion:^(void){
            // Reload the site list without any sites, so that on dismissal of the login view the previous site data is not briefly visible.
            self.sitesAlarmsCount = 0;
            self.sitesOkCount     = 0;
            self.sitesOldCount    = 0;
            [self.sitesAlarmsArray removeAllObjects];
            [self.sitesOkArray     removeAllObjects];
            [self.sitesOldArray    removeAllObjects];
            [self.sitesList        removeAllObjects];
            [self.sitesListResults removeAllObjects];
            self.selectedSite = nil;

            [self.tableView reloadData];

            // Reset the detail view manager - remove all loaded site details.
            for (SiteDetailViewController *vc in self.detailViewManager.viewControllerArray) {
                if (![vc isEqual:[NSNull null]]) {
                    [vc removeFromParentViewController];
                    [vc.view removeFromSuperview];
                }
            }
            [self.detailViewManager.viewControllerArray removeAllObjects];
            self.detailViewManager.siteIndex   = -1;
            self.detailViewManager.currentPage = -1;
            self.detailViewManager.sitesList = nil;
            self.detailViewManager.selectedSite = nil;

            self.indexPathSite = nil;

            // Close the Historic Data or Webview screen, if open.
            [self.detailViewManager.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
}

-(void)aboutButtonPressed:(id)sender {

    M2MAboutViewController *aboutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutNavBar"];

    [self.navigationController presentViewController:aboutViewController animated:YES completion:nil];
}

- (void)webViewButtonPressed:(id)sender {

    NSString *password = @"";
    NSString *username = @"";
    if ([[Data sharedData]userIsDemoUser]) {
        password = [[Data sharedData]password];
        username = [[Data sharedData]username];
    }else{
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
        password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
        username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    }

    NSURL *url = WEBVIEW_URL_REQUEST;
    NSString *body = [NSString stringWithFormat: @"username=%@&password=%@",username,password];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];

    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURLRequest:request];
    webViewController.title = NSLocalizedString(@"website_title", @"website_title");

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController:webViewController animated:YES];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UINavigationController *modalNavigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
        modalNavigationController.navigationBar.translucent = NO;
        NSString *backButton = NSLocalizedString(@"back_button_webview", @"back_button_webview");
        webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backButton style:UIBarButtonItemStylePlain target:self action:@selector(backFromWebview)];
        [self presentViewController:modalNavigationController animated:YES completion:nil];
    }

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_BUTTON_PRESS
                                                           label:@"settings_website_button"
                                                           value:nil] build]];
}

- (void)backFromWebview
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sortSitesForSiteListWithArray:(NSMutableArray *)sitesArray{

    NSMutableArray *sitesTempArray = [[NSMutableArray alloc]init];
    [self.sitesAlarmsArray removeAllObjects];
    [self.sitesOkArray removeAllObjects];
    [self.sitesOldArray removeAllObjects];

    for (SiteInfo *site in sitesArray) {
        // If the site data is old put the site in the old data list
        if (site.siteStatus == OLD ) {
            [self.sitesOldArray addObject:site];
        } else if (site.siteStatus == ALARMS) {
            [self.sitesAlarmsArray addObject:site];
        } else if (site.siteStatus == OK) {
            [self.sitesOkArray addObject:site];
        }
    }

    self.sitesAlarmsCount = [self.sitesAlarmsArray count];
    self.sitesOkCount = [self.sitesOkArray count];
    self.sitesOldCount = [self.sitesOldArray count];

    for (SiteInfo *site in self.sitesAlarmsArray) {
        [sitesTempArray addObject:site];
    }

    for (SiteInfo *site in self.sitesOkArray) {
        [sitesTempArray addObject:site];
    }

    for (SiteInfo *site in self.sitesOldArray) {
        [sitesTempArray addObject:site];
    }

    if (sitesArray == self.sitesList) {
        self.sitesList = sitesTempArray;
    }

    self.sitesListResults = sitesTempArray;

    if (![self.sitesListResults count]) {
        self.noSiteAvailable = YES;
    } else {
        self.noSiteAvailable = NO;
    }

    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)getSites
{
    [Sites getSites];
}

-(void)reloadTableViewWithData:(NSNotification *)notification
{
    self.sitesList = [[notification userInfo]objectForKey:@"sites"];
    [self sortSitesForSiteListWithArray:self.sitesList];

    [self doneLoadingTableViewData];

    // iPad - Select and scroll to the appropriate Site.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        // On login, determine the indexPath of the first row of the first *visible* section.
        if (!self.selectedSite && [self.sitesList count]) {
            self.indexPathSite = [NSIndexPath indexPathForRow:0 inSection:0];
            if (!self.sitesAlarmsCount && self.sitesOkCount > 0) {
                self.indexPathSite = [NSIndexPath indexPathForRow:0 inSection:1];
            } else if (!self.sitesAlarmsCount && !self.sitesOkCount && self.sitesOldCount > 0) {
                self.indexPathSite = [NSIndexPath indexPathForRow:0 inSection:2];
            }
        }
        // Select and scroll to the Site.
        // If we have no sites and thus no indexPathSite, attempting scrollToRowAtIndexPath will crash.
        if (self.indexPathSite && [self.sitesList count]) {
            [self.tableView selectRowAtIndexPath:self.indexPathSite
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];

            [self.tableView scrollToRowAtIndexPath:self.indexPathSite atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    }

    [[NSNotificationCenter defaultCenter]removeObserver:self name:notification.name object:nil];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.sitesSearchBar resignFirstResponder];
}

#pragma mark -
#pragma mark Searchbar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.sitesSearchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)aSearchbar textDidChange:(NSString *)searchText{

    self.sitesListResults = [self.sitesList copy];

    NSMutableArray* searchResults = [[NSMutableArray alloc] initWithArray:self.sitesListResults];
    //remove the items that do not match with the search string
    if ([aSearchbar.text length] > 0) {
        for (SiteInfo *item in self.sitesListResults) {
            if ([item.name rangeOfString:aSearchbar.text options:NSCaseInsensitiveSearch].location == NSNotFound ) {
                [searchResults removeObject:item];
            }
        }
        self.isShowingSearchResults = YES;
    } else {
        self.isShowingSearchResults = NO;
    }

    self.sitesListResults = searchResults;
    [self sortSitesForSiteListWithArray:self.sitesListResults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewWithData:) name:NOTIFICATION_SITE_LIST object:nil];
    [self getSites];
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

    self.sitesSearchBar.text = SEARCH_BAR_EMPTY;
    self.navigationItem.title = ([self.sitesList count] > 1) ? NSLocalizedString(@"site_summaries_title", @"site_summaries_title") : NSLocalizedString(@"site_summary_title", @"site_summary_title");
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.sitesSearchBar resignFirstResponder];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];

}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{

	[self performSelectorOnMainThread:@selector(reloadTableViewDataSource) withObject:nil waitUntilDone:NO];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_GESTURE
                                                          action:GA_WITH_ACTION_PULL
                                                           label:@"refresh_sitelist_pull"
                                                           value:nil] build]];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{

	return _reloading; // should return if data source model is reloading

}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{

	return [NSDate date]; // should return date data source was last changed

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.noSiteAvailable) {
        return 1;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.noSiteAvailable) {
        return 1;
    } else {
        switch (section) {
            case 0:
                return self.sitesAlarmsCount;
                break;
            case 1:
                return self.sitesOkCount;
                break;
            case 2:
                return self.sitesOldCount;
                break;
            default:
                return 0;
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    switch (section) {
        case 0:{
            if (self.sitesAlarmsCount) {
                return 76;
            }
            break;
        }
        case 1:{
            if (self.sitesOkCount) {
                return 76;
            }
            break;
        }
        case 2:{
            if (self.sitesOldCount) {
                return 76;
            }
            break;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.noSiteAvailable) {
        return 175.0f;
    } else {
        if (indexPath.section == 0) {
            return 120.0f;
        } else if (indexPath.section == 1) {
            return 90.0f;
        } else {
            return 70.0f;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 76)];

    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 16, 304, 60)];
    headerImageView.image = [[UIImage imageNamed:@"heading_corner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kHeaderInsetImageTop, kHeaderInsetImageLeft, kHeaderInsetImageBottom, kHeaderInsetImageRight)];

    [headerView addSubview:headerImageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 38, tableView.frame.size.width, 18)];
    [Tools style:LabelStyleSectionHeader forLabel:label];
    if(section == 0) {
        label.text = NSLocalizedString(@"status_alarm", @"status_alarm");
    } else if (section == 1){
        label.text = NSLocalizedString(@"status_ok", @"status_ok");
    }else {
        label.text = NSLocalizedString(@"status_old", @"status_old");
    }
    [headerView addSubview:label];
    [headerView setBackgroundColor:COLOR_BACKGROUND];


    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.noSiteAvailable) {
        NoSitesAvailableCell *cell = (NoSitesAvailableCell *)[tableView dequeueReusableCellWithIdentifier:@"NoSitesAvailableCell"];
        return cell;
    } else {
        if (indexPath.section == 0) {
            SitesWithAlarmCell *cell = (SitesWithAlarmCell *)[tableView dequeueReusableCellWithIdentifier:@"SitesWithAlarmCell"];
            SiteInfo *info = [self.sitesListResults objectAtIndex:indexPath.row ];
            if (!info.siteAttributes && info.isLoadingWidgets) {
                [self getAttributesForSite:info withTableViewCell:cell];
            }
            [cell setDataWithSiteObject:info andTableView:tableView andIndexPath:indexPath andIsLoading:info.isLoadingWidgets];

            return cell;
        } else if (indexPath.section == 1) {
            SitesOKCell *cell = (SitesOKCell *)[tableView dequeueReusableCellWithIdentifier:@"SitesOKCell"];
            SiteInfo *info = [self.sitesListResults objectAtIndex:indexPath.row + self.sitesAlarmsCount];
            if (!info.siteAttributes && info.isLoadingWidgets) {
                [self getAttributesForSite:info withTableViewCell:cell];
            }
            [cell setDataWithSiteObject:info andTableView:tableView andIndexPath:indexPath andIsLoading:info.isLoadingWidgets];

            return cell;
        } else {
            SitesOutDatedCell *cell = (SitesOutDatedCell *)[tableView dequeueReusableCellWithIdentifier:@"SitesOutDatedCell"];
            SiteInfo *info = [self.sitesListResults objectAtIndex:indexPath.row + self.sitesAlarmsCount + self.sitesOkCount];
            [cell setDataWithSiteObject:info];
            return cell;
        }
    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Empty the searchBar and remove the keyboard when a row is selected
    [self.sitesSearchBar setText:SEARCH_BAR_EMPTY];
    [self.sitesSearchBar resignFirstResponder];

    SitesScrollViewController *scrollViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"scrollView"];

    if (indexPath.section == 0) {
        self.selectedSite = [self.sitesListResults objectAtIndex:indexPath.row];
        scrollViewController.selectedSite = [self.sitesListResults objectAtIndex:indexPath.row];
        scrollViewController.siteIndex = [self.sitesList indexOfObject:self.selectedSite];
    } else if (indexPath.section == 1) {
        self.selectedSite = [self.sitesListResults objectAtIndex:indexPath.row + self.sitesAlarmsCount];
        scrollViewController.siteIndex = [self.sitesList indexOfObject:self.selectedSite];
        scrollViewController.selectedSite = [self.sitesListResults objectAtIndex:indexPath.row + self.sitesAlarmsCount];
    } else {
        self.selectedSite = [self.sitesListResults objectAtIndex:indexPath.row + self.sitesAlarmsCount + self.sitesOkCount];
        scrollViewController.selectedSite = [self.sitesListResults objectAtIndex:indexPath.row + self.sitesAlarmsCount + self.sitesOkCount];
        scrollViewController.siteIndex = [self.sitesList indexOfObject:self.selectedSite];
    }
    scrollViewController.sitesList = self.sitesList;

    self.indexOfSelectedSiteInList = [self.sitesList indexOfObject:self.selectedSite];
    [Data sharedData].siteId = [NSNumber numberWithInteger: self.selectedSite.siteID];
    [Data sharedData].hasGenerator = self.selectedSite.hasGenerator;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController:scrollViewController animated:YES];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        // Send relevant Site Info to the detail view manager.
        self.detailViewManager.selectedSite = scrollViewController.selectedSite;
        self.detailViewManager.siteIndex = scrollViewController.siteIndex;
        self.detailViewManager.sitesList = scrollViewController.sitesList;

        // Tell the detail view manager to load a view controller with the selected site's details.
        [self.detailViewManager loadSelectedView];
    }

    // If we show searchresults en select a row we want to show all the sites again and show the selected site from the searchresults
    if (self.isShowingSearchResults) {
        [self sortSitesForSiteListWithArray:self.sitesList];
        [self scrollSiteListToSite:[self.sitesList indexOfObject:self.selectedSite] withDuration:0.0f];
        self.isShowingSearchResults = NO;
    } else {
        self.indexPathSite = indexPath;
    }

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_LIST_PRESS
                                                           label:@"sitelist_list"
                                                           value:nil] build]];
}

-(void)getAttributesForSite:(SiteInfo *)siteInfo withTableViewCell:(UITableViewCell *)cell {

    [Attributes loadSiteAttributesWithSiteID:[NSNumber numberWithInteger:siteInfo.siteID] result:^(AttributesInfo *attributes){
        if (attributes) {
            siteInfo.siteAttributes = attributes;
            siteInfo.isLoadingWidgets = NO;
            [siteInfo setSummaryWidgetsforAttributes:attributes];

            [self reloadCellAfterFetchingWidgetsWithTableViewCell:cell];
        }
        // NSString *failureText for now because not yet decided how to handle this
    } failure:^(NSString *failureText){
        siteInfo.isLoadingWidgets = NO;
        [self reloadCellAfterFetchingWidgetsWithTableViewCell:cell];
    }];
}

-(void) reloadCellAfterFetchingWidgetsWithTableViewCell:(UITableViewCell *)cell {
    // Check if the cell is still in the tableview, because we dont want to reload a cell that does not exist
    NSIndexPath *pathOfTheCellinblock = [self.tableView indexPathForCell:cell];
    if (pathOfTheCellinblock) {

        // Get the selected state of the cell before we reload it
        BOOL cellIsSelected = [self.tableView cellForRowAtIndexPath:pathOfTheCellinblock].selected;

        // Reload the cell
        [self.tableView reloadRowsAtIndexPaths:@[pathOfTheCellinblock] withRowAnimation:UITableViewRowAnimationNone];

        // Check if the cell was selected and if so we set the selected again after we reloaded it
        if (cellIsSelected) {
            [self.tableView selectRowAtIndexPath:pathOfTheCellinblock
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
