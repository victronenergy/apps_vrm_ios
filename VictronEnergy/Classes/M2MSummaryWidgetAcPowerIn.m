//
//  M2MSummaryWidgetAcPowerIn.m
//  VictronEnergy
//
//  Created by Lime on 11/03/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MSummaryWidgetAcPowerIn.h"
#import "AttributesInfo.h"

@implementation M2MSummaryWidgetAcPowerIn

-(id)initSummaryWidgetWithAttribute:(AttributesInfo *)attribute{
    self = [self init];
    if (self != nil) {
        if ([attribute isAttributeSet:kAttributeGensetL1]) {
            // Genset
            self.widgetLabel = NSLocalizedString(@"widget_header_genset", @"widget_header_genset");
            self.image = [UIImage imageNamed:@"ic_genset"];
        } else {
            // Grid
            self.widgetLabel = NSLocalizedString(@"widget_header_grid", @"widget_header_grid");
            self.image = [UIImage imageNamed:@"ic_kwh_metre"];
        }
        [self setTextWithAttribute:attribute];
    }
    return self;
}

-(void)setTextWithAttribute:(AttributesInfo *)attribute{

    NSArray *attributeCodes = @[kAttributeGridL1, kAttributeGridL2, kAttributeGridL3, kAttributeGensetL1, kAttributeGensetL2, kAttributeGensetL3];
    self.text = [attribute getFormattedValueForCodes:attributeCodes formattedAs:WATTS hideIfUnavailable:NO];
}

+(BOOL)areRequiredAttributesAvailable:(AttributesInfo *)attribute{
    if ([attribute isAttributeSet:kAttributeGridL1] || [attribute isAttributeSet:kAttributeGensetL1]) {
        return YES;
    }
    return NO;
}

@end
