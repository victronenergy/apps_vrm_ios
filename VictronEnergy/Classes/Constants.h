//
//  Constants.h
//  VictronEnergy
//
//  Created by Mandarin on 23/01/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

@end

#define IOS_OLDER_THAN_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] < 6.0 )
#define IOS_NEWER_OR_EQUAL_TO_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 6.0 )

#define UIColorFromHEXValue(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

//Screen dimensions
#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width

//New Colors
#define COLOR_WHITE                                    UIColorFromHEXValue(0xFFFFFF)
#define COLOR_BACKGROUND                               UIColorFromHEXValue(0xe5e4e0)
#define COLOR_LINE                                     UIColorFromHEXValue(0xcac9c8)
#define COLOR_LIGHT_GREY                               UIColorFromHEXValue(0xEFEEEA)
#define COLOR_GREY                                     UIColorFromHEXValue(0x959490)
#define COLOR_DARK_GREY                                UIColorFromHEXValue(0x63625E)
#define COLOR_BLACK                                    UIColorFromHEXValue(0x272622)
#define COLOR_BLUE                                     UIColorFromHEXValue(0x5AA5E1)
#define COLOR_DARK_BLUE                                UIColorFromHEXValue(0x4790D0)
#define COLOR_ORANGE                                   UIColorFromHEXValue(0xF7AB3E)
#define COLOR_DARK_ORANGE                              UIColorFromHEXValue(0xF0962E)
#define COLOR_GREEN                                    UIColorFromHEXValue(0xA0D87B)
#define COLOR_RED                                      UIColorFromHEXValue(0xFA716F)
#define COLOR_NAV_BAR                                  UIColorFromHEXValue(0xFFFFFF)
#define COLOR_BACKGROUND_TEXTFIELD                     UIColorFromHEXValue(0xf8f7f7)
#define COLOR_SUB_HEADER                               UIColorFromHEXValue(0xf8f7f7)
#define COLOR_GREY_SELECTION                           UIColorFromHEXValue(0xf7f7f7)

#define COLOR_BULLETS_SELECTION                        UIColorFromHEXValue(0x4790D0)
#define COLOR_BULLETS_NORMAL                           UIColorFromHEXValue(0xd1d0ca)


#define BACK_BUTTON_TEXT_FONT                          [UIFont fontWithName:@"MuseoSans-500" size:14]
#define BACK_BUTTON_TEXT_COLOR                         COLOR_DARK_GREY

#define TEXT_FIELDS_BORDER_STYLE                       UITextBorderStyleNone
#define TEXT_FIELDS_SIZE_WIDTH                         40
#define TEXT_FIELDS_SIZE_HEIGHT                        40
#define TEXT_FIELDS_TEXT_FONT                          [UIFont fontWithName:@"MuseoSans-300" size:16]
#define TEXT_FIELDS_TEXT_COLOR                         COLOR_DARK_GREY
#define TEXT_FIELDS_LEFT_INSET                         UIEdgeInsetsMake(0, 10, 0, 40)

#define BUTTON_LINK_TEXT_FONT                          [UIFont fontWithName:@"MuseoSans-300" size:14]
#define BUTTON_LINK_TEXT_TEXT_COLOR                    COLOR_DARK_GREY
#define BUTTON_LINK_TEXT_TEXT_COLOR_PRESSED            COLOR_LIGHT_GREY

#define BUTTON_TEXT_TEXT_FONT                          [UIFont fontWithName:@"MuseoSans-300" size:18]
#define BUTTON_TEXT_TEXT_COLOR                         COLOR_WHITE
#define BUTTON_TEXT_TEXT_COLOR_PRESSED                 COLOR_DARK_GREY
#define BUTTON_TEXT_TEXT_COLOR_DISABLED                COLOR_LIGHT_GREY

#define SEGMENTEDCONTROL_FONT                          [UIFont fontWithName:@"MuseoSans-300" size:16]
#define SEGMENTEDCONTROL_FONT_COLOR                    COLOR_GREY

#define LABEL_SECTION_HEADERS_TEXT_FONT                [UIFont fontWithName:@"MuseoSans-500" size:18]
#define LABEL_SECTION_HEADERS_TEXT_COLOR               COLOR_WHITE

#define LABEL_LOGIN_TEXT_FONT                          [UIFont fontWithName:@"MuseoSans-500" size:20]
#define LABEL_LOGIN_TEXT_COLOR                         COLOR_WHITE
#define LABEL_LOGIN_TEXT_COLOR_IPAD                    COLOR_BLACK

#define LABEL_HEADERS_TEXT_FONT                        [UIFont fontWithName:@"MuseoSans-500" size:18]
#define LABEL_HEADERS_TEXT_COLOR                       COLOR_BLACK

#define LABEL_EXPLANATORY_TEXT_FONT                    [UIFont fontWithName:@"MuseoSans-300" size:14]
#define LABEL_EXPLANATORY_TEXT_COLOR                   COLOR_DARK_GREY

#define LABEL_OVERVIEW_TITLE_TEXT_FONT                 [UIFont fontWithName:@"MuseoSans-300" size:14]
#define LABEL_OVERVIEW_TITLE_TEXT_COLOR                COLOR_DARK_GREY

#define LABEL_OVERVIEW_VALUE_TEXT_FONT                 [UIFont fontWithName:@"MuseoSans-300" size:14]
#define LABEL_OVERVIEW_VALUE_TEXT_COLOR                COLOR_BLACK

#define LABEL_REGULAR_TEXT_FONT                        [UIFont fontWithName:@"MuseoSans-300" size:13]
#define LABEL_REGULAR_TEXT_COLOR                       COLOR_GREY

#define LABEL_ABOUT_TEXT_HEADER_FONT                   [UIFont fontWithName:@"MuseoSans-500" size:16]
#define LABEL_ABOUT_TEXT_HEADER_COLOR                  COLOR_DARK_GREY

#define LABEL_ABOUT_TEXT_FONT                          [UIFont fontWithName:@"MuseoSans-300" size:13]
#define LABEL_ABOUT_TEXT_COLOR                         COLOR_GREY

#define LABEL_SITE_SUMMERY_TEXT_FONT                   [UIFont fontWithName:@"MuseoSans-300" size:14]
#define LABEL_SITE_SUMMERY_TEXT_COLOR                  COLOR_GREY

#define LABEL_SITE_SUMMERY_NAME_TEXT_FONT              [UIFont fontWithName:@"MuseoSans-300" size:9]
#define LABEL_SITE_SUMMERY_NAME_TEXT_COLOR             COLOR_DARK_GREY

#define LABEL_UPDATE_TEXT_FONT                          [UIFont fontWithName:@"MuseoSans-300" size:13]
#define LABEL_UPDATE_TEXT_COLOR                         COLOR_GREY

#define INPUT_TEXT_FONT                                [UIFont fontWithName:@"MuseoSans-500" size:15]
#define INPUT_TEXT_COLOR                               COLOR_WHITE

#define LABEL_BATTERY_EXPLANATION_TEXT_FONT_BIG        [UIFont fontWithName:@"MuseoSans-500" size:15]
#define LABEL_BATTERY_EXPLANATION_TEXT_FONT_SMALL      [UIFont fontWithName:@"MuseoSans-500" size:13]
#define LABEL_BATTERY_EXPLANATION_TEXT_COLOR           COLOR_DARK_GREY

#define LABEL_HISTORIC_DATA_TEXT_FONT                  [UIFont fontWithName:@"MuseoSans-300" size:14]
#define LABEL_HISTORIC_DATA_TEXT_COLOR                 COLOR_BLACK

#define LABEL_EXTENDER_TITLE_TEXT_FONT                 [UIFont fontWithName:@"MuseoSans-500" size:18]
#define LABEL_EXTENDER_TITLE_TEXT_COLOR                COLOR_DARK_GREY

#define LABEL_EXTENDER_TYPE_TEXT_FONT                  [UIFont fontWithName:@"MuseoSans-300" size:16]
#define LABEL_EXTENDER_TYPE_TEXT_COLOR                 COLOR_BLACK

#define LABEL_EXTENDER_STATE_TEXT_FONT                 [UIFont fontWithName:@"MuseoSans-300" size:16]
#define LABEL_EXTENDER_STATE_TEMP_TEXT_COLOR           COLOR_BLUE
#define LABEL_EXTENDER_STATE_IN_TEXT_COLOR             COLOR_BLUE

#define LOGIN_DEMO                                      @"Demo"
#define LOGIN_DEMO_EMAIL                                @"demo@victronenergy.com"
#define LOGIN_DEMO_PASSWORD                             @"vrmdemo"

#define WEBVIEW_URL_REQUEST                            [NSURL URLWithString:@"https://acceptancevrm.victronenergy.com/"]
#define WEBVIEW_URL_REQUEST_SITE                       @"https://acceptancevrm.victronenergy.com/user/login?return=%2Fsite%2F"
#define WEBVIEW_URL_LOGIN_REQUEST                      @"https://acceptancevrmapi.victronenergy.com/v2/auth/login"

#define RETURN_CODE_OK                                 200
#define RETURN_CODE_SESSION_EXPIRED                    401
#define RETURN_CODE_NOT_ALLOWED                        402


//#ifdef DEBUG
//    // DEBUG VERSION
//    #define URL_SERVER                                 @"http://juice.m2mobi.com"
////    #define URL_SERVER                                 @"http://victron.m2mobi.com/~dinos/juice"
////    #define URL_SERVER                                 @"http://victron.m2mobi.com/~damien/juice"
//#else
    // FINAL VERSION HTTPS
    #define URL_SERVER                                 @"https://juice.victronenergy.com"
//#endif


#define URL_SERVER_LOGIN                               (URL_SERVER @"/user/login")
#define URL_SERVER_LOGOUT                              (URL_SERVER @"/user/logout")
#define URL_SERVER_SITES_GET                           (URL_SERVER @"/sites/get")
#define URL_SERVER_SITES_GET_SITE                      (URL_SERVER @"/sites/get_site")
#define URL_SERVER_SITES_BATTERY_STATUS                (URL_SERVER @"/sites/energy_status")
#define URL_SERVER_SITES_ATTRIBUTES_BY_CODE            (URL_SERVER @"/sites/attributes_by_code")
#define URL_SERVER_ATTRIBUTE_OBJECT                    (URL_SERVER @"/sites/attributes")
#define URL_SERVER_GET_SITE_ATTRIBUTES                 (URL_SERVER @"/sites/get_site_attributes")
#define URL_SERVER_SITES_IO_EXTENDERS                  (URL_SERVER @"/sites/io_extenders")
#define URL_SERVER_SITES_SET_LABEL                     (URL_SERVER @"/sites/set_label")
#define URL_SERVER_SITES_SET_GENERATOR                 (URL_SERVER @"/sites/set_generator")
#define URL_SERVER_HISTORIC_DATA                       (URL_SERVER @"/sites/historic_data")

#define URL_SERVER_IMAGE_UPLOAD                        (URL_SERVER @"/image/upload")
#define URL_SERVER_IMAGE_DELETE                        (URL_SERVER @"/image/delete")
#define URL_SERVER_FETCH_IMAGE                         (URL_SERVER @"/statics/uploads")

#define API_VERSION                                    @"200"

//Site Object Keys
#define KEY_SITES_DICT                                 @"sites"
#define KEY_SITE_ID                                    @"idSite"
#define KEY_SITE_NAME                                  @"name"
#define KEY_SITE_LAST_UPDATE                           @"lastTimestamp"
#define KEY_SITE_HAS_GENERATOR                         @"hasGenerator"
#define KEY_SITE_HAS_MAINS                             @"hm"
#define KEY_SITE_USES_VEBUS_SOC                        @"uv"
#define KEY_SITE_PHONE                                 @"phonenumber"
#define KEY_SITE_ACTIVE_ALARMS                         @"activeAlarms"
#define KEY_SITE_HAS_VEBUS                             @"hv"
#define KEY_SITE_HAS_BATTERY                           @"hb"
#define KEY_SITE_HAS_IO_EXTENDER                       @"hasIOExtender"
#define KEY_SITE_HAS_FUELTANK                          @"hf"
#define KEY_SITE_VEBUS_STATE                           @"vs"
#define KEY_SITE_CAN_EDIT                              @"canEdit"
#define KEY_SITE_HAS_MPPT                              @"hs"
#define KEY_SITE_HAS_PVINVERTER                        @"hpvi"
#define KEY_SITE_HAS_DC_SYSTEM                         @"hasDCSystem"

#define KEY_SITE_ALARM_STARTED                      @"alarmStarted"

// Attribute webservice keys
#define KEY_ATTRIBUTES_DICT                            @"attributes"
#define KEY_ATTRIBUTES                                 @"at"
#define KEY_ATTRIBUTES_TIMESTAMP                       @"ts"
#define KEY_ATTRIBUTES_ID                              @"ida"
#define KEY_ATTRIBUTES_VALUE_FORMAT                    @"vf"
#define KEY_ATTRIBUTES_VALUE_TYPE                      @"vt"
#define KEY_ATTRIBUTES_VALUE                           @"va"

//Historc Data Keys
#define KEY_HISTORIC_DATA_DICT                         @"historicData"
#define KEY_HISTORIC_DATA_NOTIFICATION                 @"historicData"
#define KEY_DEEPEST_DISCHARGE                          @"dd"
#define KEY_LAST_DISCHARGE                             @"ld"
#define KEY_AVERAGE_DISCHARGE                          @"ad"
#define KEY_CHARGE_CYCLES                              @"cc"
#define KEY_FULL_DISCHARGES                            @"fd"
#define KEY_TOTAL_AH_DRAWN                             @"tad"
#define KEY_MINIMUM_VOLTAGE                            @"minv"
#define KEY_MAXIMUM_VOLTAGE                            @"maxv"
#define KEY_TIME_SINCE_LAST_FULL_CHARGE                @"tslc"
#define KEY_AUTOMATIC_SYNCS                            @"as"
#define KEY_LOW_VOLTAGE_ALARMS                         @"lva"
#define KEY_HIGH_VOLTAGE_ALARMS                        @"hva"
#define KEY_LOW_STARTER_VOLTAGE_ALARMS                 @"lsva"
#define KEY_HIGH_STARTER_VOLTAGE_ALARMS                @"hsva"
#define KEY_MINIMUM_STARTER_VOLTAGE                    @"minsv"
#define KEY_MAXIMUM_STARTER_VOLTAGE                    @"maxsv"

//IO-Extender Object Keys
#define KEY_EXTENDERS_DICT                             @"extenders"
#define KEY_EXTENDER_TIMESTAMP                         @"timestamp"
#define KEY_EXTENDER_CODE                              @"code"
#define KEY_EXTENDER_DATA_ATTRIBUTE                    @"idDataAttribute"
#define KEY_EXTENDER_LABEL                             @"label"
#define KEY_EXTENDER_STATUS                            @"status"
#define KEY_EXTENDER_TEMPERATURE                       @"temperature"

//Response Keys
#define KEY_RESPONSE_OBJECT                            @"r"
#define KEY_EXTENDER_OBJECT                            @"iox"
#define KEY_BATTERY_OBJECT                             @"en"
#define KEY_SITE_OBJECTS                               @"sts"
#define KEY_SESSION_ID                                 @"si"

//New webservice keys
extern NSString *const kM2M;
extern NSInteger const kM2MWebServiceInstanceNumber;
extern NSString *const kM2MWebServiceVersionNumber;
extern NSString *const kM2MWebServiceVerificationTokenValue;
extern NSString *const kM2MWebServiceVersion;
extern NSString *const kM2MWebServiceInstance;
extern NSString *const kM2MWebServiceUsername;
extern NSString *const kM2MWebServicePassword;
extern NSString *const kM2MWebServiceVerificationToken;
extern NSString *const kM2MWebServiceSessionId;
extern NSString *const kM2MWebServiceSiteId;
extern NSString *const kM2MWebServiceAttributes;
extern NSString *const kM2MWebServiceHistoricDataAttributes;
extern NSString *const kM2MWebServiceAttributesCodes;
extern NSString *const kM2MWebServiceAttributeID;
extern NSString *const kM2MWebServiceLabel;
extern NSString *const kM2MWebServiceImagesName;
extern NSString *const kM2MWebServiceImage;

//New webservice response keys
extern NSString *const kM2MResponseStatus;
extern NSString *const kM2MResponseCode;
extern NSString *const kM2MResponseData;
extern NSString *const kM2MResponseUser;
extern NSString *const kM2MResponseSessionId;
extern NSString *const kM2MResponseSites;
extern NSString *const kM2MResponseAttributes;
extern NSString *const kM2MResponseIOExtenders;
extern NSString *const kM2MResponseSiteInstanceNumber;
extern NSString *const kM2MResponseSiteImages;

//HistoricData attribute keys
extern NSString *const kHistoricDataDeepestDischarge;
extern NSString *const kHistoricDataLastDischarge;
extern NSString *const kHistoricDataAverageDischarge;
extern NSString *const kHistoricDataChargeCycles;
extern NSString *const kHistoricDataFullDischarge;
extern NSString *const kHistoricDataTotalAhDrawn;
extern NSString *const kHistoricDataMinimumVoltage;
extern NSString *const kHistoricDataMaximumVoltage;
extern NSString *const kHistoricDataTimeSinceLastFullCharge;
extern NSString *const kHistoricDataAutomaticSyncs;
extern NSString *const kHistoricDataLowVoltageAlarms;
extern NSString *const kHistoricDataHighVoltageAlarms;
extern NSString *const kHistoricDataLowStarterVoltageAlarms;
extern NSString *const kHistoricDataHighStarterVoltageAlarms;
extern NSString *const kHistoricDataMinimumStarterVoltage;
extern NSString *const kHistoricDataMaximumStarterVoltage;

extern NSInteger const kTimeSinceTwoWeeksInSeconds;

//Return Code
extern NSInteger const kReturn_Code_OK;

// Data Attribute Code Keys
extern NSString *const kAttributeVEBusState;
extern NSString *const kAttributePV_AC_CoupledOutputL1;
extern NSString *const kAttributePV_AC_CoupledOutputL2;
extern NSString *const kAttributePV_AC_CoupledOutputL3;
extern NSString *const kAttributePV_AC_CoupledInputL1;
extern NSString *const kAttributePV_AC_CoupledInputL2;
extern NSString *const kAttributePV_AC_CoupledInputL3;
extern NSString *const kAttributePV_DC_Coupled;
extern NSString *const kAttributeAC_ConsumptionL1;
extern NSString *const kAttributeAC_ConsumptionL2;
extern NSString *const kAttributeAC_ConsumptionL3;
extern NSString *const kAttributeGridL1;
extern NSString *const kAttributeGridL2;
extern NSString *const kAttributeGridL3;
extern NSString *const kAttributeGensetL1;
extern NSString *const kAttributeGensetL2;
extern NSString *const kAttributeGensetL3;
extern NSString *const kAttributeDCSystem;
extern NSString *const kAttributeBatteryVoltage;
extern NSString *const kAttributeBatteryStateOfCharge;
extern NSString *const kAttributeBatteryConsumedAmphours;
extern NSString *const kAttributeBatteryTimeToGo;
extern NSString *const kAttributeBatteryCurrent;
extern NSString *const kAttributeVEBusChargeCurrent;
extern NSString *const kAttributeBatteryState;

// about page
extern NSString *const kFacebookURL;
extern NSString *const kFacebookURLShort;
extern NSString *const kFacebookURLHTTPS;
extern NSString *const kTwitterURL;
extern NSString *const kTwitterURLShort;
extern NSString *const kTwitterURLHTTPS;
extern NSString *const kLinkedIn;
extern NSString *const kLinkedInShort;
extern NSString *const kLinkedInHTTPS;

extern float const kHeaderInsetImageTop;
extern float const kHeaderInsetImageLeft;
extern float const kHeaderInsetImageBottom;
extern float const kHeaderInsetImageRight;
extern float const kPageControlOffSetX;

extern NSInteger const kNumberOfWidgetsPerPage;


//Webservice Keys
#define KEY_SESSION_ID                                 @"si"
#define KEY_DEVICE_ID                                  @"did"
#define KEY_API_VERSION                                @"version"
//#define KEY_SITE_ID                                    @"stid"
#define KEY_DATA_ATTRIBUTE                             @"ida"
#define KEY_LABEL                                      @"lb"
#define KEY_EMAIL                                      @"username"
#define KEY_PASSWORD                                   @"password"
#define KEY_HAS_GENERATOR                              @"hg"
#define KEY_DEVICE_TYPE                                @"dt"
#define KEY_DATA_ATTRIBUTE_IDS                         @"ids"

//Extender code
#define EXTENDER_INPUT                                 @"IN"
#define EXTENDER_INPUT_1                               @"IN1"
#define EXTENDER_INPUT_2                               @"IN2"
#define EXTENDER_INPUT_3                               @"IN3"
#define EXTENDER_OUTPUT                                @"OU"
#define EXTENDER_OUTPUT_1                              @"OUT1"
#define EXTENDER_OUTPUT_2                              @"OUT2"
#define EXTENDER_TEMPERATURE_1                         @"T1"
#define DOTTED_LINE                                    @"---"
#define DOTTED_LINE_TIME                               @"--"

#define CELL_TAG_1                                     1
#define CELL_TAG_2                                     2

#define CELL_HEIGHT_SMAll                              136
#define CELL_HEIGHT_BIG                                356

#define ALARMS_BUTTON_PRESSED                          0
#define SITE_BUTTON_PRESSED                            1

#define GENERATOR_BUTTON_NOT_SET                       @"- generator"
#define GENERATOR_BUTTON_START                         @"Start generator"
#define GENERATOR_BUTTON_STOP                          @"Stop generator"

#define KEY_SELECTED_SITE_ID                           @"selectedSiteID"
#define KEY_SELECTED_OUTPUT                            @"selectedOutput"
#define KEY_OUTPUT_INDEXPATH                           @"outputIndexpath"
#define KEY_GENERATOR_STATE                            @"generatorState"
#define KEY_SITE_SETTINGSLIST                          @"siteSettingsList"

#define KEY_CHAIN_IDENTIFIER                           @"AppLogin"
#define SEARCH_BAR_EMPTY                               @""

#define GA_EVENT_CATEGORY_ACTION                       @"ui_action"
#define GA_EVENT_CATEGORY_GESTURE                      @"gesture_action"
#define GA_EVENT_CATEGORY_WEBSERVICE                   @"webservice"

#define GA_WITH_ACTION_BUTTON_PRESS                    @"button_press"
#define GA_WITH_ACTION_LIST_PRESS                      @"list_press"
#define GA_WITH_ACTION_PULL                            @"pull"
#define GA_WITH_ACTION_SWIPE                           @"swipe"

#define GA_WITH_NAME_LOGIN                             @"login"

#define NOTIFICATION_SITE_LIST                         @"sitelist"

#define VEBUSSTATE_OFF 0
#define VEBUSSTATE_LOW_POWER 1
#define VEBUSSTATE_INVERTING 9

#define OVERVIEW_BMV  0
#define OVERVIEW_MULTI 1
#define OVERVIEW_BMV_MULTI 2
#define OVERVIEW_MPPT 3

typedef enum {
    LabelStyleLoginTitle,
    LabelStyleLoginTitleiPad,
    LabelStyleSectionHeader,
	LabelStyleSiteTitle,
	LabelStyleSiteValue,
    LabelStyleSiteValueName,
    LabelStyleLastUpdate,
    LabelStyleOverviewTitle,
    LabelStyleOverviewValue,
    LabelStyleExtenderTitle,
    LabelStyleExtenderType,
    LabelStyleExtenderStateTemp,
    LabelStyleExtenderStateIn,
    LabelStyleLookInside,
    LabelStyleHistoricDataTitle,
    LabelStyleHistoricDataValue
} LabelStyle;


typedef enum {
	ButtonStyleNormal,
    ButtonStyleForgotPassword
} ButtonStyle;

typedef enum {
	TextfieldStyleNormal,
    TextfieldSettings
} TextfieldStyle;

typedef enum {
    BMV,
    BMV_MULTI,
    BMV_MULTI_MPPT,
    BMV_MULTI_PVINVERTER,
    MULTI,
    BMV_MPPT
} Scenario;

typedef enum {
    WATTS,
    VOLT,
    TIME,
    AMPS,
    AMPHOUR,
    PERCENTAGE,
    NONE
} Format;

typedef enum {
    ALARMS,
    OK,
    OLD
} SiteStatus;
