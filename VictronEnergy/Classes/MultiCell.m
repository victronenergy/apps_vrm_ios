//
//  MultiCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 3/28/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "MultiCell.h"

@implementation MultiCell

-(void)awakeFromNib{

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;

    [Tools style:LabelStyleOverviewValue forLabel:self.acInPhase2Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acInPhase1Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acInPhase3Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acSystemPhase2Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acSystemPhase1Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.acSystemPhase3Label withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.dcCurrentLabel withFormat:NONE];
    [Tools style:LabelStyleOverviewValue forLabel:self.batteryVoltageLabel withFormat:VOLT];
    [Tools style:LabelStyleOverviewValue forLabel:self.batterySocLabel withFormat:NONE];

    [Tools style:LabelStyleOverviewTitle forLabel:self.acInNameLabel];
    [Tools style:LabelStyleOverviewTitle forLabel:self.acOutNameLabel];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

-(void)setDataWithAttributesInfo:(AttributesInfo *)attributesInfo withSite:(SiteInfo *)siteInfo
{
    // Set the arrow directions
    NSArray *acInAttributes = [NSArray arrayWithObjects:kAttributeGensetL1, kAttributeGridL1, kAttributeGensetL2, kAttributeGridL2, kAttributeGridL3, kAttributeGensetL3, nil];
    self.acInArrowImage.image = [Tools arrowImageForPositiveRight:[attributesInfo getValueForCodes:acInAttributes]];
    NSArray *acSystemAttributes = [NSArray arrayWithObjects:kAttributeAC_ConsumptionL1, kAttributeAC_ConsumptionL2, kAttributeAC_ConsumptionL3, nil];
    self.acOutArrowImage.image = [Tools arrowImageForPositiveRight:[attributesInfo getValueForCodes:acSystemAttributes]];
    self.currentArrowImage.image = [Tools arrowImageForPositiveDown:[attributesInfo getValueForCode:kAttributeVEBusChargeCurrent]];

    // Check if AC In is genset or grid
    NSString *acInTitleName = @"";
    if([attributesInfo isAttributeSet:kAttributeGensetL1]) {
        acInTitleName = NSLocalizedString(@"ac_in_genset", @"ac_in_genset");
    } else {
        acInTitleName = NSLocalizedString(@"ac_in_grid", @"ac_in_grid");
    }

    // Check wich label to use and set the values
    if ([attributesInfo isAttributeSet:kAttributeGensetL3] || [attributesInfo isAttributeSet:kAttributeGridL3]) {
        self.acInNameLabel.hidden = NO;
        self.acInNameLabel.text = acInTitleName;
        self.acInPhase1Label.text = [attributesInfo getFormattedValueForCodes:[NSArray arrayWithObjects:kAttributeGensetL1, kAttributeGridL1, nil] formattedAs:WATTS hideIfUnavailable:NO];
        self.acInPhase2Label.text = [attributesInfo getFormattedValueForCodes:[NSArray arrayWithObjects:kAttributeGensetL2, kAttributeGridL2, nil] formattedAs:WATTS hideIfUnavailable:NO];
        self.acInPhase3Label.text = [attributesInfo getFormattedValueForCodes:[NSArray arrayWithObjects:kAttributeGensetL3, kAttributeGridL3, nil] formattedAs:WATTS hideIfUnavailable:NO];
    } else if ([attributesInfo isAttributeSet:kAttributeGensetL2] || [attributesInfo isAttributeSet:kAttributeGridL2]) {
        [self changeStyleACInNameLabelWithName:acInTitleName];
        self.acInPhase2Label.text = [attributesInfo getFormattedValueForCodes:[NSArray arrayWithObjects:kAttributeGensetL1, kAttributeGridL1, nil] formattedAs:WATTS hideIfUnavailable:NO];
        self.acInPhase3Label.text = [attributesInfo getFormattedValueForCodes:[NSArray arrayWithObjects:kAttributeGensetL2, kAttributeGridL2, nil] formattedAs:WATTS hideIfUnavailable:NO];
    } else {
        [self changeStyleACInNameLabelWithName:acInTitleName];
        self.acInPhase2Label.text = [attributesInfo getFormattedValueForCodes:[NSArray arrayWithObjects:kAttributeGensetL1, kAttributeGridL1, nil] formattedAs:WATTS hideIfUnavailable:NO];
        self.acInPhase3Label.hidden = YES;
    }

    if ([attributesInfo isAttributeSet:kAttributeAC_ConsumptionL3]) {
        self.acOutNameLabel.hidden = NO;
        self.acSystemPhase1Label.text = [attributesInfo getFormattedValueForCode:kAttributeAC_ConsumptionL1 formattedAs:WATTS hideIfUnavailable:NO];
        self.acSystemPhase2Label.text = [attributesInfo getFormattedValueForCode:kAttributeAC_ConsumptionL2 formattedAs:WATTS hideIfUnavailable:NO];
        self.acSystemPhase3Label.text = [attributesInfo getFormattedValueForCode:kAttributeAC_ConsumptionL3 formattedAs:WATTS hideIfUnavailable:NO];
    } else if ([attributesInfo isAttributeSet:kAttributeAC_ConsumptionL2]) {
        [self changeStyleACLoadNameLabel];
        self.acSystemPhase2Label.text = [attributesInfo getFormattedValueForCode:kAttributeAC_ConsumptionL1 formattedAs:WATTS hideIfUnavailable:NO];
        self.acSystemPhase3Label.text = [attributesInfo getFormattedValueForCode:kAttributeAC_ConsumptionL2 formattedAs:WATTS hideIfUnavailable:NO];
    } else {
        [self changeStyleACLoadNameLabel];
        self.acSystemPhase2Label.text = [attributesInfo getFormattedValueForCode:kAttributeAC_ConsumptionL1 formattedAs:WATTS hideIfUnavailable:NO];
        self.acSystemPhase3Label.hidden = YES;
    }

    self.batteryVoltageLabel.text = [attributesInfo getFormattedValueForCode:kAttributeBatteryVoltage formattedAs:VOLT hideIfUnavailable:NO];
    self.batterySocLabel.text = [attributesInfo getFormattedValueForCode:kAttributeBatteryStateOfCharge formattedAs:PERCENTAGE hideIfUnavailable:YES];
    self.dcCurrentLabel.text = [attributesInfo getFormattedValueForCode:kAttributeVEBusChargeCurrent formattedAs:AMPS hideIfUnavailable:NO];

    SingleAttributeInfo *attribute = [attributesInfo getAttributeByCode:kAttributeVEBusState];

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

    if (!siteInfo.usesVEBusSOC) {
        [self.batterySocLabel setHidden:YES];
    }else{
        [self.batterySocLabel setHidden:NO];
    }
}

-(void)changeStyleACInNameLabelWithName: (NSString *)name {
    self.acInNameLabel.hidden = YES;
    [Tools style:LabelStyleOverviewTitle forLabel:self.acInPhase1Label];
    self.acInPhase1Label.text = name;
}

-(void)changeStyleACLoadNameLabel{
    self.acOutNameLabel.hidden = YES;
    [Tools style:LabelStyleOverviewTitle forLabel:self.acSystemPhase1Label];
    self.acSystemPhase1Label.text = NSLocalizedString(@"ac_load_title", nil);
}

@end
