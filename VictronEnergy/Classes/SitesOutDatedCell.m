//
//  SitesOutDatedCell.m
//  VictronEnergy
//
//  Created by Mandarin on 21/02/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "SitesOutDatedCell.h"

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

#warning iPad - For some reason iOS stretches the view for which we created an outlet in storyboard. By programmatically creating a view with the same size we can force iOS to respect the set size.
    UIView *contentViewSelected = [[UIView alloc] initWithFrame:self.frame];
    UIView *siteViewSelected = [[UIView alloc] initWithFrame:CGRectMake(self.backgroundViewForFrame.frame.origin.x, self.backgroundViewForFrame.frame.origin.y, self.backgroundViewForFrame.frame.size.width, self.backgroundViewForFrame.frame.size.height)];
    siteViewSelected.backgroundColor = COLOR_GREY_SELECTION;
    contentViewSelected.backgroundColor = COLOR_BACKGROUND;
    [contentViewSelected addSubview:siteViewSelected];
    self.selectedBackgroundView = contentViewSelected;
}

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo{

    self.nameLabel.text = siteInfo.name;

    if (siteInfo.lastUpdated == 0) {
        [self.lastUpdateLabel setText:[NSString stringWithFormat:NSLocalizedString(@"no_time_update", @"no_time_update")]];
    }else{
        [self.lastUpdateLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Last update label", @"Last update label"),[Tools stringDateFromCurrentTime:[[NSNumber numberWithInteger:siteInfo.lastUpdated] doubleValue]]]];
    }
}

@end
