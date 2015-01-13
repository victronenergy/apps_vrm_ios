//
//  Data.h
//  Victron Energy
//
//  Created by Victron Energy on 3/15/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Data : NSObject

+(Data *)sharedData;
//add the properties you want to share
@property (nonatomic,copy) NSString *sessionId;
@property (nonatomic,copy) NSNumber *siteId;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@property (nonatomic, assign) BOOL hasGenerator;
@property (nonatomic, assign) BOOL userIsDemoUser;
@property (nonatomic, assign) BOOL userIsLoggedIn;

@property (nonatomic, assign) BOOL isAnAlertViewShowing;

+ (void)updateData;

@end

