//
// Created by Jim van Zummeren on 14/09/15.
// Copyright (c) 2015 M2Mobi. All rights reserved.
//

#import "NSDate+TimeAgo.h"

NSInteger const kOneMinuteInSeconds = 60;
NSInteger const kOneHourInSeconds = kOneMinuteInSeconds * 60;
NSInteger const kOneDayInSeconds = kOneHourInSeconds * 24;
NSInteger const kOneMonthInSeconds = kOneDayInSeconds * 30;
NSInteger const kOneYearInSeconds = kOneMonthInSeconds * 12;


@implementation NSDate (TimeAgo)

/** Converts date to a human language date since the current time
 *
 * Example:
 * A moment ago
 * 5 minutes ago
 * 1 hour ago
 * 5 hours ago
 *
 **/

- (NSString *)m2m_naturalLanguageTimeAgo
{
    NSTimeInterval timeInterval = [self timeIntervalSinceNow];
    timeInterval *= -1;

    NSInteger diffInMinutes = (NSInteger) round(timeInterval / kOneMinuteInSeconds);
    NSInteger diffInHours = (NSInteger) round(timeInterval / kOneHourInSeconds);
    NSInteger diffInDays = (NSInteger) round(timeInterval / kOneDayInSeconds);
    NSInteger diffInMonths = (NSInteger) round(timeInterval / kOneMonthInSeconds);

    if(timeInterval < 1) {
        return NSLocalizedString(@"timeago_never", @"");
    } else if (timeInterval < kOneMinuteInSeconds) {
        return NSLocalizedString(@"timeago_a_moment_ago", @"");
    } else if (timeInterval < kOneHourInSeconds && diffInMinutes == 1) {
        return [NSString stringWithFormat:@"%d %@", diffInMinutes, NSLocalizedString(@"timeago_minute_ago", @"")];
    } else if (timeInterval < kOneHourInSeconds) {
        return [NSString stringWithFormat:@"%d %@", diffInMinutes, NSLocalizedString(@"timeago_minutes_ago", @"")];
    } else if (timeInterval < kOneDayInSeconds && diffInHours == 1) {
        return [NSString stringWithFormat:@"%d %@", diffInHours, NSLocalizedString(@"timeago_hour_ago", @"")];
    } else if (timeInterval < kOneDayInSeconds) {
        return [NSString stringWithFormat:@"%d %@", diffInHours, NSLocalizedString(@"timeago_hours_ago", @"")];
    } else if (timeInterval < kOneMonthInSeconds && diffInDays == 1) {
        return [NSString stringWithFormat:@"%d %@", diffInDays, NSLocalizedString(@"timeago_day_ago", @"")];
    } else if (timeInterval < kOneMonthInSeconds) {
        return [NSString stringWithFormat:@"%d %@", diffInDays, NSLocalizedString(@"timeago_days_ago", @"")];
    } else if (timeInterval < kOneYearInSeconds && diffInDays == 1) {
        return [NSString stringWithFormat:@"%d %@", diffInMonths, NSLocalizedString(@"timeago_month_ago", @"")];
    } else if (timeInterval < kOneYearInSeconds) {
        return [NSString stringWithFormat:@"%d %@", diffInMonths, NSLocalizedString(@"timeago_months_ago", @"")];
    }

    return NSLocalizedString(@"timeago_never", @"");;
}

- (NSInteger) m2m_hoursAgo
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self];
    NSInteger diffInHours = (NSInteger) round(timeInterval / kOneHourInSeconds);

    return diffInHours;
}
@end