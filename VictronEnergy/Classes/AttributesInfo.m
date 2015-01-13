//
//  Attributes.m
//  VictronEnergy
//
//  Created by Victron Energy on 12/9/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "AttributesInfo.h"
#import "Data.h"

NSString *const kM2MAttributeKeyCode = @"code";
NSString *const kM2MAttributeKeyCustomLabel = @"customLabel";
NSString *const kM2MAttributeKeyDataType = @"dataType";
NSString *const kM2MAttributeKeyFormatValueOnly = @"formatValueOnly";
NSString *const kM2MAttributeKeyFormatWithUnit = @"formatWithUnit";
NSString *const kM2MAttributeKeyIdDataAttribute = @"idDataAttribute";
NSString *const kM2MAttributeKeyInstance = @"instance";
NSString *const kM2MAttributeKeyIsValid = @"isValid";
NSString *const kM2MAttributeKeyNameEnum = @"nameEnum";
NSString *const kM2MAttributeKeyTimestamp = @"timestamp";
NSString *const kM2MAttributeKeyValueEnum = @"valueEnum";
NSString *const kM2MAttributeKeyValueFloat = @"valueFloat";
NSString *const kM2MAttributeKeyValueString = @"valueString";


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

-(NSArray *)loadAttributesWithCodes:(NSArray *)attributeCodes withSideID:(NSNumber *)siteID
{
    NSArray *attributesInfoArray = [Attributes loadAttributesWithCodes:attributeCodes withSideID:siteID];
    return attributesInfoArray;
}


@end

@implementation SingleAttributeInfo

- (id) initWithDictionary:(NSDictionary *)attributesDictionary
{
    self = [super init];
    if (self != nil) {
        [self parseFromDictionaryNew:attributesDictionary];
    }

    return self;
}

-(void)parseFromDictionaryNew:(NSDictionary *)attributesDictionary
{
    NSLog(@"dictionairy = %@", attributesDictionary);
    self.attributeCode= [attributesDictionary objectForKey:kM2MAttributeKeyCode];
    self.attributeCustomLabel = [attributesDictionary objectForKey:kM2MAttributeKeyCustomLabel];
    self.attributeDataType = [attributesDictionary objectForKey:kM2MAttributeKeyDataType];
    self.attributeFormatValueOnly = [attributesDictionary objectForKey:kM2MAttributeKeyFormatValueOnly];
    self.attributeFormatWithUnit = [attributesDictionary objectForKey:kM2MAttributeKeyFormatWithUnit];
    self.attributeIdDataAttribute = [attributesDictionary objectForKey:kM2MAttributeKeyIdDataAttribute];
    self.attributeInstance = [attributesDictionary objectForKey:kM2MAttributeKeyInstance];
    self.attributeIsValid = [attributesDictionary objectForKey:kM2MAttributeKeyIsValid];
    self.attributeNameEnum = [attributesDictionary objectForKey:kM2MAttributeKeyNameEnum];
    self.attributeTimeStamp = [attributesDictionary objectForKey:kM2MAttributeKeyTimestamp];
    self.attributeValueEnum = [[attributesDictionary objectForKey:kM2MAttributeKeyValueEnum] integerValue];
    self.attributeValueFloat = [[attributesDictionary objectForKey:kM2MAttributeKeyValueFloat] stringValue];
    self.attributeValueString = [attributesDictionary objectForKey:kM2MAttributeKeyValueString];
}

-(float)getFloatValue
{
    // If the value is set return it as a float if not return 0
    if([self.attributeValueFloat length] != 0) {
        return [self.attributeValueFloat floatValue];
    }

    return 0;
}

@end

@implementation Attributes

+(NSArray *)loadAttributesWithCodes:(NSArray *)attributeCodes withSideID:(NSNumber *)siteID
{
    __block NSArray *attributesInfoArray = nil;

    // Create JSON String for attributeCode array
    NSError *error;
    NSData *attributeCodeJsonData = [NSJSONSerialization dataWithJSONObject:attributeCodes options:kNilOptions error:&error];
    NSString *dataAttributeJson = @"";
    if (attributeCodeJsonData) {
        dataAttributeJson = [[NSString alloc] initWithBytes:[attributeCodeJsonData bytes] length:[attributeCodeJsonData length] encoding:NSUTF8StringEncoding];
    }

    // Set post values
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:siteID forKey:kM2MWebServiceSiteId];
    [postDict setValue:[Data sharedData].sessionId forKey:kM2MWebServiceSessionId];
    [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];
    [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:dataAttributeJson forKey:kM2MWebServiceAttributes];

    NSString *reloadAttributesName = [NSString stringWithFormat:@"attributes%@", [postDict valueForKey:kM2MWebServiceSiteId]];

    [SVProgressHUD show];

    // Call webservice
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URL_SERVER_ATTRIBUTE_OBJECT parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];

        // Read the attributes and put them in the attributesInfo object, pass this to the notification
        AttributesInfo *attributesInfo = [[AttributesInfo alloc]initWithArray:[responseObject objectForKey:KEY_ATTRIBUTES]];
        NSDictionary *tempDict = [NSDictionary dictionaryWithObject:attributesInfo forKey:KEY_ATTRIBUTES_DICT];
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadAttributesName object:nil userInfo:tempDict];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == RETURN_CODE_SESSION_EXPIRED) {
            NSMutableDictionary *postDict = [Tools setPostDict];

            [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [SVProgressHUD dismiss];
                [Data sharedData].sessionId=[responseObject objectForKey:KEY_SESSION_ID];
                [self loadAttributesWithCodes:attributeCodes withSideID:siteID];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [SVProgressHUD dismiss];

                UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

                if (alert) {
                    [alert show];
                }
            }];
        } else {
            [SVProgressHUD dismiss];

            UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

            if (alert) {
                [alert show];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadAttributesName object:nil userInfo:nil];
    }];

    return attributesInfoArray;
}

+(void)loadAttributesWithArray:(NSArray *)attributesArray withSideID:(NSNumber *)siteID
{
    NSString *reloadAttributesName = [NSString stringWithFormat:@"attributes%@", [siteID stringValue]];

    // Read the attributes and put them in the attributesInfo object, pass this to the notification
    AttributesInfo *attributesInfo = [[AttributesInfo alloc]initWithArray:attributesArray];
    NSDictionary *tempDict = [NSDictionary dictionaryWithObject:attributesInfo forKey:KEY_ATTRIBUTES_DICT];
    [[NSNotificationCenter defaultCenter] postNotificationName:reloadAttributesName object:nil userInfo:tempDict];
}

+(void)loadSiteAttributesWithSiteID:(NSNumber *)siteID result:(void(^)(AttributesInfo *))completionBlock failure:(void(^)(NSString *))failure;
{
    __block AttributesInfo *attributesForSite = nil;

    NSArray *attributeCodeArray = @[kAttributeBatteryStateOfCharge, kAttributeBatteryVoltage, kAttributeBatteryState, kAttributePV_AC_CoupledOutputL1, kAttributePV_AC_CoupledOutputL2, kAttributePV_AC_CoupledOutputL3, kAttributePV_AC_CoupledInputL1, kAttributePV_AC_CoupledInputL2, kAttributePV_AC_CoupledInputL3, kAttributePV_DC_Coupled, kAttributeAC_ConsumptionL1, kAttributeAC_ConsumptionL2, kAttributeAC_ConsumptionL3, kAttributeGridL1, kAttributeGridL2, kAttributeGridL3, kAttributeGensetL1, kAttributeGensetL2, kAttributeGensetL3, kAttributeDCSystem];

    NSString *codeString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:attributeCodeArray
                                                                                        options:NSJSONWritingPrettyPrinted
                                                                                          error:nil]
                                                                                       encoding:NSUTF8StringEncoding];

    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:[Data sharedData].sessionId forKey:kM2MWebServiceSessionId];
    [postDict setValue:@"1" forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];
    [postDict setValue:siteID forKey:kM2MWebServiceSiteId];
    [postDict setValue:[NSNumber numberWithInteger:kM2MWebServiceInstanceNumber] forKey:kM2MWebServiceInstance];
    [postDict setObject:codeString forKey:kM2MWebServiceAttributesCodes];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager POST:URL_SERVER_SITES_ATTRIBUTES_BY_CODE parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *responseDictionary = [responseObject objectForKey:kM2MResponseData];
        NSArray *attributesArray = [responseDictionary objectForKey:kM2MResponseAttributes];

        attributesForSite = [[AttributesInfo alloc]initWithArray:attributesArray];
        completionBlock(attributesForSite);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error.localizedDescription for now beacuse not yet decided how to handle this
        failure(error.localizedDescription);
    }];
}

@end
