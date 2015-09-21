//
// Created by Jim van Zummeren on 18/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M2MLoginDependantService.h"


@interface M2MExtendersService : M2MLoginDependantService

- (void)loadExtendersForSite:(NSInteger)siteID success:(void (^)(NSArray *))success failure:(void (^)(NSInteger))failure;

@end