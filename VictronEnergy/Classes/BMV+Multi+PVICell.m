//
//  BMV+Multi+PVICell.m
//  VictronEnergy
//
//  Created by Thijs on 9/10/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "BMV+Multi+PVICell.h"
#import "SingleAttributeInfo.h"

@implementation BMV_Multi_PVICell

-(void)awakeFromNib{

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;

    [Tools style:LabelStyleOverviewValue forLabel:self.acInPhase1Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acInPhase2Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acInPhase3Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acSystemPhase1Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acSystemPhase2Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acSystemPhase3Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.pvInverterPhase1Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.pvInverterPhase2Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.pvInverterPhase3Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.batteryWattsLabel withFormat:AMPS];
    [Tools style:LabelStyleOverviewValue forLabel:self.batteryVoltageLabel withFormat:VOLT];
    [Tools style:LabelStyleOverviewValue forLabel:self.batterySocLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.timeToGoLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.dcSystemValueLabel withFormat:NONE];

    [Tools style:LabelStyleOverviewTitle forLabel:self.dcSystemNameLabel];
    [Tools style:LabelStyleOverviewTitle forLabel:self.acInNameLabel];
    [Tools style:LabelStyleOverviewTitle forLabel:self.acOutNameLabel];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

- (void)setDataWithSite:(SiteInfo *)siteInfo
{
    // Set the arrow directions
    NSArray *acInAttributes = @[kAttributeGensetL1, kAttributeGridL1, kAttributeGensetL2, kAttributeGridL2, kAttributeGridL3, kAttributeGensetL3];
    self.acInArrowImage.image = [Tools arrowImageForPositiveRight:[siteInfo.siteAttributes getValueForCodes:acInAttributes]];

    NSArray *acSystemAttributes = @[kAttributeAC_ConsumptionL1, kAttributeAC_ConsumptionL2, kAttributeAC_ConsumptionL3];
    self.acOutArrowImage.image = [Tools arrowImageForPositiveRight:[siteInfo.siteAttributes getValueForCodes:acSystemAttributes]];

    self.batteryMultiArrowImage.image = [Tools arrowImageForPositiveDown:[siteInfo.siteAttributes getValueForCode:kAttributeVEBusChargeCurrent]];
    self.dcSystemArrowImage.image = [Tools arrowImageForPositiveRight:[siteInfo.siteAttributes getValueForCode:kAttributeDCSystem ]];

    NSArray *pvInverterAttributes = @[kAttributePV_AC_CoupledOutputL1, kAttributePV_AC_CoupledOutputL2, kAttributePV_AC_CoupledOutputL3];
    self.pvInverterArrowImage.image = [Tools arrowImageForAlwaysLeftOrPositive:[siteInfo.siteAttributes getValueForCodes:pvInverterAttributes]];

    // Check if AC In is genset or grid
    NSString *acInTitleName = @"";
    if([siteInfo.siteAttributes isAttributeSet:kAttributeGensetL1]) {
        acInTitleName = NSLocalizedString(@"ac_in_genset", @"ac_in_genset");
    } else {
        acInTitleName = NSLocalizedString(@"ac_in_grid", @"ac_in_grid");
    }

    // Check wich label to use and set the values
    if ([siteInfo.siteAttributes isAttributeSet:kAttributeGensetL3] || [siteInfo.siteAttributes isAttributeSet:kAttributeGridL3]) {
        self.acInNameLabel.hidden = NO;
        self.acInNameLabel.text = acInTitleName;
        self.acInPhase1Label.text = [siteInfo.siteAttributes getFormattedValueForCodes:@[kAttributeGensetL1, kAttributeGridL1] formattedAs:WATTS hideIfUnavailable:NO];
        self.acInPhase2Label.text = [siteInfo.siteAttributes getFormattedValueForCodes:@[kAttributeGensetL2, kAttributeGridL2] formattedAs:WATTS hideIfUnavailable:NO];
        self.acInPhase3Label.text = [siteInfo.siteAttributes getFormattedValueForCodes:@[kAttributeGensetL3, kAttributeGridL3] formattedAs:WATTS hideIfUnavailable:NO];
    } else if ([siteInfo.siteAttributes isAttributeSet:kAttributeGensetL2] || [siteInfo.siteAttributes isAttributeSet:kAttributeGridL2]) {
        [self changeStyleACInNameLabelWithName:acInTitleName];
        self.acInPhase2Label.text = [siteInfo.siteAttributes getFormattedValueForCodes:@[kAttributeGensetL1, kAttributeGridL1] formattedAs:WATTS hideIfUnavailable:NO];
        self.acInPhase3Label.text = [siteInfo.siteAttributes getFormattedValueForCodes:@[kAttributeGensetL2, kAttributeGridL2] formattedAs:WATTS hideIfUnavailable:NO];
    } else {
        [self changeStyleACInNameLabelWithName:acInTitleName];
        self.acInPhase2Label.text = [siteInfo.siteAttributes getFormattedValueForCodes:@[kAttributeGensetL1, kAttributeGridL1] formattedAs:WATTS hideIfUnavailable:NO];
        self.acInPhase3Label.hidden = YES;
    }

    self.acSystemPhase1Label.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeAC_ConsumptionL1 formattedAs:WATTS hideIfUnavailable:NO];
    self.acSystemPhase2Label.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeAC_ConsumptionL2 formattedAs:WATTS hideIfUnavailable:YES];
    self.acSystemPhase3Label.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeAC_ConsumptionL3 formattedAs:WATTS hideIfUnavailable:YES];

    if ([siteInfo.siteAttributes isAttributeSet:kAttributePV_AC_CoupledOutputL3]) {
        self.pvInverterPhase1Label.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributePV_AC_CoupledOutputL1 formattedAs:WATTS hideIfUnavailable:NO];
        self.pvInverterPhase2Label.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributePV_AC_CoupledOutputL2 formattedAs:WATTS hideIfUnavailable:NO];
        self.pvInverterPhase3Label.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributePV_AC_CoupledOutputL3 formattedAs:WATTS hideIfUnavailable:NO];
    } else {
        if ([siteInfo.siteAttributes isAttributeSet:kAttributePV_AC_CoupledOutputL2]) {
            self.pvInverterPhase3Label.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributePV_AC_CoupledOutputL2 formattedAs:WATTS hideIfUnavailable:YES];
            self.pvInverterPhase2Label.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributePV_AC_CoupledOutputL1 formattedAs:WATTS hideIfUnavailable:NO];
            self.pvInverterPhase1Label.hidden = YES;
        } else {
            self.pvInverterPhase3Label.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributePV_AC_CoupledOutputL1 formattedAs:WATTS hideIfUnavailable:NO];
            self.pvInverterPhase2Label.hidden = YES;
            self.pvInverterPhase1Label.hidden = YES;
        }
    }

    self.batteryWattsLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeVEBusChargeCurrent formattedAs:AMPS hideIfUnavailable:NO];

    self.batteryVoltageLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryVoltage formattedAs:VOLT hideIfUnavailable:NO];
    self.batterySocLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryStateOfCharge formattedAs:PERCENTAGE hideIfUnavailable:YES];
    self.timeToGoLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeBatteryTimeToGo formattedAs:TIME hideIfUnavailable:YES];

    self.dcSystemValueLabel.text = [siteInfo.siteAttributes getFormattedValueForCode:kAttributeDCSystem formattedAs:WATTS hideIfUnavailable:NO];

    SingleAttributeInfo *attribute = [siteInfo.siteAttributes getAttributeByCode:kAttributeVEBusState];

    // Hide/Unhide certain parts of the overview
    switch(attribute.attributeValueEnum) {
        case VEBUSSTATE_OFF:
            [self.acInPhase1Label setHidden:YES];
            [self.acInPhase3Label setHidden:YES];
            [self.acInPhase2Label setHidden:YES];
            [self.acInNameLabel setHidden:YES];
            [self.acInArrowImage setHidden:YES];

            [self.acOutArrowImage setHidden:YES];
            [self.acSystemPhase2Label setHidden:YES];
            [self.acSystemPhase1Label setHidden:YES];
            [self.acSystemPhase3Label setHidden:YES];
            [self.acOutNameLabel setHidden:YES];
            break;
        case VEBUSSTATE_LOW_POWER:
            [self.acInPhase1Label setHidden:YES];
            [self.acInPhase3Label setHidden:YES];
            [self.acInPhase2Label setHidden:YES];
            [self.acInNameLabel setHidden:YES];
            [self.acInArrowImage setHidden:YES];
            break;
        case VEBUSSTATE_INVERTING:
            [self.acInPhase1Label setHidden:YES];
            [self.acInPhase3Label setHidden:YES];
            [self.acInPhase2Label setHidden:YES];
            [self.acInNameLabel setHidden:YES];
            [self.acInArrowImage setHidden:YES];
            break;
    }

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
    
     self.acOutNameLabel.text = NSLocalizedString(@"ac_load_title", nil);
}

-(void)changeStyleACInNameLabelWithName: (NSString *)name {
    self.acInNameLabel.hidden = YES;
    [Tools style:LabelStyleOverviewTitle forLabel:self.acInPhase1Label];
    self.acInPhase1Label.text = name;
}

@end
