//
// Created by Jim van Zummeren on 15/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MLoginDependantService_protected.h"
#import "M2MLoginService.h"
#import "M2MCredentials.h"
#import "M2MCredentialsStorage.h"


@implementation M2MLoginDependantService

- (void)performConcreteServiceWithSuccess:(id)success failure:(void (^)(NSInteger))failure arguments:(id)arguments
{
    //Template
    [NSException raise:@"Method not implemented" format:@"performConcreteServiceWithSuccess: should be implemented in the sub class"];
}

- (void)performWithSuccess:(void (^)(id))success failure:(void (^)(NSInteger))failure arguments:arguments
{
    //Try to do the perform the service
    [self performConcreteServiceWithSuccess:success failure:^(NSInteger statusCode) {
        if (statusCode == RETURN_CODE_SESSION_EXPIRED) {
            //If login failed, log in
            [self loginWithSuccess:^(NSInteger statusCode) {
                //Retry perform
                [self performWithSuccess:success failure:failure arguments:arguments];
            } failure:^(NSInteger statusCode) {
                failure(statusCode);
            }];
        } else {
            failure(statusCode);
        }
    } arguments:arguments];
}

- (void)loginWithSuccess:(void (^)(NSInteger))success failure:(void (^)(NSInteger))failure {
    M2MLoginService *loginService = [M2MLoginService sharedInstance];
    [loginService loginWithCredentials:[[M2MCredentialsStorage new] getCurrentUserCredentials] success:success failure:failure];
}

- (AFHTTPRequestOperationManager *)manager
{
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [self getAcceptableContentTypes];
    
    return _manager;
}

- (NSSet *)getAcceptableContentTypes
{
    //Template
    return [NSSet setWithObject:@"application/json"];
}


@end