//
//  M2MNetworkErrorHandler.h
//  VictronEnergy
//
//  Created by Lime on 3/5/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M2MNetworkErrorHandler : NSObject <UIAlertViewDelegate>

+(UIAlertView *)checkToShowAlertViewForResponseCode:(NSInteger)statusCode;

@end
