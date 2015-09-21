//
//  SiteListTable.h
//  Victron Energy
//
//  Created by Thijs on 3/12/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SiteInfo.h"

@class SitesScrollViewController;

@interface SiteListTableViewController : UITableViewController <UISearchBarDelegate, EGORefreshTableHeaderDelegate, UIAlertViewDelegate, UISplitViewControllerDelegate>{

    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

/// iPad - This property is used as a reference to the Splitview's detail view manager.
@property (strong, nonatomic) SitesScrollViewController *detailViewManager;

@property (nonatomic, assign) NSInteger sitesAlarmsCount;
@property (nonatomic, assign) NSInteger sitesOldCount;
@property (nonatomic, assign) NSInteger sitesOkCount;
@property (strong, nonatomic) NSMutableArray *sitesAlarmsArray;
@property (strong, nonatomic) NSMutableArray *sitesOkArray;
@property (strong, nonatomic) NSMutableArray *sitesOldArray;

@property (nonatomic, assign) BOOL noSiteAvailable;
@property (nonatomic, assign) BOOL isShowingSearchResults;
@property (nonatomic, assign) NSInteger indexOfSelectedSiteInList;

@property (strong, nonatomic) SiteInfo *selectedSite;

@property (strong, nonatomic) NSMutableArray *sitesList;
/// A sorted list of sites.
@property (strong, nonatomic) NSMutableArray *sitesListResults;

@property (nonatomic, strong) NSIndexPath *indexPathSite;

@property (strong, nonatomic) UIButton *webviewButton;
@property (strong, nonatomic) UIButton *aboutButton;

@property (weak, nonatomic) IBOutlet UINavigationItem *logoutButton;
@property (weak, nonatomic) IBOutlet UISearchBar *sitesSearchBar;

@property(nonatomic, strong) NSDate *lastReloadDate;

@property(nonatomic, strong) SitesScrollViewController *scrollViewController;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)loadFirstSiteDetailView;
- (void)scrollSiteListToSite:(int)sitePositionInSiteDetails withDuration:(float)duration;

@end



