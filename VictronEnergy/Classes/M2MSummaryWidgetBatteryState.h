//
//  M2MSummaryWidgetBatteryState.h
//  VictronEnergy
//
//  Created by Lime on 11/03/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MSummaryWidget.h"
@class AttributesInfo;

@interface M2MSummaryWidgetBatteryState : M2MSummaryWidget

-(id)initSummaryWidgetWithAttribute:(AttributesInfo *)attribute;
+(BOOL)areRequiredAttributesAvailable:(AttributesInfo *)attribute;

@end
