//
//  NoDataCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 5/28/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "NoDataCell.h"

@implementation NoDataCell

- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.noDataTextView.backgroundColor = [UIColor clearColor];
    self.noDataTextView.font =                           LABEL_BATTERY_EXPLANATION_TEXT_FONT_BIG;
    self.noDataTextView.textColor =                      LABEL_BATTERY_EXPLANATION_TEXT_COLOR;
}

-(void)setNoDataSettingsText:(BOOL)canEditSite{

    if (canEditSite == NO) {
        self.noDataTextView.text = [NSString stringWithFormat:NSLocalizedString(@"no_data_text_no_rights", @"no_data_text")];
        self.noDataSettingsImage.hidden = YES;
    }
    else{
        self.noDataTextView.text = [NSString stringWithFormat:NSLocalizedString(@"no_data_text", @"no_data_text")];
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            self.noDataSettingsImage.center = CGPointMake(53.0f, 87.0f);
        }
        self.noDataSettingsImage.hidden = NO;
    }

}

@end
