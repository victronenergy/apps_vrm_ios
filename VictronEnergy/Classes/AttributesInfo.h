//
//  Attributes.h
//  VictronEnergy
//
//  Created by Lime on 12/9/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SingleAttributeInfo;


@interface AttributesInfo : NSObject

@property (strong, nonatomic) NSArray *attributes;

-(id)initWithArray:(NSArray *)attributesArray;

-(SingleAttributeInfo *)getAttributeByCode:(NSString *)attributeCode;
-(float)getValueForCode:(NSString *)attributeCode;
-(float)getValueForCodes:(NSArray *)attributeCodes;
-(NSString*)getFormattedValueForCode:(NSString *)attributeCode formattedAs:(Format)format hideIfUnavailable:(BOOL)shouldHide;
-(NSString*)getFormattedValueForCodes:(NSArray *)attributeCodes formattedAs:(Format)format hideIfUnavailable:(BOOL)shouldHide;
-(BOOL)isAttributeSet:(NSString *)attributeCode;

@end