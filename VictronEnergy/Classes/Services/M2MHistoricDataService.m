//
// Created by Jim van Zummeren on 18/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MHistoricDataService.h"
#import "AttributesInfo.h"
#import "M2MLoginDependantService_protected.h"
#import "M2MLoginService.h"

@implementation M2MHistoricDataService

- (void)loadHistoricDataWithSiteID:(NSInteger)siteID instanceNumber:(NSInteger)instanceNumber success:(void (^)(AttributesInfo *))success failure:(void (^)(NSInteger))failure {
    [super performWithSuccess:success failure:failure arguments:@[@(siteID), @(instanceNumber)]];
}

- (void)performConcreteServiceWithSuccess:(void (^)(id))success failure:(void (^)(NSInteger))failure arguments:arguments {
    NSNumber *siteID = (NSNumber *) arguments[0];
    NSNumber *instanceNumber = (NSNumber *) arguments[1];

    NSMutableDictionary *postValues = [self getPostValuesWithSite:siteID instanceNumber:instanceNumber];

    [self.manager POST:URL_SERVER_ATTRIBUTE_OBJECT parameters:postValues success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = [responseObject objectForKey:kM2MResponseData];
        NSArray *attributesArray = responseDictionary[kM2MResponseAttributes];
        AttributesInfo *attributesInfo = [[AttributesInfo alloc] initWithArray:attributesArray];
        if(success){
            success(attributesInfo);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode);
    }];

}

- (NSMutableDictionary *)getPostValuesWithSite:(NSNumber *)siteID instanceNumber:(NSNumber *)instanceNumber
{
    NSMutableDictionary *postValues = [[NSMutableDictionary alloc] init];
    postValues[kM2MWebServiceSessionId] = [M2MLoginService sharedInstance].currentSessionId;
    postValues[kM2MWebServiceVerificationToken] = kM2MWebServiceVerificationTokenValue;
    postValues[kM2MWebServiceVersion] = kM2MWebServiceVersionNumber;
    postValues[kM2MWebServiceSiteId] = siteID;
    postValues[kM2MWebServiceInstance] = instanceNumber;
    postValues[kM2MWebServiceAttributes] = [self getAttributesAsString];
    return postValues;
}

- (NSString *)getAttributesAsString
{
    NSArray *attributesArray = @[
        kHistoricDataDeepestDischarge,
        kHistoricDataLastDischarge,
        kHistoricDataAverageDischarge,
        kHistoricDataChargeCycles,
        kHistoricDataFullDischarge,
        kHistoricDataTotalAhDrawn,
        kHistoricDataMinimumVoltage,
        kHistoricDataMaximumVoltage,
        kHistoricDataTimeSinceLastFullCharge,
        kHistoricDataAutomaticSyncs,
        kHistoricDataLowVoltageAlarms,
        kHistoricDataHighVoltageAlarms,
        kHistoricDataLowStarterVoltageAlarms,
        kHistoricDataHighStarterVoltageAlarms,
        kHistoricDataMinimumStarterVoltage,
        kHistoricDataMaximumStarterVoltage
    ];
    return [attributesArray componentsJoinedByString:@","];
}

@end