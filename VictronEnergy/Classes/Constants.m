//
//  Constants.m
//  VictronEnergy
//
//  Created by Mandarin on 23/01/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "Constants.h"

@implementation Constants

//New webservice keys
NSInteger const kM2MWebServiceInstanceNumber = 0;
NSString *const kM2MWebServiceVersionNumber = @"200.i";
NSString *const kM2MWebServiceVerificationTokenValue = @"1";
NSString *const kM2MWebServiceVersion = @"version";
NSString *const kM2MWebServiceInstance = @"instance";
NSString *const kM2MWebServiceUsername = @"username";
NSString *const kM2MWebServicePassword = @"password";
NSString *const kM2MWebServiceVerificationToken = @"verification_token";
NSString *const kM2MWebServiceSessionId = @"sessionid";
NSString *const kM2MWebServiceSiteId = @"siteid";
NSString *const kM2MWebServiceAttributes = @"attributes";
NSString *const kM2MWebServiceAttributesCodes = @"codes";
NSString *const kM2MWebServiceAttributeID = @"attribute_id";
NSString *const kM2MWebServiceLabel = @"label";
NSString *const kM2MWebServiceImagesName = @"image_name";
NSString *const kM2MWebServiceImage = @"image";

//New webservice response keys
NSString *const kM2MResponseStatus = @"status";
NSString *const kM2MResponseCode = @"code";
NSString *const kM2MResponseData = @"data";
NSString *const kM2MResponseUser = @"user";
NSString *const kM2MResponseSessionId = @"sessionid";
NSString *const kM2MResponseSites = @"sites";
NSString *const kM2MResponseAttributes = @"attributes";
NSString *const kM2MResponseIOExtenders = @"io_extender";
NSString *const kM2MResponseSiteInstanceNumber = @"mainBatteryMonitorInstance";
NSString *const kM2MResponseSiteImages = @"images";

//HistoricData attribute keys
NSString *const kHistoricDataDeepestDischarge = @"H1";
NSString *const kHistoricDataLastDischarge = @"H2";
NSString *const kHistoricDataAverageDischarge = @"H3";
NSString *const kHistoricDataChargeCycles = @"H4";
NSString *const kHistoricDataFullDischarge = @"H5";
NSString *const kHistoricDataTotalAhDrawn = @"H6";
NSString *const kHistoricDataMinimumVoltage = @"H7";
NSString *const kHistoricDataMaximumVoltage = @"H8";
NSString *const kHistoricDataTimeSinceLastFullCharge = @"H9";
NSString *const kHistoricDataAutomaticSyncs = @"H10";
NSString *const kHistoricDataLowVoltageAlarms = @"H11";
NSString *const kHistoricDataHighVoltageAlarms = @"H12";
NSString *const kHistoricDataLowStarterVoltageAlarms = @"H13";
NSString *const kHistoricDataHighStarterVoltageAlarms = @"H14";
NSString *const kHistoricDataMinimumStarterVoltage = @"H15";
NSString *const kHistoricDataMaximumStarterVoltage = @"H16";

NSInteger const kTimeSinceTwoWeeksInSeconds = 1209600;

//Return Code
NSInteger const kReturn_Code_OK = 200;

// Data Attribute Code Keys
NSString *const kAttributeVEBusState = @"S";
NSString *const kAttributePV_AC_CoupledOutputL1 = @"P";
NSString *const kAttributePV_AC_CoupledOutputL2 = @"P2";
NSString *const kAttributePV_AC_CoupledOutputL3 = @"P3";
NSString *const kAttributePV_AC_CoupledInputL1 = @"Pi";
NSString *const kAttributePV_AC_CoupledInputL2 = @"Pi2";
NSString *const kAttributePV_AC_CoupledInputL3 = @"Pi3";
NSString *const kAttributePV_DC_Coupled = @"Pdc";
NSString *const kAttributeAC_ConsumptionL1 = @"a1";
NSString *const kAttributeAC_ConsumptionL2 = @"a2";
NSString *const kAttributeAC_ConsumptionL3 = @"a3";
NSString *const kAttributeGridL1 = @"g1";
NSString *const kAttributeGridL2 = @"g2";
NSString *const kAttributeGridL3 = @"g3";
NSString *const kAttributeGensetL1 = @"gs1";
NSString *const kAttributeGensetL2 = @"gs2";
NSString *const kAttributeGensetL3 = @"gs3";
NSString *const kAttributeDCSystem = @"dc";
NSString *const kAttributeBatteryVoltage = @"bv";
NSString *const kAttributeBatteryStateOfCharge = @"bs";
NSString *const kAttributeBatteryConsumedAmphours = @"ba";
NSString *const kAttributeBatteryTimeToGo = @"bt";
NSString *const kAttributeBatteryCurrent = @"bc";
NSString *const kAttributeVEBusChargeCurrent = @"vc";
NSString *const kAttributeBatteryState = @"bst";

// about page
NSString *const kFacebookURL = @"fb://profile/298430206871322";
NSString *const kFacebookURLShort = @"fb://";
NSString *const kFacebookURLHTTPS = @"https://www.facebook.com/VictronEnergy.BV";
NSString *const kTwitterURL = @"twitter://user?screen_name=Victron_Energy";
NSString *const kTwitterURLShort = @"twitter://";
NSString *const kTwitterURLHTTPS = @"https://twitter.com/Victron_Energy";
NSString *const kLinkedInHTTPS = @"http://www.linkedin.com/company/victron-energy";

float const kHeaderInsetImageTop = 27.0f;
float const kHeaderInsetImageLeft= 0.0f;
float const kHeaderInsetImageBottom = 0.0f;
float const kHeaderInsetImageRight = 14.0f;

float const kPageControlOffSetX = 298.0f;

NSInteger const kNumberOfWidgetsPerPage = 3;


@end
