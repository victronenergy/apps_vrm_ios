//
// Created by Jim van Zummeren on 15/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MAttributesService.h"
#import "AttributesInfo.h"
#import "M2MLoginDependantService_protected.h"
#import "M2MLoginService.h"


@implementation M2MAttributesService

- (void)loadSiteAttributesWithSiteID:(NSNumber *)siteID success:(void (^)(AttributesInfo *))success failure:(void (^)(NSInteger))failure
{
    [super performWithSuccess:success failure:failure arguments:@[siteID]];
}

- (void)performConcreteServiceWithSuccess:(void (^)(id))success failure:(void (^)(NSInteger))failure arguments:arguments {

    NSNumber *siteID = arguments[0];
    NSMutableDictionary *postValues = [self getPostValuesWithSiteID:siteID];

    [self.manager POST:URL_SERVER_GET_SITE_ATTRIBUTES parameters:postValues success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *responseDictionary = [responseObject objectForKey:kM2MResponseData];
        NSArray *attributesArray = responseDictionary[kM2MResponseAttributes];

        AttributesInfo *attributesForSite = [[AttributesInfo alloc]initWithArray:attributesArray];
        if(success) {
            success(attributesForSite);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode);
    }];
}

- (NSMutableDictionary *)getPostValuesWithSiteID:(NSNumber *)siteID
{
    NSMutableDictionary *postValues = [[NSMutableDictionary alloc] init];
    postValues[kM2MWebServiceSiteId] = siteID;
    postValues[kM2MWebServiceSessionId] = [M2MLoginService sharedInstance].currentSessionId;
    postValues[kM2MWebServiceVerificationToken] = kM2MWebServiceVerificationTokenValue;
    postValues[kM2MWebServiceVersion] = kM2MWebServiceVersionNumber;
    postValues[kM2MWebServiceInstance] = @(kM2MWebServiceInstanceNumber);
    return postValues;
}

@end