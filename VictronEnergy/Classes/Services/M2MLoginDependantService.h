//
// Created by Jim van Zummeren on 15/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface M2MLoginDependantService : NSObject
- (void)loginWithSuccess:(void (^)(NSInteger))success failure:(void (^)(NSInteger))failure;
@end