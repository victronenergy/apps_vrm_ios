//
//  HistoricDataViewController.h
//  VictronEnergy
//
//  Created by Victron Energy on 5/7/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributesInfo.h"
#import "SiteInfo.h"

@interface HistoricDataViewController : GAITrackedViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@property (weak, nonatomic) IBOutlet UILabel *ddNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ddValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *ldNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ldValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *adNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *ccNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ccValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *fdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fdValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *tadNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tadValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *minvNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *minvValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxvNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxvValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *tslcNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tslcValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *asNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *asValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *lvaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lvaValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *hvaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hvaValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *lsvaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lsvaValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *hsvaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hsvaValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *minsvNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *minsvValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxsvNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxsvValueLabel;


@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackground;

@property (nonatomic, assign) NSMutableArray *historicDatatResults;
@property (nonatomic, strong) SiteInfo *selectedSite;

@property (nonatomic, strong) AttributesInfo *siteHistoricAttributesInfo;

@end
