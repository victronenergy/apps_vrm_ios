//
//  Tools.m
//  Transavia
//
//  Created by Stephanie on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tools.h"
#import "Constants.h"
#import "KeychainItemWrapper.h"
#import "AttributesInfo.h"

@implementation Tools

#pragma mark - Field validators

+(BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}

+(BOOL)validateName:(NSString *)candidate
{
    NSString *nameRegex = @"[a-zA-Z\\s-']{2,32}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];

    return [nameTest evaluateWithObject:candidate];
}

+ (NSString *)stringDateFromCurrentTime:(NSTimeInterval)unixDateToConvert
{
    NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:unixDateToConvert];

    NSTimeInterval intervalInMinutes = round([tempDate timeIntervalSinceNow] / 60.0f) *-1;
	if (intervalInMinutes <= 1) {
        return intervalInMinutes <= 0 ? NSLocalizedString(@"less than a minute ago", @"") : NSLocalizedString(@"1 minute ago", @"") ;
	} else if (intervalInMinutes >= 2 && intervalInMinutes <= 44) {
		return [NSString stringWithFormat:NSLocalizedString(@"%.0f minutes ago", @""), intervalInMinutes];
	} else if (intervalInMinutes >= 45 && intervalInMinutes <= 89) {
		return NSLocalizedString(@"about 1 hour ago",@"");
	} else if (intervalInMinutes >= 90 && intervalInMinutes <= 1439) {
		return [NSString stringWithFormat:NSLocalizedString(@"about %.0f hours ago", @""), round(intervalInMinutes / 60.0f)];
	} else if (intervalInMinutes >= 1440 && intervalInMinutes <= 2879) {
		return NSLocalizedString(@"1 day ago",@"");
	} else if (intervalInMinutes >= 2880 && intervalInMinutes <= 43199) {
		return [NSString stringWithFormat:NSLocalizedString(@"%.0f days ago", @""), round(intervalInMinutes / 1440.0f)];
	} else if (intervalInMinutes >= 43200 && intervalInMinutes <= 86399) {
		return NSLocalizedString(@"about 1 month ago",@"");
	} else if (intervalInMinutes >= 86400 && intervalInMinutes <= 525599) {
		return [NSString stringWithFormat:NSLocalizedString(@"%.0f months ago", @""), round(intervalInMinutes / 43200.0f)];
	} else if (intervalInMinutes >= 525600 && intervalInMinutes <= 1051199) {
		return NSLocalizedString(@"about 1 year ago",@"");
	} else {
		return [NSString stringWithFormat:NSLocalizedString(@"over %.0f years ago", @""), round(intervalInMinutes / 525600.0f)];
	}
	return nil;
}

+(NSString *)returnDateFromUnixTimeStamp:(NSNumber *)timestamp
{
    NSDate *returnDate = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    return [self convertToLastUpdateDate:returnDate];
}

+(NSString *)convertToLastUpdateDate:(NSDate *)date
{
   NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setDateFormat:@"dd-MM-YYYY HH:mm"];

   NSString *dateString = [df stringFromDate:date];
    [df release];

  return [dateString capitalizedString];

}
+(NSString *)validatedString:(NSString *)inputStr{
    if (inputStr != nil) {
        if ([inputStr isEqual:[NSNull null]]) {
            return @"";
        } else if([inputStr isKindOfClass: [NSString class]]) {
            if ([inputStr length] == 0) {
                return @"";
            } else {
                return inputStr;
            }
        } else {
            return @"";
        }
    } else {
        return @"";
    }
    return @"";
}

+(NSInteger)validatedInteger:(NSString *)inputStr{
    if ([inputStr isEqual:[NSNull null]]) {
        return 0;
    } else{
        return [inputStr intValue];
    }
    return 0;
}

+(NSMutableDictionary *)setPostDict{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];

    if ([[keychainItem objectForKey:( id)(kSecValueData)] length] != 0 && [[keychainItem objectForKey:( id)(kSecAttrAccount)] length] != 0) {

        [postDict setValue:[keychainItem objectForKey:( id)(kSecAttrAccount)] forKey:kM2MWebServiceUsername];
        [postDict setValue:[keychainItem objectForKey:( id)(kSecValueData)] forKey:kM2MWebServicePassword];
        [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
        [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];
    }

    [keychainItem release];
    return [postDict autorelease];
}

+(UIImage *)arrowImageForPositiveRight:(float)value{
    UIImage *arrowImage = nil;
    if (value > 0.0){
        arrowImage = [UIImage imageNamed:@"arrow_right.png"];
    }else if (value < 0.0){
        arrowImage = [UIImage imageNamed:@"arrow_left.png"];
    }else{
        arrowImage = [UIImage imageNamed:@"arrow_dot.png"];
    }

    return arrowImage;
}
+(UIImage *)arrowImageForPositiveLeft:(float)value{
    UIImage *arrowImage = nil;
    if (value > 0.0){
        arrowImage = [UIImage imageNamed:@"arrow_left.png"];
    }else if (value < 0.0){
        arrowImage = [UIImage imageNamed:@"arrow_right.png"];
    }else{
        arrowImage = [UIImage imageNamed:@"arrow_dot.png"];
    }

    return arrowImage;
}

+(UIImage *)arrowImageForPositiveUp:(float)value{
    UIImage *arrowImage = nil;
    if (value > 0.0){
        arrowImage = [UIImage imageNamed:@"arrow_up.png"];
    }else if (value < 0.0){
        arrowImage = [UIImage imageNamed:@"arrow_down.png"];
    }else{
        arrowImage = [UIImage imageNamed:@"arrow_dot_up.png"];
    }

    return arrowImage;
}

+(UIImage *)arrowImageForPositiveDown:(float)value{
    UIImage *arrowImage = nil;
    if (value > 0.0){
        arrowImage = [UIImage imageNamed:@"arrow_down.png"];
    }else if (value < 0.0){
        arrowImage = [UIImage imageNamed:@"arrow_up.png"];
    }else{
        arrowImage = [UIImage imageNamed:@"arrow_dot_up.png"];
    }

    return arrowImage;
}

+(UIImage *)arrowImageForAlwaysRightOrPositive:(float)value{
    UIImage *arrowImage = nil;
    if (value == 0.00){
        arrowImage = [UIImage imageNamed:@"arrow_dot.png"];
    }else{
        arrowImage = [UIImage imageNamed:@"arrow_right.png"];
    }

    return arrowImage;
}

+(UIImage *)arrowImageForAlwaysLeftOrPositive:(float)value{
    UIImage *arrowImage = nil;
    if (value == 0.00){
        arrowImage = [UIImage imageNamed:@"arrow_dot.png"];
    }else{
        arrowImage = [UIImage imageNamed:@"arrow_left.png"];
    }

    return arrowImage;
}

+(void)style:(LabelStyle)labelStyle forLabel:(UILabel *)theLabel{
    switch (labelStyle) {
        case LabelStyleLoginTitle:{
            theLabel.font =                        LABEL_LOGIN_TEXT_FONT;
            theLabel.textColor =                   LABEL_LOGIN_TEXT_COLOR;
            break;
        }
        case LabelStyleLoginTitleiPad:{
            theLabel.font =                        LABEL_LOGIN_TEXT_FONT;
            theLabel.textColor =                   LABEL_LOGIN_TEXT_COLOR_IPAD;
            break;
        }
        case LabelStyleSectionHeader:{
            theLabel.font =                        LABEL_SECTION_HEADERS_TEXT_FONT;
            theLabel.textColor =                   LABEL_SECTION_HEADERS_TEXT_COLOR;
            //theLabel.backgroundColor = COLOR_BACKGROUND;
            break;
        }
        case LabelStyleSiteTitle:{
            theLabel.font =                        LABEL_HEADERS_TEXT_FONT;
            theLabel.textColor =                   LABEL_HEADERS_TEXT_COLOR;
            break;
        }
        case LabelStyleSiteValue:{
            theLabel.font =                        LABEL_SITE_SUMMERY_TEXT_FONT;
            theLabel.textColor =                   LABEL_SITE_SUMMERY_TEXT_COLOR;
            break;
        }
        case LabelStyleSiteValueName:{
            theLabel.font =                        LABEL_SITE_SUMMERY_NAME_TEXT_FONT;
            theLabel.textColor =                   LABEL_SITE_SUMMERY_NAME_TEXT_COLOR;
            break;
        }
        case LabelStyleOverviewTitle:{
            theLabel.font =                        LABEL_OVERVIEW_TITLE_TEXT_FONT;
            theLabel.textColor =                   LABEL_OVERVIEW_TITLE_TEXT_COLOR;
            break;
        }
        case LabelStyleExtenderTitle:{
            theLabel.font =                        LABEL_EXTENDER_TITLE_TEXT_FONT;
            theLabel.textColor =                   LABEL_EXTENDER_TITLE_TEXT_COLOR;
            break;
        }
        case LabelStyleExtenderType:{
            theLabel.font =                        LABEL_EXTENDER_TYPE_TEXT_FONT;
            theLabel.textColor =                   LABEL_EXTENDER_TYPE_TEXT_COLOR;
            break;
        }
        case LabelStyleExtenderStateTemp:{
            theLabel.font =                        LABEL_EXTENDER_STATE_TEXT_FONT;
            theLabel.textColor =                   LABEL_EXTENDER_STATE_TEMP_TEXT_COLOR;
            break;
        }
        case LabelStyleExtenderStateIn:{
            theLabel.font =                        LABEL_EXTENDER_STATE_TEXT_FONT;
            theLabel.textColor =                   LABEL_EXTENDER_STATE_IN_TEXT_COLOR;
            break;
        }
        case LabelStyleLookInside:{
            theLabel.font =                        LABEL_EXPLANATORY_TEXT_FONT;
            theLabel.textColor =                   LABEL_EXPLANATORY_TEXT_COLOR;
            break;
        }
        case LabelStyleHistoricDataTitle:{
            theLabel.font =                        LABEL_HISTORIC_DATA_TEXT_FONT;
            theLabel.textColor =                   LABEL_HISTORIC_DATA_TEXT_COLOR;
            break;
        }
        default:
            break;
    }
}
+(void)style:(LabelStyle)labelStyle forLabel:(UILabel *)theLabel withFormat:(Format)format{
    switch (labelStyle) {
        case LabelStyleHistoricDataValue:{
            theLabel.font =                        LABEL_HISTORIC_DATA_TEXT_FONT;
            break;
        }
        case LabelStyleOverviewValue:{
            theLabel.font =                        LABEL_OVERVIEW_VALUE_TEXT_FONT;
            break;
        }
        default:
            break;
    }

    switch(format) {
        case VOLT:
            theLabel.textColor = COLOR_BLUE;
            break;
        case AMPHOUR:
            theLabel.textColor = COLOR_ORANGE;
            break;
        case AMPS:
            theLabel.textColor = COLOR_RED;
            break;
        default:
            theLabel.textColor = COLOR_BLACK;
            break;
    }
}

+(void)style:(ButtonStyle)buttonStyle forButton:(UIButton *)theButton{
    switch (buttonStyle) {
        case ButtonStyleNormal:{
            theButton.titleLabel.font =             BUTTON_TEXT_TEXT_FONT;
            theButton.layer.cornerRadius = 6;
            [theButton setBackgroundImage:[[UIImage imageNamed:@"btn_orange_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)] forState:UIControlStateNormal];
            [theButton setBackgroundImage:[[UIImage imageNamed:@"btn_orange_pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)] forState:UIControlStateSelected];
            [theButton setBackgroundImage:[[UIImage imageNamed:@"btn_orange_disabled.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)] forState:UIControlStateDisabled];
            [theButton setTitleColor:BUTTON_TEXT_TEXT_COLOR forState:normal];
            [theButton setTitleColor:BUTTON_TEXT_TEXT_COLOR_PRESSED forState:UIControlStateHighlighted];
            break;
        }
        case ButtonStyleForgotPassword:{
            theButton.titleLabel.font =              BUTTON_LINK_TEXT_FONT;
            [theButton setTitleColor:BUTTON_LINK_TEXT_TEXT_COLOR forState:normal];
            [theButton setTitleColor:BUTTON_LINK_TEXT_TEXT_COLOR_PRESSED forState:UIControlStateHighlighted];
            break;
        }
    }
}

+(void)style:(TextfieldStyle)textfieldStyle forTextfield:(UITextField *)theTextfield{
    switch (textfieldStyle) {
        case TextfieldStyleNormal:{
            theTextfield.borderStyle = UITextBorderStyleRoundedRect;
            theTextfield.backgroundColor =           COLOR_BACKGROUND_TEXTFIELD;
            theTextfield.returnKeyType =             UIReturnKeyDone;
            theTextfield.font =                      TEXT_FIELDS_TEXT_FONT;
            theTextfield.layer.cornerRadius = 5.0f;
            theTextfield.layer.masksToBounds = YES;
            theTextfield.layer.borderColor = [COLOR_LINE CGColor];
            theTextfield.layer.borderWidth = 1.0f;

            break;
        }
        case TextfieldSettings:{
            theTextfield.font =                      LABEL_EXPLANATORY_TEXT_FONT;
            theTextfield.textColor =                 LABEL_EXPLANATORY_TEXT_COLOR;
            break;
        }

    }
}

@end
