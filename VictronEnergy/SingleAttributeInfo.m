//
// Created by Jim van Zummeren on 16/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "SingleAttributeInfo.h"

@implementation SingleAttributeInfo

NSString *const kM2MAttributeKeyCode = @"code";
NSString *const kM2MAttributeKeyCustomLabel = @"customLabel";
NSString *const kM2MAttributeKeyDataType = @"dataType";
NSString *const kM2MAttributeKeyFormatValueOnly = @"formatValueOnly";
NSString *const kM2MAttributeKeyFormatWithUnit = @"formatWithUnit";
NSString *const kM2MAttributeKeyIdDataAttribute = @"idDataAttribute";
NSString *const kM2MAttributeKeyInstance = @"instance";
NSString *const kM2MAttributeKeyIsValid = @"isValid";
NSString *const kM2MAttributeKeyNameEnum = @"nameEnum";
NSString *const kM2MAttributeKeyTimestamp = @"timestamp";
NSString *const kM2MAttributeKeyValueEnum = @"valueEnum";
NSString *const kM2MAttributeKeyValueFloat = @"valueFloat";
NSString *const kM2MAttributeKeyValueString = @"valueString";

- (id) initWithDictionary:(NSDictionary *)attributesDictionary
{
    self = [super init];
    if (self != nil) {
        [self parseFromDictionaryNew:attributesDictionary];
    }

    return self;
}

-(void)parseFromDictionaryNew:(NSDictionary *)attributesDictionary
{
    self.attributeCode= attributesDictionary[kM2MAttributeKeyCode];
    self.attributeCustomLabel = attributesDictionary[kM2MAttributeKeyCustomLabel];
    self.attributeDataType = attributesDictionary[kM2MAttributeKeyDataType];
    self.attributeFormatValueOnly = attributesDictionary[kM2MAttributeKeyFormatValueOnly];
    self.attributeFormatWithUnit = attributesDictionary[kM2MAttributeKeyFormatWithUnit];
    self.attributeIdDataAttribute = attributesDictionary[kM2MAttributeKeyIdDataAttribute];
    self.attributeInstance = attributesDictionary[kM2MAttributeKeyInstance];
    self.attributeIsValid = attributesDictionary[kM2MAttributeKeyIsValid];
    self.attributeNameEnum = attributesDictionary[kM2MAttributeKeyNameEnum];
    self.attributeTimeStamp = attributesDictionary[kM2MAttributeKeyTimestamp];
    self.attributeValueEnum = [attributesDictionary[kM2MAttributeKeyValueEnum] integerValue];
    self.attributeValueFloat = [attributesDictionary[kM2MAttributeKeyValueFloat] stringValue];
    self.attributeValueString = attributesDictionary[kM2MAttributeKeyValueString];
}

-(float)getFloatValue
{
    // If the value is set return it as a float if not return 0
    if([self.attributeValueFloat length] != 0) {
        return [self.attributeValueFloat floatValue];
    }

    return 0;
}

@end