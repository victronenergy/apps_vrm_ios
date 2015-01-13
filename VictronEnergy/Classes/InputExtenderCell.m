//
//  InputExtenderCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 3/28/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "InputExtenderCell.h"
#import "ExtenderInfo.h"

@implementation InputExtenderCell

- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;
    [Tools style:LabelStyleExtenderType forLabel:self.cellNameLabel];
    [Tools style:LabelStyleExtenderStateIn forLabel:self.stateLabel];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

-(void)setDataWithExtender:(ExtenderInfo *) extender {
    if (extender.status == 1) {
        self.stateLabel.text = NSLocalizedString(@"input_text_open", @"input_text_open");
    }
    else{
        self.stateLabel.text = NSLocalizedString(@"input_text_closed", @"input_text_closed");
    }

    self.cellNameLabel.text = extender.label;
}

@end
