//
// Created by Jim van Zummeren on 15/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M2MLoginDependantService.h"

@class AttributesInfo;
@class M2MLoginService;


@interface M2MAttributesService : M2MLoginDependantService
- (void)loadSiteAttributesWithSiteID:(NSNumber *)siteID success:(void (^)(AttributesInfo *))success failure:(void (^)(NSInteger))failure;

@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end