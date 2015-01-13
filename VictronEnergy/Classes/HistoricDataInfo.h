//
//  HistoricDataInfo.h
//  VictronEnergy
//
//  Created by Victron Energy on 5/7/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributesInfo.h"

@interface HistoricDataInfo : NSObject

@property (nonatomic, strong) NSString *deepestDischarge;
@property (nonatomic, strong) NSString *lastDischarge;
@property (nonatomic, strong) NSString *averageDischarge;
@property (nonatomic, strong) NSString *chargeCycles;
@property (nonatomic, strong) NSString *fullDischarges;
@property (nonatomic, strong) NSString *totalAhDrawn;
@property (nonatomic, strong) NSString *minimumVoltage;
@property (nonatomic, strong) NSString *maximumVoltage;
@property (nonatomic, strong) NSString *timeSinceLastFullCharge;
@property (nonatomic, strong) NSString *automaticSyncs;
@property (nonatomic, strong) NSString *lowVoltgeAlarms;
@property (nonatomic, strong) NSString *hightVoltageAlarms;
@property (nonatomic, strong) NSString *lowStarterVoltageAlarms;
@property (nonatomic, strong) NSString *highStarterVoltageAlarms;
@property (nonatomic, strong) NSString *minimumStarterVoltage;
@property (nonatomic, strong) NSString *maximumStarterVoltage;
@property (nonatomic, assign) NSInteger timeStamp;

- (id)initWithAttributesInfo:(AttributesInfo *)batteryAttributesInfo;
@end
