//
//  M2MDetailAlarmCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 01/04/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "M2MDetailAlarmCell.h"

@implementation M2MDetailAlarmCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [Tools style:LabelStyleSectionHeader forLabel:self.nameLabel];
    [Tools style:LabelStyleSiteValue forLabel:self.lastUpdateLabel];
    self.lastUpdateLabel.textColor = COLOR_RED;

    self.headerBackground.image = [[UIImage imageNamed:@"heading_corner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kHeaderInsetImageTop, kHeaderInsetImageLeft, kHeaderInsetImageBottom, kHeaderInsetImageRight)];

    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo{

    self.nameLabel.text = siteInfo.name;

    if (siteInfo.inAlarmSince == 0) {
        [self.lastUpdateLabel setText:[NSString stringWithFormat:NSLocalizedString(@"in_alarm_since_no_time", @"in_alarm_since_no_time")]];
    }else{
        [self.lastUpdateLabel setText:[NSString stringWithFormat:NSLocalizedString(@"in_alarm_since_label", @"in_alarm_since_label"),[Tools stringDateFromCurrentTime:[[NSNumber numberWithInteger:siteInfo.inAlarmSince] doubleValue]]]];
    }
}

@end
