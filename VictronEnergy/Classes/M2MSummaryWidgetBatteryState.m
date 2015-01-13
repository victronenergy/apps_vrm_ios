//
//  M2MSummaryWidgetBatteryState.m
//  VictronEnergy
//
//  Created by Victron Energy on 11/03/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "M2MSummaryWidgetBatteryState.h"
#import "AttributesInfo.h"

@implementation M2MSummaryWidgetBatteryState

-(id)initSummaryWidgetWithAttribute:(AttributesInfo *)attribute{
    self = [self init];
    if (self != nil) {
        self.widgetLabel = NSLocalizedString(@"widget_header_battery_state", @"widget_header_battery_state");
        [self setImageForBatteryState:[attribute getAttributeByCode:kAttributeBatteryState].attributeValueEnum];
        [self setTextForFormattedValue:[attribute getAttributeByCode:kAttributeBatteryState].attributeValueEnum];
    }
    return self;
}

-(void)setImageForBatteryState:(NSInteger)state{
    if(state == 0) {
        self.image = [UIImage imageNamed:@"ic_battery_idle"];
    } else if(state == 1) {
        self.image = [UIImage imageNamed:@"ic_battery_charging"];
    } else if(state == 2) {
        self.image = [UIImage imageNamed:@"ic_battery_discharging"];
    } else {
        self.image = [UIImage imageNamed:@"ic_battery_idle"];
    }
}

-(void)setTextForFormattedValue:(NSInteger)state{
    NSString *batteryStatus =  @"";
    if (state == 0) {
        batteryStatus = @"Idle";
    } else if (state == 1) {
        batteryStatus = @"Charging";
    } else if (state == 2) {
        batteryStatus = @"Discharging";
    }

    self.text = batteryStatus;
}

+(BOOL)areRequiredAttributesAvailable:(AttributesInfo *)attribute{
    if ([attribute isAttributeSet:kAttributeBatteryState]) {
        return YES;
    }
    return NO;
}

@end
