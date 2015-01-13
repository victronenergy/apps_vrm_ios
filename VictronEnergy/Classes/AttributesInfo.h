//
//  Attributes.h
//  VictronEnergy
//
//  Created by Victron Energy on 12/9/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleAttributeInfo : NSObject

@property (nonatomic, strong) NSString *attributeCode;
@property (nonatomic, strong) NSString *attributeCustomLabel;
@property (nonatomic, strong) NSString *attributeDataType;
@property (nonatomic, strong) NSString *attributeFormatValueOnly;
@property (nonatomic, strong) NSString *attributeFormatWithUnit;
@property (nonatomic, strong) NSString *attributeIdDataAttribute;
@property (nonatomic, strong) NSString *attributeInstance;
@property (nonatomic, strong) NSString *attributeIsValid;
@property (nonatomic, strong) NSString *attributeNameEnum;
@property (nonatomic, strong) NSString *attributeTimeStamp;
@property (nonatomic, assign) NSInteger attributeValueEnum;
@property (nonatomic, strong) NSString *attributeValueFloat;
@property (nonatomic, strong) NSString *attributeValueString;



- (id)initWithDictionary:(NSDictionary *)attributeDictionary;
-(float)getFloatValue;

@end

@interface AttributesInfo : NSObject

@property (strong, nonatomic) NSArray *attributes;

-(id)initWithArray:(NSArray *)attributesArray;

-(SingleAttributeInfo *)getAttributeByCode:(NSString *)attributeCode;
-(float)getValueForCode:(NSString *)attributeCode;
-(float)getValueForCodes:(NSArray *)attributeCodes;
-(NSString*)getFormattedValueForCode:(NSString *)attributeCode formattedAs:(Format)format hideIfUnavailable:(BOOL)shouldHide;
-(NSString*)getFormattedValueForCodes:(NSArray *)attributeCodes formattedAs:(Format)format hideIfUnavailable:(BOOL)shouldHide;
-(BOOL)isAttributeSet:(NSString *)attributeCode;
-(NSArray *)loadAttributesWithCodes:(NSArray *)attributeCodes withSideID:(NSNumber *)siteID;

@end

@interface Attributes : NSObject

+(NSArray *)loadAttributesWithCodes:(NSArray *)attributeCodes withSideID:(NSNumber *)siteID;
+(void)loadAttributesWithArray:(NSArray *)attributesArray withSideID:(NSNumber *)siteID;
+(void)loadSiteAttributesWithSiteID:(NSNumber *)siteID result:(void(^)(AttributesInfo *))completionBlock failure:(void(^)(NSString *))failure;

@end
