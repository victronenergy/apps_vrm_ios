//
//  BMV+MPPTCell.m
//  VictronEnergy
//
//  Created by Mandarin on 30/01/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "BMV+MPPTCell.h"

@implementation BMV_MPPTCell

-(void)awakeFromNib{

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;

    [Tools style:LabelStyleOverviewValue forLabel:self.solarWattLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.batteryVoltageLabel withFormat:VOLT];
    [Tools style:LabelStyleOverviewValue forLabel:self.batterySocLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.timeToGoLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.consumedLabel withFormat:AMPHOUR];
    [Tools style:LabelStyleOverviewValue forLabel:self.dcSystemValueLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewTitle forLabel:self.dcSystemNameLabel];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

- (void)setDataWithSite:(SiteInfo *)siteInfo
{
    // Set the arrow directions
    self.dcSystemArrowImage.image = [Tools arrowImageForPositiveRight:[siteInfo.siteAttributes getValueForCode:kAttributeDCSystem ]];
    self.solarArrowImageView.image = [Tools arrowImageForAlwaysRightOrPositive:[siteInfo.siteAttributes getValueForCode:kAttributePV_DC_Coupled]];

    // Set the values
    self.batteryVoltageLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryVoltage formattedAs:VOLT hideIfUnavailable:NO];
    self.consumedLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryConsumedAmphours formattedAs:AMPHOUR hideIfUnavailable:NO];
    self.batterySocLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryStateOfCharge formattedAs:PERCENTAGE hideIfUnavailable:YES];
    self.timeToGoLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryTimeToGo formattedAs:TIME hideIfUnavailable:YES];
    self.dcSystemValueLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeDCSystem formattedAs:WATTS hideIfUnavailable:NO];
    self.solarWattLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributePV_DC_Coupled formattedAs:WATTS hideIfUnavailable:NO];

    // Show hide DC System
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
