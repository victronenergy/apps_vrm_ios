//
//  M2MSummaryWidgetStateOfCharge.m
//  VictronEnergy
//
//  Created by Lime on 11/03/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MSummaryWidgetStateOfCharge.h"
#import "AttributesInfo.h"

@implementation M2MSummaryWidgetStateOfCharge

-(id)initSummaryWidgetWithAttribute:(AttributesInfo *)attribute{
    self = [self init];
    if (self != nil) {
        self.widgetLabel = NSLocalizedString(@"widget_header_battery_soc", @"widget_header_battery_soc");
        if ([attribute isAttributeSet:kAttributeBatteryStateOfCharge]) {
            [self setImageForStateOfCharge:[attribute getValueForCode:kAttributeBatteryStateOfCharge]];
            [self setTextForFormattedValue:[attribute getFormattedValueForCode:kAttributeBatteryStateOfCharge formattedAs:PERCENTAGE hideIfUnavailable:NO]];
        } else if ([attribute isAttributeSet:kAttributeBatteryVoltage]) {
            self.image = [UIImage imageNamed:@"ic_battery_voltage"];
            [self setTextForFormattedValue:[attribute getFormattedValueForCode:kAttributeBatteryVoltage formattedAs:VOLT hideIfUnavailable:NO]];
        }
    }
    return self;
}

-(void)setImageForStateOfCharge:(float)stateOfCharge{

    // Check which icon we should use
    if (stateOfCharge > 99.99f) {
        self.image = [UIImage imageNamed:@"ic_battery_4.png"];
    } else if (stateOfCharge > 75) {
        self.image = [UIImage imageNamed:@"ic_battery_3.png"];
    } else if (stateOfCharge > 50) {
        self.image = [UIImage imageNamed:@"ic_battery_2.png"];
    } else if (stateOfCharge > 25) {
        self.image = [UIImage imageNamed:@"ic_battery_1.png"];
    } else {
        self.image = [UIImage imageNamed:@"ic_battery_0.png"];
    }
}

-(void)setTextForFormattedValue:(NSString *)text{
    self.text = text;
}

+(BOOL)areRequiredAttributesAvailable:(AttributesInfo *)attribute{
    if ([attribute isAttributeSet:kAttributeBatteryStateOfCharge] || [attribute isAttributeSet:kAttributeBatteryVoltage]) {
        return YES;
    }
    return NO;
}

@end
