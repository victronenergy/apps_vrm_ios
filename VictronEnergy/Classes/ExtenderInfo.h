//
//  ExtenderInfo.h
//  Victron Energy
//
//  Created by Thijs on 3/15/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExtenderInfo : NSObject

@property (nonatomic, assign) NSInteger timeStamp;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) NSInteger dataAtributeID;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) float temperature;

- (id)initWithDictionary:(NSDictionary *)extenderDictionary;
-(void)parseFromDictionary:(NSDictionary *)extenderDictionary;
+(ExtenderInfo *)getExtenderForSettingsList:(NSDictionary *)settings thatMatchesTheExtenderInTheoutputList:(NSArray *)outputs;
@end

@interface Extender : NSObject

+(NSArray *)getExtenders;

@end

