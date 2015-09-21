//
//  Data.m
//  Victron Energy
//
//  Created by Thijs on 3/15/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "Data.h"
#import "Constants.h"
#import "SynthesizeSingleton.h"


@implementation Data

SYNTHESIZE_SINGLETON_FOR_CLASS(Data);

-(id)init{
    self = [super init];
    if (self != nil) {
        self.isAnAlertViewShowing = NO;
    }
    return self;
}

@end
