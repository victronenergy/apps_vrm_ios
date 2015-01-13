//
//  M2MDetailAlarmCell.h
//  VictronEnergy
//
//  Created by Victron Energy on 01/04/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@interface M2MDetailAlarmCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastUpdateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *alarmImage;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackground;
@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo;

@end
