//
//  TemperatureExtenderCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 3/28/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "TemperatureExtenderCell.h"

@implementation TemperatureExtenderCell

- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;
    [Tools style:LabelStyleExtenderType forLabel:self.cellNameLabel];
    [Tools style:LabelStyleExtenderStateTemp forLabel:self.temperatureLabel];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

-(void)setDataWithExtender:(ExtenderInfo *) extender {
    self.cellNameLabel.text = extender.label;
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.1f%@C",extender.temperature, @"\u00B0"];
}

@end
