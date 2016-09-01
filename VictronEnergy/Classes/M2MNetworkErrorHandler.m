//
//  M2MNetworkErrorHandler.m
//  VictronEnergy
//
//  Created by Lime on 3/5/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MNetworkErrorHandler.h"
#import "Data.h"

NSString *const kM2MErrorTitle = @"Error!";
NSString *const kM2MErrorMessage = @"There has been a connection issue";
NSString *const kM2MNoInternetMessage = @"The Internet connection appears to be offline";
NSString *const kM2MMessage = @"message";
NSString *const kM2MNameOfList = @"NetworkErrorsList";
NSString *const kM2MTypeOfList = @"plist";
NSString *const kM2MNameOfDictionary = @"Errors";
NSString *const kM2MOkButtonTitle = @"Ok";

@implementation M2MNetworkErrorHandler

+(UIAlertView *)checkToShowAlertViewForResponseCode:(NSInteger)statusCode
{
    if (statusCode == RETURN_CODE_OK) {
        return nil;
    }
    
    NSLog(@"Status code received: %d", statusCode);

    if ([Data sharedData].isAnAlertViewShowing) {
        return nil;
    } else {
        [Data sharedData].isAnAlertViewShowing = YES;
    }

    NSString *errorTitle = kM2MErrorTitle;
    NSString *errorMessage = @"";

    if (statusCode > 0) {

        NSString *errorsList = [[NSBundle mainBundle] pathForResource:kM2MNameOfList ofType:kM2MTypeOfList];
        NSDictionary *errorsDictionary = [[NSDictionary dictionaryWithContentsOfFile:errorsList] valueForKey:kM2MNameOfDictionary];
        NSDictionary *errorDictionary = [errorsDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)statusCode]];

        if (errorDictionary) {
            errorMessage = errorDictionary[kM2MMessage];
        } else {
            errorMessage = kM2MErrorMessage;
        }
    } else {
        errorMessage = kM2MNoInternetMessage;
    }

    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:self cancelButtonTitle:nil otherButtonTitles:kM2MOkButtonTitle, nil];
    [theAlert show];

    return theAlert;
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [Data sharedData].isAnAlertViewShowing = NO;
}

@end
