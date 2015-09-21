//
// Created by Jim van Zummeren on 20/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MSiteInfoService.h"
#import "SiteInfo.h"
#import "M2MSiteService.h"
#import "M2MLoginDependantService_protected.h"
#import "M2MLoginService.h"

@implementation M2MSiteInfoService

- (void)getSiteWithID:(NSInteger)siteID success:(void (^)(SiteInfo *))success failure:(void (^)(NSInteger))failure{
    [super performWithSuccess:success failure:failure arguments:@[@(siteID)]];
}

- (void)performConcreteServiceWithSuccess:(void (^)(id))success failure:(void (^)(NSInteger))failure arguments:arguments {
    NSNumber *siteID = arguments[0];

    NSMutableDictionary *postValues = [self getPostValuesWithSite:siteID];

    [self.manager POST:URL_SERVER_SITES_GET_SITE parameters:postValues success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *sites = [M2MSiteInfoService getSitesWithResponseObject:responseObject];
        SiteInfo *siteInfo = [sites firstObject];
        success(siteInfo);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode);
    }];
}

+ (NSArray *)getSitesWithResponseObject:(id)responseObject
{
    NSArray *sitesDictionaryArray = [[NSArray alloc] initWithArray:[[responseObject objectForKey:kM2MResponseData] objectForKey:kM2MResponseSites]];
    NSMutableArray *sites = [[NSMutableArray alloc] init];

    for (NSDictionary *siteDictionary in sitesDictionaryArray) {
        SiteInfo *siteInfo = [[SiteInfo alloc] initWithDictionary:siteDictionary];
        [sites addObject:siteInfo];
    }

    return sites;
}

- (NSMutableDictionary *)getPostValuesWithSite:(NSNumber *)siteID
{
    NSMutableDictionary *postValues = [[NSMutableDictionary alloc] init];
    postValues[kM2MWebServiceSessionId] = [M2MLoginService sharedInstance].currentSessionId;
    postValues[kM2MWebServiceVerificationToken] = kM2MWebServiceVerificationTokenValue;
    postValues[kM2MWebServiceVersion] = kM2MWebServiceVersionNumber;
    postValues[kM2MWebServiceSiteId] = siteID;

    return postValues;
}

@end