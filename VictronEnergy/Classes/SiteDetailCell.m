//
//  SiteDetailCell.m
//  VictronEnergy
//
//  Created by Thijs on 3/27/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "SiteDetailCell.h"
#import "NSDate+TimeAgo.h"
#import "M2MDateFormats.h"

@implementation SiteDetailCell

-(void)awakeFromNib{

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;

    [Tools style:LabelStyleSiteTitle forLabel:self.nameLabel];
    [Tools style:LabelStyleSiteValue forLabel:self.alarmLabel];
    [Tools style:LabelStyleSiteValue forLabel:self.lastUpdateLabel];
}

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo
{

    self.nameLabel.text = siteInfo.name;
    self.alarmLabel.text = [NSString stringWithFormat:NSLocalizedString(@"alarms_label", @"alarms_label"), siteInfo.activeAlarms];
    if (siteInfo.lastUpdated == 0) {
        [self.lastUpdateLabel setText:[NSString stringWithFormat:NSLocalizedString(@"no_time_update", @"no_time_update")]];
    }else{
        NSString *dateString = [[M2MDateFormats sharedInstance] dateStringFromTimeStamp:siteInfo.lastUpdated];;
        self.lastUpdateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last update label", @"Last update label"), dateString];
    }
    if(siteInfo.activeAlarms == 0 ){
        self.alarmImage.image = [UIImage imageNamed:@"icon_active.png"];
    }
    else{
        self.alarmImage.image = [UIImage imageNamed:@"icon_inactive.png"];
    }

}

@end
