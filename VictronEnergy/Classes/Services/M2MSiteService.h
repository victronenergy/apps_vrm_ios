//
// Created by Jim van Zummeren on 15/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MLoginDependantService.h"

@class SiteInfo;

@interface M2MSiteService : M2MLoginDependantService
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;

- (void)getSitesWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSInteger))failure;
@end