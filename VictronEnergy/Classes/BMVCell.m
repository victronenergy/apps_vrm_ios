//
//  SiteDetail2Cell.m
//  VictronEnergy
//
//  Created by Thijs on 3/27/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "BMVCell.h"
#import "SiteInfo.h"

@implementation BMVCell

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;

    [Tools style:LabelStyleOverviewValue forLabel:self.dcSystemValueLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.socLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.timeToGoLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.voltageLabel withFormat:VOLT];
    [Tools style:LabelStyleOverviewValue forLabel:self.consumedLabel withFormat:AMPHOUR];

    [Tools style:LabelStyleOverviewTitle forLabel:self.dcSystemNameLabel];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

- (void)setDataWithSite:(SiteInfo *)siteInfo
{
    // Set the values
    self.voltageLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryVoltage formattedAs:VOLT hideIfUnavailable:FALSE];
    self.timeToGoLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryTimeToGo formattedAs:TIME hideIfUnavailable:YES];
    self.consumedLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryConsumedAmphours formattedAs:AMPHOUR hideIfUnavailable:FALSE];
    self.dcSystemValueLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeDCSystem formattedAs:WATTS hideIfUnavailable:FALSE];
    self.socLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryStateOfCharge formattedAs:PERCENTAGE hideIfUnavailable:YES];

    // Set the arrow directions
    self.dcSystemArrowImage.image = [Tools arrowImageForPositiveRight:[siteInfo.siteAttributes getValueForCode:kAttributeDCSystem ]];

    // Show hide certain parts of the overview
    if(siteInfo.hasDcSystem == 0) {
        [self.dcSystemArrowImage setHidden:YES];
        [self.dcSystemValueLabel setHidden:YES];
        [self.dcSystemNameLabel setHidden:YES];
    } else {
        [self.dcSystemArrowImage setHidden:NO];
        [self.dcSystemValueLabel setHidden:NO];
        [self.dcSystemNameLabel setHidden:NO];
    }
}

@end
