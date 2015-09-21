//
//  ExtenderInfo.m
//  Victron Energy
//
//  Created by Thijs on 3/15/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "ExtenderInfo.h"
#import "Data.h"
#import "KeychainItemWrapper.h"
#import "M2MLoginService.h"

@implementation ExtenderInfo

//@synthesize timeStamp,code,dataAtributeID,label,status,temperature;

-(id)init{
    self = [super init];
    if (self != nil) {
        self.timeStamp = 0;
        self.code = 0;
        self.dataAtributeID = 0;
        self.label = 0;

        // I need this later
        self.status = 0;
        //self.temperature = 0;
    }

    return self;
}

- (id)initWithDictionary:(NSDictionary *)extenderDictionary
{
    self = [self init];
    if (self != nil) {

        //Parse dictionary data in appointment
        [self parseFromDictionary:extenderDictionary];
    }

    return self;
}


-(void)parseFromDictionary:(NSDictionary *)extenderDictionary
{
    self.timeStamp = [[extenderDictionary objectForKey:KEY_EXTENDER_TIMESTAMP]intValue];
    self.code =[extenderDictionary objectForKey:KEY_EXTENDER_CODE];
    self.dataAtributeID = [[extenderDictionary objectForKey:KEY_EXTENDER_DATA_ATTRIBUTE]intValue];
    self.label = [extenderDictionary objectForKey:KEY_EXTENDER_LABEL];

    // I need this later

    if ([extenderDictionary objectForKey:KEY_EXTENDER_STATUS] == [NSNull null]) {
    }
    else{
        self.status = [[extenderDictionary objectForKey:KEY_EXTENDER_STATUS]boolValue];
        if ([[self.code substringToIndex:2] isEqualToString:EXTENDER_OUTPUT]) {
            self.status = ![[extenderDictionary objectForKey:KEY_EXTENDER_STATUS]boolValue];
        }
    }

    if ([extenderDictionary objectForKey:KEY_EXTENDER_TEMPERATURE] == [NSNull null]) {
    }
    else{
        self.temperature = [[extenderDictionary objectForKey:KEY_EXTENDER_TEMPERATURE]floatValue];
    }
}

+(ExtenderInfo *)getExtenderForSettingsList:(NSDictionary *)settings thatMatchesTheExtenderInTheoutputList:(NSArray *)outputs{
    //ExtenderInfo *extenderInfo = [[ExtenderInfo alloc]init];

    //Check if the extender that is selected in settings is output 1 or output 2 and then return the right extender
    if ([[settings objectForKey:KEY_OUTPUT_INDEXPATH] isEqualToNumber:[NSNumber numberWithInt:0]] ) {
        for (ExtenderInfo *extenderInfo in outputs)
        {
            if ([extenderInfo.code isEqualToString:EXTENDER_OUTPUT_1]) {
                return extenderInfo;
            }
        }


    } else {
        for (ExtenderInfo *extenderInfo in outputs)
        {
            if ([extenderInfo.code isEqualToString:EXTENDER_OUTPUT_2]) {

                return extenderInfo;
            }
        }
    }
    return nil;
}

@end
