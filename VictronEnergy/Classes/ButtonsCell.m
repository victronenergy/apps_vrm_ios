//
//  ButtonsCell.m
//  VictronEnergy
//
//  Created by Thijs on 5/7/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "ButtonsCell.h"

@implementation ButtonsCell

- (void)awakeFromNib{

    [Tools style:ButtonStyleNormal forButton:self.historicDataButton];

    // Set the HistoricData button text without animation
    [UIView performWithoutAnimation:^{
        [self.historicDataButton setTitle: NSLocalizedString(@"historic_data_button_title", @"historic_data_button_title") forState:normal];
    }];

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

@end
