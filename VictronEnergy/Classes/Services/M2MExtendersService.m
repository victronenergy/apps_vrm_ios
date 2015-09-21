//
// Created by Jim van Zummeren on 18/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MExtendersService.h"
#import "ExtenderInfo.h"
#import "M2MLoginService.h"
#import "M2MLoginDependantService_protected.h"


@implementation M2MExtendersService

- (void)loadExtendersForSite:(NSInteger)siteID success:(void (^)(NSArray *))success failure:(void (^)(NSInteger))failure {
    [super performWithSuccess:success failure:failure arguments:@[@(siteID)]];
}

- (void)performConcreteServiceWithSuccess:(void (^)(id))success failure:(void (^)(NSInteger))failure arguments:arguments {
    NSNumber *siteID = arguments[0];
    NSMutableDictionary *postValues = [self getPostValuesForSite:siteID];

    [self.manager POST:URL_SERVER_SITES_IO_EXTENDERS parameters:postValues success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *extendersDictionaryArray = [[NSArray alloc] initWithArray:[[responseObject objectForKey:kM2MResponseData] objectForKey:kM2MResponseIOExtenders]];
        NSMutableArray *extenderArray = [[NSMutableArray alloc] init];
        for (NSDictionary *extenderDictionary in extendersDictionaryArray) {
            ExtenderInfo *extenderInfo = [[ExtenderInfo alloc] initWithDictionary:extenderDictionary];
            [extenderArray addObject:extenderInfo];
        }

        if (success) {
            success(extenderArray);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode);
    }];
}

- (NSMutableDictionary *)getPostValuesForSite:(NSNumber *)siteID
{
    NSMutableDictionary *postValues = [[NSMutableDictionary alloc] init];
    postValues[kM2MWebServiceSessionId] = [M2MLoginService sharedInstance].currentSessionId;
    postValues[kM2MWebServiceVerificationToken] = kM2MWebServiceVerificationTokenValue;
    postValues[kM2MWebServiceVersion] = kM2MWebServiceVersionNumber;
    postValues[kM2MWebServiceSiteId] = siteID;
    return postValues;
}
        
@end