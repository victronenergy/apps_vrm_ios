//
//  M2MWidgetCollectionCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 01/05/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "M2MWidgetCollectionCell.h"

@implementation M2MWidgetCollectionCell

-(void)setDataWithSummaryWidget:(M2MSummaryWidget *)widget andIsLoading:(BOOL)isLoading {

    [Tools style:LabelStyleSiteValue forLabel:self.summaryValueLabel];
    [Tools style:LabelStyleSiteValueName forLabel:self.summaryNameLabel];

    if (widget) {
        self.summaryNameLabel.text = widget.widgetLabel;
        self.summaryValueLabel.text = widget.text;
        self.summeryValueImageView.image = widget.image;

    } else {
        self.summeryValueImageView.image = nil;
        self.summaryNameLabel.text = nil;

        if (isLoading) {
            UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame:self.summeryValueImageView.frame];
            progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [progress startAnimating];
            [self addSubview:progress];

            self.summaryValueLabel.text = NSLocalizedString(@"widget_loading", @"widget_loading");
        } else {
            self.summaryValueLabel.text = NSLocalizedString(@"widget_no_data", @"widget_no_data");
        }
    }
}

@end
