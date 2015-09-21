//
//  M2MDetailAlarmCell.m
//  VictronEnergy
//
//  Created by Lime on 01/04/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MDetailAlarmCell.h"
#import "NSDate+TimeAgo.h"
#import "M2MDateFormats.h"

@implementation M2MDetailAlarmCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [Tools style:LabelStyleSectionHeader forLabel:self.nameLabel];
    [Tools style:LabelStyleSiteValue forLabel:self.inAlarmLabel];
    self.inAlarmLabel.textColor = COLOR_RED;

    self.headerBackground.image = [[UIImage imageNamed:@"heading_corner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kHeaderInsetImageTop, kHeaderInsetImageLeft, kHeaderInsetImageBottom, kHeaderInsetImageRight)];

    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo{

    self.nameLabel.text = siteInfo.name;

    if (siteInfo.inAlarmSince == 0) {
        [self.inAlarmLabel setText:[NSString stringWithFormat:NSLocalizedString(@"in_alarm_since_no_time", @"in_alarm_since_no_time")]];
    }else{
        NSString *dateString = [[M2MDateFormats sharedInstance] dateStringFromTimeStamp:siteInfo.inAlarmSince];;
        self.inAlarmLabel.text = [NSString stringWithFormat:NSLocalizedString(@"in_alarm_since_label", @"in_alarm_since_label"), dateString];
    }
}

@end
