//
// Created by Jim van Zummeren on 15/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MSiteService.h"
#import "M2MLoginService.h"
#import "SiteInfo.h"
#import "M2MLoginDependantService_protected.h"

@implementation M2MSiteService

- (void)getSitesWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSInteger))failure{
    [super performWithSuccess:success failure:failure arguments:nil];
}

- (void)performConcreteServiceWithSuccess:(void (^)(id))success failure:(void (^)(NSInteger))failure arguments:arguments {
    NSMutableDictionary *postDict = [self getPostValues];

    [self.manager POST:URL_SERVER_SITES_GET parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *sites = [M2MSiteService getSitesWithResponseObject:responseObject];
        if(success) {
            success(sites);
        }
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

- (NSMutableDictionary *)getPostValues
{
    NSMutableDictionary *postValues = [[NSMutableDictionary alloc] init];
    postValues[kM2MWebServiceSessionId] = [M2MLoginService sharedInstance].currentSessionId;
    postValues[kM2MWebServiceVerificationToken] = kM2MWebServiceVerificationTokenValue;
    postValues[kM2MWebServiceVersion] = kM2MWebServiceVersionNumber;
    return postValues;
}

@end