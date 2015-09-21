//
// Created by Jim van Zummeren on 14/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MCredentialsStorage.h"
#import "KeychainItemWrapper.h"
#import "M2MCredentials.h"


@implementation M2MCredentialsStorage

- (M2MCredentials *) getCurrentUserCredentials{
    M2MCredentials *credentials = [M2MCredentials new];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];

    credentials.username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    credentials.password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];

    return credentials;
}

- (void)persistCredentials:(M2MCredentials *)credentials
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
    [keychainItem setObject:credentials.username forKey:(__bridge id) (kSecAttrAccount)];
    [keychainItem setObject:credentials.password forKey:(__bridge id) (kSecValueData)];
}
@end