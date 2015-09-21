//
//  Tools.h
//  Transavia
//
//  Created by Stephanie on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/xattr.h>
#import "AppDelegate.h"

@interface Tools : NSObject

+(BOOL)validateEmail:(NSString *)candidate;

+(NSString *)convertToLastUpdateDate:(NSDate *)date;
+(NSString *)validatedString:(NSString *)inputStr;
+(NSInteger)validatedInteger:(NSString *)inputStr;
+(NSMutableDictionary *)setPostDict;
+(void)style:(LabelStyle)labelStyle forLabel:(UILabel *)theLabel;
+(void)style:(ButtonStyle)buttonStyle forButton:(UIButton *)theButton;
+(void)style:(TextfieldStyle)textfieldStyle forTextfield:(UITextField *)theTextfield;
+(void)style:(LabelStyle)labelStyle forLabel:(UILabel *)theLabel withFormat:(Format)format;

+(UIImage *)arrowImageForPositiveRight:(float)value;
+(UIImage *)arrowImageForPositiveLeft:(float)value;
+(UIImage *)arrowImageForPositiveUp:(float)value;
+(UIImage *)arrowImageForPositiveDown:(float)value;
+(UIImage *)arrowImageForAlwaysRightOrPositive:(float)value;
+(UIImage *)arrowImageForAlwaysLeftOrPositive:(float)value;

@end
