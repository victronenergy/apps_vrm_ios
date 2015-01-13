//
//  ExtenderInfo.m
//  Victron Energy
//
//  Created by Victron Energy on 3/15/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "ExtenderInfo.h"
#import "Data.h"
#import "KeychainItemWrapper.h"

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

@implementation Extender

+(NSArray *)getExtenders
{
    __block NSArray *extendersArray = nil;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:[Data sharedData].sessionId forKey:kM2MWebServiceSessionId];
    [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];
    [postDict setValue:[Data sharedData].siteId forKey:kM2MWebServiceSiteId];
    NSString *reloadExtenderName = [NSString stringWithFormat:@"extender%@", [postDict valueForKey:kM2MWebServiceSiteId]];

    [SVProgressHUD show];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URL_SERVER_SITES_IO_EXTENDERS parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];

        NSArray *extendersDictionaryArray = [[NSArray alloc]initWithArray:[[responseObject objectForKey:kM2MResponseData] objectForKey:kM2MResponseIOExtenders]];
        NSMutableArray *tempExtenderArray = [[NSMutableArray alloc]init];
        for (id extenderDictionary in extendersDictionaryArray) {
            ExtenderInfo *extenderInfo =[[ExtenderInfo alloc]initWithDictionary:extenderDictionary];
            [tempExtenderArray addObject:extenderInfo];
        }
        extendersArray = [[NSArray alloc]initWithArray:tempExtenderArray];
        NSDictionary *tempDict = [NSDictionary dictionaryWithObject:[extendersArray copy] forKey:KEY_EXTENDERS_DICT];
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadExtenderName object:nil userInfo:tempDict];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == RETURN_CODE_SESSION_EXPIRED) {
            NSMutableDictionary *postDict = [Tools setPostDict];

            [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [SVProgressHUD dismiss];
                [Data sharedData].sessionId=[responseObject objectForKey:KEY_SESSION_ID];
                [self getExtenders];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [SVProgressHUD dismiss];

                UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

                if (alert) {
                    [alert show];
                }
            }];
        } else {
            [SVProgressHUD dismiss];

            UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

            if (alert) {
                [alert show];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadExtenderName object:nil userInfo:nil];
    }];

    return extendersArray;
}
@end
