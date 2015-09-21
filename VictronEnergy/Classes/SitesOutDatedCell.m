//
//  SitesOutDatedCell.m
//  VictronEnergy
//
//  Created by Mandarin on 21/02/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "SitesOutDatedCell.h"
#import "NSDate+TimeAgo.h"
#import "M2MDateFormats.h"

@interface SitesOutDatedCell ()
@property (nonatomic) BOOL didLayoutSubviews;
@end

@implementation SitesOutDatedCell

-(void)awakeFromNib{

    self.backgroundColor = COLOR_BACKGROUND;
    self.contentView.backgroundColor = COLOR_BACKGROUND;

    [Tools style:LabelStyleSiteTitle forLabel:self.nameLabel];
    [Tools style:LabelStyleSiteValue forLabel:self.lastUpdateLabel];
    self.lastUpdateLabel.textColor = COLOR_RED;

    self.backgroundViewForFrame.backgroundColor = COLOR_WHITE;
    self.backgroundViewForFrame.layer.borderColor = COLOR_LINE.CGColor;
    self.backgroundViewForFrame.layer.borderWidth = 1.0f;

    self.selectedBackgroundViewFrame.backgroundColor = COLOR_LIGHT_GREY;
}

- (void)layoutSubviews
{
    if(!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.backgroundViewForFrame.frame];
        self.selectedBackgroundView.backgroundColor = COLOR_GREY_SELECTION;
    }
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
