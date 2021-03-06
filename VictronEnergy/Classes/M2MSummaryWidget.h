//
//  M2MSummaryWidget.h
//  VictronEnergy
//
//  Created by Lime on 11/03/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M2MSummaryWidget : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *widgetLabel;


@property (nonatomic, assign) NSInteger isUsedAtIndex;

@end
