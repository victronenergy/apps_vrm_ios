//
//  SiteDetailCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 3/27/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "SiteDetailCell.h"

@implementation SiteDetailCell

-(void)awakeFromNib{

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;

    [Tools style:LabelStyleSiteTitle forLabel:self.nameLabel];
    [Tools style:LabelStyleSiteValue forLabel:self.alarmLabel];
    [Tools style:LabelStyleSiteValue forLabel:self.lastUpdateLabel];

}

-(void)setDataWithSiteObject:(SiteInfo *)info{

    self.nameLabel.text = info.name;
    self.alarmLabel.text = [NSString stringWithFormat:NSLocalizedString(@"alarms_label", @"alarms_label"), info.activeAlarms];
    if (info.lastUpdated == 0) {
        [self.lastUpdateLabel setText:[NSString stringWithFormat:NSLocalizedString(@"no_time_update", @"no_time_update")]];
    }else{
        [self.lastUpdateLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Last update label", @"Last update label"),[Tools stringDateFromCurrentTime:[[NSNumber numberWithInteger:info.lastUpdated] doubleValue]]]];
    }
    if(info.activeAlarms == 0 ){
        self.alarmImage.image = [UIImage imageNamed:@"icon_active.png"];
    }
    else{
        self.alarmImage.image = [UIImage imageNamed:@"icon_inactive.png"];
    }

}

@end
