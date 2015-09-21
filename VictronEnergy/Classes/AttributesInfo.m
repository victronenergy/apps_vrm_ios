//
//  Attributes.m
//  VictronEnergy
//
//  Created by Lime on 12/9/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "AttributesInfo.h"
#import "Data.h"
#import "M2MLoginService.h"
#import "SingleAttributeInfo.h"

@implementation AttributesInfo

-(id)initWithArray:(NSArray *)attributesArray
{
    self = [super init];
    if(self != nil) {
        NSMutableArray *tempAttributesArray = [[NSMutableArray alloc]init];
        for (NSDictionary *attributeDictionary in attributesArray) {
            NSAssert([attributeDictionary isKindOfClass:[NSDictionary class]], @"failed no dictionary");
            SingleAttributeInfo *attributesInfo =[[SingleAttributeInfo alloc]initWithDictionary:attributeDictionary];

            [tempAttributesArray addObject:attributesInfo];
        }
        self.attributes = [[NSArray alloc]initWithArray:tempAttributesArray];
    }
    return self;
}

-(SingleAttributeInfo *)getAttributeByCode:(NSString *)attributeCode
{
    if(self.attributes)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attributeCode == %@", attributeCode];
        NSArray *attributePredicateResult =  [self.attributes filteredArrayUsingPredicate:predicate];
        if ([attributePredicateResult count] > 0) {
            return [attributePredicateResult firstObject];
        }
    }
    return nil;
}

-(float)getValueForCode:(NSString *)attributeCode
{
    SingleAttributeInfo *attribute = [self getAttributeByCode:attributeCode];
    if(attribute == nil || [attribute.attributeValueFloat length] == 0) {
        return 0;
    }
    return [attribute getFloatValue];
}

-(float)getValueForCodes:(NSArray *)attributeCodes
{
    NSMutableArray *attributeArray = [[NSMutableArray alloc] init];
    float returnValue = 0;
    for(int i = 0; i < [attributeCodes count]; i++) {
        SingleAttributeInfo *attribute = [self getAttributeByCode:[attributeCodes objectAtIndex:i]];
        if(attribute != nil && [attribute.attributeValueFloat length] != 0) {
            [attributeArray addObject:attribute];
            returnValue += [attribute getFloatValue];
        }
    }

    return returnValue;
}

-(BOOL)isAttributeSet:(NSString *)attributeCode
{
    SingleAttributeInfo *attribute = [self getAttributeByCode:attributeCode];
    if(!attribute) {
        return false;
    }
    return true;
}

-(NSString*)getFormattedValueForCode:(NSString *)attributeCode formattedAs:(Format)format hideIfUnavailable:(BOOL)shouldHide
{
    SingleAttributeInfo *attribute = [self getAttributeByCode:attributeCode];
    if(attribute == nil || [attribute.attributeValueFloat length] == 0) {
        if(shouldHide) {
            return @"";
        }
        return [self getNotAvailableStringForFormat:format];
    }

    switch(format) {
        case WATTS:
            return [self formatWatts:[attribute getFloatValue]];
        case VOLT:
            return [self formatVolt:[attribute getFloatValue]];
        case AMPHOUR:
            return [self formatAmpHours:[attribute getFloatValue]];
        case AMPS:
            return [self formatAmps:[attribute getFloatValue]];
        case PERCENTAGE:
            return [self formatPercentage:[attribute getFloatValue]];
        case TIME:
            return [self formatTime:[attribute getFloatValue]];
        case NONE:
            return attribute.attributeValueFloat;
    }
}

-(NSString*)getFormattedValueForCodes:(NSArray *)attributeCodes formattedAs:(Format)format hideIfUnavailable:(BOOL)shouldHide
{
    NSMutableArray *attributeArray = [[NSMutableArray alloc] init];
    float returnValue = 0;
    for(int i = 0; i < [attributeCodes count]; i++) {
        SingleAttributeInfo *attribute = [self getAttributeByCode:[attributeCodes objectAtIndex:i]];

        if(attribute != nil && [attribute.attributeValueFloat length] != 0) {
            [attributeArray addObject:attribute];
            returnValue += [attribute getFloatValue];
        }
    }

    if([attributeArray count] == 0)
    {
        if(shouldHide) {
            return @"";
        }
        return [self getNotAvailableStringForFormat:format];
    }

    switch(format) {
        case WATTS:
            return [self formatWatts:returnValue];
        case VOLT:
            return [self formatVolt:returnValue];
        case AMPHOUR:
            return [self formatAmpHours:returnValue];
        case AMPS:
            return [self formatAmps:returnValue];
        case PERCENTAGE:
            return [self formatPercentage:returnValue];
        case TIME:
            return [self formatTime:returnValue];
        case NONE:
            return 0;
    }

    return 0;
}

-(NSString *)formatWatts:(float)value
{
    // Check if this value should be formatted as kW or W
    if(value >= 10000) {
        // Divide by 1000 to get kW
        value /= 1000;
        return [[NSString alloc] initWithFormat:@"%.01fkW", fabsf(value)];
    }
    return [[NSString alloc] initWithFormat:@"%.fW", fabsf(value)];
}

-(NSString *)formatPercentage:(float)value
{
    if (value) {
        return [[NSString alloc] initWithFormat:@"%.01f%%", value];
    } else {
        return @"---";
    }
}

-(NSString *)formatVolt:(float)value
{
    return [[NSString alloc] initWithFormat:@"%.02fV", value];
}

-(NSString *)formatTime:(float)value
{
    if (value) {
        // Amount of hours
        int hours = floorf(value);

        // Amount of seconds multiplied by 60 to get the amount of minutes
        int minutes = roundf((value - hours) * 60);

        return [[NSString alloc] initWithFormat:@"%ih %im", hours, minutes];

    } else {
        return @"--h --m";
    }
}

-(NSString *)formatAmps:(float)value
{
    return [[NSString alloc] initWithFormat:@"%.01fA", fabsf(value)];
}

-(NSString *)formatAmpHours:(float)value
{
    return [[NSString alloc] initWithFormat:@"%.02fAh", value];
}

-(NSString *)getNotAvailableStringForFormat:(Format) format
{
    switch(format) {
        case WATTS:
            return @"---W";
        case VOLT:
            return @"---V";
        case AMPHOUR:
            return @"---Ah";
        case AMPS:
            return @"---A";
        case PERCENTAGE:
            return @"---%";
        case TIME:
            return @"--h --m";
        case NONE:
            return @"--";
    }
}

@end
