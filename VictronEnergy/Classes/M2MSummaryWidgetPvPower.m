//
//  M2MSummaryWidgetPvPower.m
//  VictronEnergy
//
//  Created by Lime on 11/03/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MSummaryWidgetPvPower.h"
#import "AttributesInfo.h"

@implementation M2MSummaryWidgetPvPower

-(id)initSummaryWidgetWithAttribute:(AttributesInfo *)attribute{
    self = [self init];
    if (self != nil) {
        self.widgetLabel = NSLocalizedString(@"widget_header_pv_power", @"widget_header_pv_power");
        self.image = [UIImage imageNamed:@"ic_weather_00.png"];
        [self setTextWithAttribute:attribute];
    }
    return self;
}

-(void)setTextWithAttribute:(AttributesInfo *)attribute{

    NSArray *attributeCodes = @[kAttributePV_AC_CoupledOutputL1, kAttributePV_AC_CoupledOutputL2, kAttributePV_AC_CoupledOutputL3, kAttributePV_AC_CoupledInputL1, kAttributePV_AC_CoupledInputL2, kAttributePV_AC_CoupledInputL3, kAttributePV_DC_Coupled];

    self.text = [attribute getFormattedValueForCodes:attributeCodes formattedAs:WATTS hideIfUnavailable:NO];
}

+(BOOL)areRequiredAttributesAvailable:(AttributesInfo *)attribute{
    if ([attribute isAttributeSet:kAttributePV_AC_CoupledOutputL1] || [attribute isAttributeSet:kAttributePV_AC_CoupledInputL1] || [attribute isAttributeSet:kAttributePV_DC_Coupled]) {
        return YES;
    }
    return NO;
}

@end
