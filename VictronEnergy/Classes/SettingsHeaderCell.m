//
//  SettingsHeaderCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 16/04/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "SettingsHeaderCell.h"

@implementation SettingsHeaderCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];

    [Tools style:LabelStyleSectionHeader forLabel:self.settingsLabel];
    [Tools style:LabelStyleLookInside forLabel:self.hasGeneratorLabel];
    self.hasGeneratorSwitch.onTintColor = COLOR_BLUE;

    self.headerImageView.image = [[UIImage imageNamed:@"heading_corner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kHeaderInsetImageTop, kHeaderInsetImageLeft, kHeaderInsetImageBottom, kHeaderInsetImageRight)];
    [self setBorderForView:self.hasGeneratorView];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

-(void) setBorderForView:(UIView *)view{
    view.layer.borderColor = COLOR_LINE.CGColor;
    view.layer.borderWidth = 1.0f;
    view.backgroundColor = COLOR_WHITE;
}

@end
