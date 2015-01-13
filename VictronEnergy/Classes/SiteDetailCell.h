//
//  SiteDetailCell.h
//  VictronEnergy
//
//  Created by Victron Energy on 3/27/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@interface SiteDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alarmImage;

-(void)setDataWithSiteObject:(SiteInfo *)info;

@end
