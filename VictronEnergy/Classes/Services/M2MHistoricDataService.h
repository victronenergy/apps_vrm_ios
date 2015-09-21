//
// Created by Jim van Zummeren on 18/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M2MLoginDependantService.h"

@class AttributesInfo;


@interface M2MHistoricDataService : M2MLoginDependantService

- (void)loadHistoricDataWithSiteID:(NSInteger)siteID instanceNumber:(NSInteger)instanceNumber success:(void (^)(AttributesInfo *))success failure:(void (^)(NSInteger))failure;

@end