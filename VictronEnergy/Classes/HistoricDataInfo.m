//
//  HistoricDataInfo.m
//  VictronEnergy
//
//  Created by Thijs on 5/7/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "HistoricDataInfo.h"
#import "Data.h"

@implementation HistoricDataInfo

-(id)init{
    self = [super init];
    if (self) {
        self.deepestDischarge = nil;
        self.lastDischarge = nil;
        self.averageDischarge = nil;
        self.chargeCycles = nil;
        self.fullDischarges = nil;
        self.totalAhDrawn = nil;
        self.minimumVoltage = nil;
        self.maximumVoltage = nil;
        self.timeSinceLastFullCharge = nil;
        self.automaticSyncs = nil;
        self.lowVoltgeAlarms = nil;
        self.hightVoltageAlarms = nil;
        self.lowStarterVoltageAlarms = nil;
        self.highStarterVoltageAlarms = nil;
        self.minimumStarterVoltage = nil;
        self.maximumStarterVoltage = nil;
    }

    return self;
}


- (id)initWithAttributesInfo:(AttributesInfo *)batteryAttributesInfo
{
    self = [self init];
    if (self != nil) {

        //Parse dictionary data in appointment
        [self parseFromAttributesInfo:batteryAttributesInfo];
    }

    return self;
}

-(void)parseFromAttributesInfo:(AttributesInfo *)batteryAttributesInfo
{
    self.deepestDischarge = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataDeepestDischarge formattedAs:AMPHOUR hideIfUnavailable:NO];
    self.lastDischarge = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataLastDischarge formattedAs:AMPHOUR hideIfUnavailable:NO];
    self.averageDischarge = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataAverageDischarge formattedAs:AMPHOUR hideIfUnavailable:NO];
    self.chargeCycles = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataChargeCycles formattedAs:NONE hideIfUnavailable:NO];
    self.fullDischarges = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataFullDischarge formattedAs:NONE hideIfUnavailable:NO];
    self.totalAhDrawn = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataTotalAhDrawn formattedAs:AMPHOUR hideIfUnavailable:NO];
    self.minimumVoltage = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataMinimumVoltage formattedAs:VOLT hideIfUnavailable:NO];
    self.maximumVoltage = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataMaximumVoltage formattedAs:VOLT hideIfUnavailable:NO];
    self.timeSinceLastFullCharge = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataTimeSinceLastFullCharge formattedAs:TIME hideIfUnavailable:NO];
    self.automaticSyncs = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataAutomaticSyncs formattedAs:NONE hideIfUnavailable:NO];
    self.lowVoltgeAlarms = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataLowVoltageAlarms formattedAs:NONE hideIfUnavailable:NO];
    self.hightVoltageAlarms = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataHighVoltageAlarms formattedAs:NONE hideIfUnavailable:NO];
    self.lowStarterVoltageAlarms = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataLowStarterVoltageAlarms formattedAs:NONE hideIfUnavailable:NO];
    self.highStarterVoltageAlarms = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataHighStarterVoltageAlarms formattedAs:NONE hideIfUnavailable:NO];
    self.minimumStarterVoltage = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataMinimumStarterVoltage formattedAs:VOLT hideIfUnavailable:NO];
    self.maximumStarterVoltage = [batteryAttributesInfo getFormattedValueForCode:kHistoricDataMaximumStarterVoltage formattedAs:VOLT hideIfUnavailable:NO];
}

@end

