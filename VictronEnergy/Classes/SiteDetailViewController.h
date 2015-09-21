//
//  SiteDetailViewController.h
//  VictronEnergy
//
//  Created by Thijs on 3/27/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"
#import "AttributesInfo.h"
#import <MessageUI/MessageUI.h>
#import "EGORefreshTableHeaderView.h"

@interface SiteDetailViewController : UITableViewController <MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate, EGORefreshTableHeaderDelegate, UICollectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>{
    BOOL _reloading;
}

@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (strong, nonatomic) SiteInfo *selectedSite;
@property (nonatomic) Scenario currentOverview;
@property (nonatomic, assign) BOOL hasSetGeneratorSettings;

@property (strong, nonatomic) NSDictionary *siteSettingsListResults;
@property (strong, nonatomic) NSMutableArray *extendersList;
@property (strong, nonatomic) NSMutableArray *tempExtenderList;
@property (strong, nonatomic) NSMutableArray *outputList;
@property (weak, nonatomic) NSString *smsOutput;
@property (weak, nonatomic) NSString *changedDCSystem;

@property (assign, nonatomic) BOOL siteSettingsAlreadyInList;
@property (assign, nonatomic) BOOL startGenerator;
@property (assign, nonatomic) NSInteger selectedOutput;
@property (assign, nonatomic) NSInteger selectedSiteInList;
@property (strong, nonatomic) NSMutableArray *siteSettingsList;
@property (strong, nonatomic) NSString *reloadAttributesName;
@property (strong, nonatomic) NSString *reloadExtenderName;

@property (strong, nonatomic) IBOutlet UICollectionView *imageCollectionView;

- (IBAction)switchChange:(id)sender;
- (IBAction)changeGeneratorButtonPressed:(id)sender;
- (IBAction)historicDataButtonPressed:(id)sender;

@end
