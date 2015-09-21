//
// Created by Jim van Zummeren on 13/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MLoginService.h"
#import "KeychainItemWrapper.h"
#import "M2MCredentials.h"
#import "M2MCredentialsStorage.h"
#import "M2MLoginDependantService_protected.h"

@implementation M2MLoginService

- (void)loginWithCredentials:(M2MCredentials *)credentials success:(void (^)(NSInteger))success failure:(void (^)(NSInteger))failure
{
    NSDate *startLogin = [NSDate date];

    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
    [requestParameters setValue:credentials.username forKey:kM2MWebServiceUsername];
    [requestParameters setValue:credentials.password forKey:kM2MWebServicePassword];
    [requestParameters setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [requestParameters setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager POST:URL_SERVER_LOGIN parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //TODO: Test API and see if this alert is really needed in the success block
        UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
        if (alert) {
            if (failure) {
                failure(operation.response.statusCode);
            }
        } else {

            NSDate *finishLogin = [NSDate date];
            [self trackLoginTime:startLogin finishLogin:finishLogin];

            self.currentSessionId = [[[responseObject objectForKey:kM2MResponseData] objectForKey:kM2MResponseUser] objectForKey:kM2MResponseSessionId];

            M2MCredentialsStorage *credentialsStorage = [M2MCredentialsStorage new];
            [credentialsStorage persistCredentials:credentials];

            self.loggedIn = YES;

            if(success){
                success(operation.response.statusCode);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.response.statusCode);
        }
    }];
}

- (void)logout
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
    [keychainItem resetKeychainItem];
    self.currentSessionId = nil;
}

- (void)trackLoginTime:(NSDate *)startLogin finishLogin:(NSDate *)finishLogin
{
    NSTimeInterval executionTime = [finishLogin timeIntervalSinceDate:startLogin];
    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:GA_EVENT_CATEGORY_WEBSERVICE
                                                                 interval:[NSNumber numberWithDouble:executionTime]
                                                                     name:GA_WITH_NAME_LOGIN
                                                                    label:@"splash"] build]];
}

+ (M2MLoginService *)sharedInstance
{
    static M2MLoginService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

@end