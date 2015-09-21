//
//  SettingsDetailTableViewController.h
//  VictronEnergy
//
//  Created by Thijs on 4/12/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@interface SettingsDetailTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *extendersList;
@property (strong, nonatomic) NSMutableArray *outputList;
@property (strong, nonatomic) NSMutableArray *siteSettingsList;
@property (strong, nonatomic) NSMutableDictionary *siteSettingsDict;

@property (weak, nonatomic) NSString *siteName;
@property (assign, nonatomic) BOOL siteHasGenerator;
@property (assign, nonatomic) NSInteger siteHasIOExtenders;
@property (assign, nonatomic) NSInteger generatorState;

@property (strong, nonatomic) NSString *selectedOutput;
@property (assign, nonatomic) NSNumber *outputIndexpath;
@property (assign, nonatomic) BOOL siteAlreadyExists;

@property (strong, nonatomic) SiteInfo *selectedSite;

@property (strong, nonatomic) UIPopoverController *selectOutputPopover;

- (IBAction)switchChange:(id)sender;

- (void) setSelectedOutputWithOutputIndex:(NSInteger) index;

@end
