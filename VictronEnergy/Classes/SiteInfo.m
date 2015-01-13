//
//  SiteInfo.m
//  Victron Energy
//
//  Created by Victron Energy on 3/15/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "SiteInfo.h"
#import "Data.h"
#import "SiteListTableViewController.h"
#import "KeychainItemWrapper.h"
#import "AttributesInfo.h"
#import "M2MSummaryWidget.h"
#import "M2MSummaryWidgetStateOfCharge.h"
#import "M2MSummaryWidgetAcPowerIn.h"
#import "M2MSummaryWidgetAcLoad.h"
#import "M2MSummaryWidgetDcPowerSystem.h"
#import "M2MSummaryWidgetBatteryState.h"
#import "M2MSummaryWidgetPvPower.h"

enum WidgetsName {
    WidgetStateOfCharge,
    WidgetBatteryState,
    WidgetPvPower,
    WidgetAcLoad,
    WidgetAcPowerIn,
    WidgetDcPowerSystem,
    summaryWidgetsCount
} WidgetsName;

@implementation SiteInfo

-(id)init{
    self = [super init];
    if (self != nil) {
        self.name = nil;
        self.activeAlarms = 0;
        self.lastUpdated = 0;
        self.siteID = 0;
        self.hasGenerator = 0;
        self.hasIOExtender = 0;
        self.phone = nil;
        self.canEditSite = 0;
        self.instanceNumber = 0;
        self.siteStatus = 0;
        self.inAlarmSince = 0;
        self.siteAttributes = nil;
        self.siteSummaryWidgets = nil;
        self.isLoadingWidgets = YES;
      }

    return self;
}

- (id)initWithDictionary:(NSDictionary *)siteDictionary
{
    self = [self init];
    if (self != nil) {

        //Parse dictionary data in appointment
        [self parseFromDictionary:siteDictionary];
    }

    return self;
}

-(void)parseFromDictionary:(NSDictionary *)siteDictionary
{

    self.name =[Tools validatedString:[siteDictionary objectForKey:KEY_SITE_NAME ]];
    self.phone = [Tools validatedString:[siteDictionary objectForKey:KEY_SITE_PHONE]];
    self.hasGenerator = [[siteDictionary objectForKey:KEY_SITE_HAS_GENERATOR] boolValue];
    self.activeAlarms =[[siteDictionary objectForKey:KEY_SITE_ACTIVE_ALARMS]intValue];
    self.lastUpdated = [[siteDictionary objectForKey:KEY_SITE_LAST_UPDATE]intValue];
    self.siteID = [[siteDictionary objectForKey:KEY_SITE_ID]intValue];
    self.hasIOExtender = [[siteDictionary objectForKey:KEY_SITE_HAS_IO_EXTENDER]boolValue];
    self.canEditSite = [[siteDictionary objectForKey:KEY_SITE_CAN_EDIT]boolValue];
    self.hasDcSystem = [[siteDictionary objectForKey:KEY_SITE_HAS_DC_SYSTEM]boolValue];
    self.inAlarmSince = [[siteDictionary objectForKey:KEY_SITE_ALARM_STARTED]integerValue];

    self.instanceNumber = [[siteDictionary objectForKey:kM2MResponseSiteInstanceNumber] integerValue];
    if (self.instanceNumber == -1) {
        self.instanceNumber = 0;
    }

    self.imageURLS = [siteDictionary objectForKey:kM2MResponseSiteImages];

    [self checkStatusOfSite];
}

-(void)checkStatusOfSite{
    // If the lastupdate is older than two weeks the siteStatus is old
    NSInteger twoWeeksOld = [[NSDate date]timeIntervalSince1970] - kTimeSinceTwoWeeksInSeconds;
    if (self.lastUpdated < twoWeeksOld) {
        self.siteStatus = OLD;
    } else {
        // If there are alarms the siteStatus is alarms and of not the siteStatus is Ok
        if (self.activeAlarms > 0) {
            self.siteStatus = ALARMS;
        } else {
            self.siteStatus = OK;
        }
    }
}

-(NSString *)description
{
    NSString *descriptionText = [NSString stringWithFormat:NSLocalizedString(@"site_description", @"site_description"), _name, _activeAlarms];
    return descriptionText;
}

-(void)setSummaryWidgetsforAttributes:(AttributesInfo *)attributes{

    self.siteSummaryWidgets = [[NSMutableArray alloc]init];

    // Bool indicating if AC Load is used in the list of widgets
    BOOL isACLoadInUse = NO;

    for (int i = 0; i < summaryWidgetsCount; i++) {

        switch(i) {
            case WidgetStateOfCharge:{
                if ([M2MSummaryWidgetStateOfCharge areRequiredAttributesAvailable:attributes]) {
                    M2MSummaryWidgetStateOfCharge *widget = [[M2MSummaryWidgetStateOfCharge alloc]initSummaryWidgetWithAttribute:attributes];
                    [self.siteSummaryWidgets addObject:widget];
                }
                break;
            }
            case WidgetBatteryState:{
                if ([M2MSummaryWidgetBatteryState areRequiredAttributesAvailable:attributes]) {
                    M2MSummaryWidgetBatteryState *widget = [[M2MSummaryWidgetBatteryState alloc]initSummaryWidgetWithAttribute:attributes];
                    [self.siteSummaryWidgets addObject:widget];
                }
                break;
            }
            case WidgetPvPower:{
                if ([M2MSummaryWidgetPvPower areRequiredAttributesAvailable:attributes]) {
                    M2MSummaryWidgetPvPower *widget = [[M2MSummaryWidgetPvPower alloc]initSummaryWidgetWithAttribute:attributes];
                    [self.siteSummaryWidgets addObject:widget];
                }
                break;
            }
            case WidgetAcLoad:{
                if ([M2MSummaryWidgetAcLoad areRequiredAttributesAvailable:attributes]) {
                    M2MSummaryWidgetAcLoad *widget = [[M2MSummaryWidgetAcLoad alloc]initSummaryWidgetWithAttribute:attributes];
                    [self.siteSummaryWidgets addObject:widget];
                    // AC Load Widet is added so this indicates that AC Load is in use
                    isACLoadInUse = YES;
                }
                break;
            }
            case WidgetAcPowerIn:{
                if ([M2MSummaryWidgetAcPowerIn areRequiredAttributesAvailable:attributes]) {
                    M2MSummaryWidgetAcPowerIn *widget = [[M2MSummaryWidgetAcPowerIn alloc]initSummaryWidgetWithAttribute:attributes];

                    // If AC Load is in use we insert AC Power in before AC Load
                    if (isACLoadInUse) {
                        [self.siteSummaryWidgets insertObject:widget atIndex:[self.siteSummaryWidgets count]-1];
                    } else {
                        // Else we insert it in the default order
                        [self.siteSummaryWidgets addObject:widget];
                    }
                }
                break;
            }
            case WidgetDcPowerSystem:{
                if ([M2MSummaryWidgetDcPowerSystem areRequiredAttributesAvailable:attributes]) {
                    M2MSummaryWidgetDcPowerSystem *widget = [[M2MSummaryWidgetDcPowerSystem alloc]initSummaryWidgetWithAttribute:attributes];
                    [self.siteSummaryWidgets addObject:widget];
                }
                break;
            }
        }
    }
    int spotsOnNewPage = [self.siteSummaryWidgets count] %3;

    // If spotsOnNewPage is 1 this means there are 2 spots left on a new page so we insert two empty widgets to fill the page
    // Else we inset 1 empty widget
    if (spotsOnNewPage == 1) {

        for (int i = 0; i < 2; i++) {
            M2MSummaryWidget *emptyWidget = [[M2MSummaryWidget alloc] init];
            [self.siteSummaryWidgets addObject:emptyWidget];
        }
    } else if (spotsOnNewPage == 2) {
        M2MSummaryWidget *emptyWidget = [[M2MSummaryWidget alloc] init];
        [self.siteSummaryWidgets addObject:emptyWidget];
    }
}

-(void)refreshSiteInfoObject:(void (^)(BOOL succes))completionSucces
{

    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:[Data sharedData].sessionId forKey:kM2MWebServiceSessionId];
    [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];
    [postDict setValue:[NSNumber numberWithInteger:self.siteID] forKey:kM2MWebServiceSiteId];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URL_SERVER_SITES_GET_SITE parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *siteDictionairy = [[[responseObject objectForKey:kM2MResponseData] objectForKey:kM2MResponseSites] firstObject];

        [self parseFromDictionary:siteDictionairy];

        completionSucces(YES);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (operation.response.statusCode == RETURN_CODE_SESSION_EXPIRED) {
            NSMutableDictionary *postDict = [Tools setPostDict];

            [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [SVProgressHUD dismiss];

                [Data sharedData].sessionId = [responseObject objectForKey:KEY_SESSION_ID];
                [self refreshSiteInfoObject:nil];

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
            completionSucces(NO);
        }
    }];
}

@end

@implementation Sites

+(NSArray *)getSites
{
    __block NSArray *sitesArray = nil;

    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:[Data sharedData].sessionId forKey:kM2MWebServiceSessionId];
    [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];

    [SVProgressHUD show];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URL_SERVER_SITES_GET parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];

        NSArray *sitesDictionaryArray = [[NSArray alloc]initWithArray:[[responseObject objectForKey:kM2MResponseData] objectForKey:kM2MResponseSites]];

        NSMutableArray *tempSiteArray = [[NSMutableArray alloc]init];
        for (id siteDictionary in sitesDictionaryArray) {
            SiteInfo *siteInfo =[[SiteInfo alloc]initWithDictionary:siteDictionary];

            [tempSiteArray addObject:siteInfo];
        }
        sitesArray = [[NSArray alloc]initWithArray:tempSiteArray];
        NSDictionary *tempDict = [NSDictionary dictionaryWithObject:[sitesArray copy] forKey:KEY_SITES_DICT];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SITE_LIST object:nil userInfo:tempDict];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (operation.response.statusCode == RETURN_CODE_SESSION_EXPIRED) {
            NSMutableDictionary *postDict = [Tools setPostDict];

            [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [SVProgressHUD dismiss];

                [Data sharedData].sessionId=[responseObject objectForKey:KEY_SESSION_ID];
                [self getSites];

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
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SITE_LIST object:nil userInfo:nil];
        }

    }];
    return sitesArray;
}



@end
