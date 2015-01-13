//
//  SitesScrollViewController.h
//  VictronEnergy
//
//  Created by Victron Energy on 4/24/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@interface SitesScrollViewController : UIViewController <UISplitViewControllerDelegate>

/// iPad - This property is used as a reference to the Splitview controller.
@property (nonatomic, strong) UISplitViewController *splitViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property ( nonatomic, assign) float oldY;

@property (strong, nonatomic) SiteInfo *selectedSite;

@property (strong, nonatomic) NSArray *sitesList;

@property (strong, nonatomic) NSMutableArray *extendersList;
@property (strong, nonatomic) NSMutableArray *tempExtenderList;

@property (strong, nonatomic) NSMutableArray *viewControllerArray;
@property (assign, nonatomic) NSInteger siteIndex;

@property (nonatomic, assign) NSInteger lastContentOffset;
@property (nonatomic, assign) NSInteger currentPage;

@property (strong, nonatomic) UIButton *webviewButton;

@property (nonatomic, strong) UIPopoverController *popover;

- (void)resizeScrollView;
- (void)loadSelectedView;
- (void)showMasterPopoverInPortrait;
- (void)hideMasterPopoverInPortrait;

@end
