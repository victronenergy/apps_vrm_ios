//
// Created by Jim van Zummeren on 16/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
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