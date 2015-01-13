//
//  M2MSelectOutputCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 02/04/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "M2MSelectOutputCell.h"

@implementation M2MSelectOutputCell

- (void)awakeFromNib
{
    [Tools style:LabelStyleSiteTitle forLabel:self.outputLabel];
    self.backgroundColor = [UIColor clearColor];

    self.borderBackgroundView.backgroundColor = COLOR_WHITE;
    self.borderBackgroundView.layer.borderColor = COLOR_LINE.CGColor;
    self.borderBackgroundView.layer.borderWidth = 1.0f;
}


@end
