//
//  M2MSummaryWidgetDcPowerSystem.m
//  VictronEnergy
//
//  Created by Victron Energy on 11/03/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "M2MSummaryWidgetDcPowerSystem.h"
#import "AttributesInfo.h"

@implementation M2MSummaryWidgetDcPowerSystem

-(id)initSummaryWidgetWithAttribute:(AttributesInfo *)attribute{
    self = [self init];
    if (self != nil) {
        self.widgetLabel = NSLocalizedString(@"widget_header_dc_power_system", @"widget_header_dc_power_system");
        self.image = [UIImage imageNamed:@"ic_kwh_metre.png"];
        [self setTextForFormattedValue:[attribute getFormattedValueForCode:kAttributeDCSystem formattedAs:WATTS hideIfUnavailable:NO]];
    }
    return self;
}

-(void)setTextForFormattedValue:(NSString *)text{
    self.text = text;
}

+(BOOL)areRequiredAttributesAvailable:(AttributesInfo *)attribute{
    if ([attribute isAttributeSet:kAttributeDCSystem]) {
        return YES;
    }
    return NO;
}

@end
