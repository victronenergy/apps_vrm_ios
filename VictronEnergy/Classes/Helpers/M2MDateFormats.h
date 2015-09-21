//
// Created by Jim van Zummeren on 20/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface M2MDateFormats : NSObject
@property(nonatomic) NSDateFormatter *timeFormatter;

- (NSString *)dateStringFromTimeStamp:(NSInteger)timeStamp;

+ (M2MDateFormats *)sharedInstance;

@end