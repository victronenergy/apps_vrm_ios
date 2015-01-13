//
//  NoSitesAvailableCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 08/04/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "NoSitesAvailableCell.h"

@implementation NoSitesAvailableCell

- (void)awakeFromNib
{
    [Tools style:LabelStyleOverviewTitle forLabel:self.noSitesFoundLabel];
    self.noSitesFoundLabel.text = NSLocalizedString(@"no_sites_found", @"no_sites_found");
    self.backgroundColor = COLOR_BACKGROUND;
    self.contentView.backgroundColor = COLOR_BACKGROUND;
}


@end
