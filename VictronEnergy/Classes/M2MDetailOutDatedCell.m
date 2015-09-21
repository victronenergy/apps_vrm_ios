//
//  M2MDetailOutDatedCell.m
//  VictronEnergy
//
//  Created by Lime on 01/04/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MDetailOutDatedCell.h"
#import "NSDate+TimeAgo.h"
#import "M2MDateFormats.h"

@implementation M2MDetailOutDatedCell

-(void)awakeFromNib{

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

    if (siteInfo.lastUpdated == 0) {
        self.lastUpdateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"no_time_update", @"no_time_update")];
    }else{
        NSString *dateString = [[M2MDateFormats sharedInstance] dateStringFromTimeStamp:siteInfo.lastUpdated];;
        self.lastUpdateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last update label", @"Last update label"), dateString];
    }
}

@end
