//
//  M2MLoginDependantService_protected.h
//  VictronEnergy
//
//  Created by Jim van Zummeren on 20/07/15.
//  Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MLoginDependantService.h"

@interface M2MLoginDependantService ()

@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;

//Template method which should be implemented in the concrete service class
- (void)performConcreteServiceWithSuccess:(void (^)(id))success failure:(void (^)(NSInteger))failure arguments:arguments;

//Method that takes care of doing a login-safe request which will call performConcreteServiceWithSuccess
- (void)performWithSuccess:(void (^)(id))success failure:(void (^)(NSInteger))failure arguments:(id)arguments;
@end
