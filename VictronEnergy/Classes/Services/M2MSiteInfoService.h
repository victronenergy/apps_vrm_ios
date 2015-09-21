//
// Created by Jim van Zummeren on 20/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M2MLoginDependantService.h"

@class SiteInfo;

@interface M2MSiteInfoService : M2MLoginDependantService
- (void)getSiteWithID:(NSInteger)id success:(void (^)(SiteInfo *))success failure:(void (^)(NSInteger))failure;
@end