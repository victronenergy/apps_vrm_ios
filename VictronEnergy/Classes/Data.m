//
//  Data.m
//  Victron Energy
//
//  Created by Victron Energy on 3/15/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "Data.h"
#import "Constants.h"
#import "SynthesizeSingleton.h"


@implementation Data

SYNTHESIZE_SINGLETON_FOR_CLASS(Data);

#pragma mark - initialisation

-(id)init{
    self = [super init];
    if (self != nil) {

//        // Add any setup here

        self.sessionId = @"";
        self.siteId = 0;
        self.username = @"";
        self.password = @"";
        self.hasGenerator = 0;
        self.userIsDemoUser = NO;
        self.userIsLoggedIn = NO;
        self.isAnAlertViewShowing = NO;
//        //get here the initial values of all your objects

        }
    return self;
}

#pragma mark - public methods

+ (void)updateData
{
    //call the getters of the dataobjects you want to be updated;
}

@end
