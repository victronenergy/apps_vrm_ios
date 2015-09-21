//
// Created by Jim van Zummeren on 14/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class M2MCredentials;


@interface M2MCredentialsStorage : NSObject
- (M2MCredentials *)getCurrentUserCredentials;

- (void)persistCredentials:(M2MCredentials *)credentials;
@end