//
//  M2MSummaryWidgetAcLoad.m
//  VictronEnergy
//
//  Created by Victron Energy on 11/03/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "M2MSummaryWidgetAcLoad.h"
#import "AttributesInfo.h"

@implementation M2MSummaryWidgetAcLoad

-(id)initSummaryWidgetWithAttribute:(AttributesInfo *)attribute{
    self = [self init];
    if (self != nil) {
        self.widgetLabel = NSLocalizedString(@"widget_header_ac_load", @"widget_header_ac_load");
        self.image = [UIImage imageNamed:@"ic_kwh_metre.png"];
        [self setTextWithAttribute:attribute];
    }
    return self;
}

-(void)setTextWithAttribute:(AttributesInfo *)attribute{

    NSArray *attributeCodes = @[kAttributeAC_ConsumptionL1, kAttributeAC_ConsumptionL2, kAttributeAC_ConsumptionL3];
    self.text = [attribute getFormattedValueForCodes:attributeCodes formattedAs:WATTS hideIfUnavailable:NO];
}

+(BOOL)areRequiredAttributesAvailable:(AttributesInfo *)attribute{
    if ([attribute isAttributeSet:kAttributeAC_ConsumptionL1]) {
        return YES;
    }
    return NO;
}

@end
