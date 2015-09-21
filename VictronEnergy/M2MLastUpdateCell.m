//
// Created by Jim van Zummeren on 20/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import "M2MLastUpdateCell.h"
#import "SiteInfo.h"
#import "M2MDateFormats.h"
#import "NSDate+TimeAgo.h"


@implementation M2MLastUpdateCell
-(void)awakeFromNib  {
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;
    self.contentView.backgroundColor = COLOR_BACKGROUND;
    [Tools style:LabelStyleOverviewValue forLabel:self.label withFormat:NONE];
    self.clipsToBounds = YES;
}

- (void)setDataWithSiteObject:(SiteInfo *)siteInfo
{
    NSString *dateString = [[M2MDateFormats sharedInstance] dateStringFromTimeStamp:siteInfo.lastUpdated];

    NSString *lastUpdateLabel = NSLocalizedString(@"last_update_label", @"");
    self.label.text = [NSString stringWithFormat:@"%@ %@", lastUpdateLabel, dateString];
}
@end