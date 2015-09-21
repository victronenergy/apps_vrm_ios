//
// Created by Jim van Zummeren on 13/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

@class M2MCredentials;

@interface M2MLoginService : NSObject
@property(nonatomic) BOOL loggedIn;

@property(nonatomic, strong) id currentSessionId;

- (void)loginWithCredentials:(M2MCredentials *)credentials success:(void (^)(NSInteger))success failure:(void (^)(NSInteger))failure;

+ (M2MLoginService *)sharedInstance;

- (void)logout;

@end