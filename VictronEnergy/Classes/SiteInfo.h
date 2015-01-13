//
//  SiteInfo.h
//  Victron Energy
//
//  Created by Victron Energy on 3/15/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributesInfo.h"

@interface SiteInfo : NSObject

@property (nonatomic, assign) NSInteger siteID;
@property (nonatomic, assign) NSInteger vebusState;
@property (nonatomic, assign) NSInteger lastUpdated;
@property (nonatomic, assign) NSInteger inAlarmSince;
@property (nonatomic, assign) NSInteger activeAlarms;
@property (nonatomic, assign) NSInteger instanceNumber;
@property (nonatomic, assign) NSInteger siteStatus;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, weak) NSString *smsStart;
@property (nonatomic, weak) NSString *smsStop;

@property (nonatomic, assign) BOOL hasGenerator;
@property (nonatomic, assign) BOOL hasMains;
@property (nonatomic, assign) BOOL usesVEBusSOC;
@property (nonatomic, assign) BOOL hasVEBus;
@property (nonatomic, assign) BOOL hasBattery;
@property (nonatomic, assign) BOOL hasIOExtender;
@property (nonatomic, assign) BOOL hasFueltank;
@property (nonatomic, assign) BOOL canEditSite;
@property (nonatomic, assign) BOOL hasMPPT;
@property (nonatomic, assign) BOOL hasPVInverter;
@property (nonatomic, assign) BOOL hasDcSystem;

@property (nonatomic, assign) NSArray *extenders;
@property (nonatomic, strong) AttributesInfo *siteAttributes;
@property (nonatomic, strong) NSMutableArray *siteSummaryWidgets;
@property (nonatomic, strong) NSMutableArray *widgetIndexArray;
@property (nonatomic, assign) BOOL isLoadingWidgets;

@property (nonatomic, strong) NSArray *imageURLS;

- (id)initWithDictionary:(NSDictionary *)siteDictionary;
-(void)parseFromDictionary:(NSDictionary *)siteDictionary;
-(void)setSummaryWidgetsforAttributes:(AttributesInfo *)attributes;

-(void)refreshSiteInfoObject:(void (^)(BOOL succes))completionSucces;

@end

@interface Sites : NSObject

+(NSArray *)getSites;

@end
