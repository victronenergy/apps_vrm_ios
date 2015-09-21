//
//  Data.h
//  Victron Energy
//
//  Created by Thijs on 3/15/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Data : NSObject

+(Data *)sharedData;

@property (nonatomic, assign) BOOL isAnAlertViewShowing;

@end

