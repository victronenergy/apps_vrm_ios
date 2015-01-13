//
//  SitesOutDatedCell.h
//  VictronEnergy
//
//  Created by Mandarin on 21/02/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@interface SitesOutDatedCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastUpdateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *alarmImage;

@property (weak, nonatomic) IBOutlet UIView *backgroundViewForFrame;

@property (weak, nonatomic) IBOutlet UIView *selectedBackgroundViewForFrame;
@property (weak, nonatomic) IBOutlet UIView *selectedBackgroundViewFrame;

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo;

@end
