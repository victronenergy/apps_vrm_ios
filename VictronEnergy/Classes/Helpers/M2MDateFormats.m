//
// Created by Jim van Zummeren on 20/07/15.
// Copyright (c) 2015 M2Mobi. All rights reserved.
//

#import "M2MDateFormats.h"
#import "NSDate+TimeAgo.h"


@implementation M2MDateFormats

NSString *const kDateFormatDisplay = @"dd-MM-yyyy HH:mm";

- (NSDateFormatter *) formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    return dateFormatter;
}


/** Returns a string from timestamp
 * If it's less than 6 hours ago, return a natural string like:
 * '2 hours ago'
 * Otherwise return a normal date string like
 * '14-09-2015 17:44'
 **/

- (NSString *) dateStringFromTimeStamp:(NSInteger) timeStamp{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSInteger hoursAgo = [date m2m_hoursAgo];

    if(!self.timeFormatter) {
        self.timeFormatter = [self formatter];
        [self.timeFormatter setDateFormat:kDateFormatDisplay];
    }

    if(hoursAgo < 6) {
        return [date m2m_naturalLanguageTimeAgo];
    }else{
        return [self.timeFormatter stringFromDate:date];
    }
}

+ (M2MDateFormats *)sharedInstance
{
    static M2MDateFormats *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}
@end