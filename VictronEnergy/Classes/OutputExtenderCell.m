//
//  OutputExtenderCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 3/28/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "OutputExtenderCell.h"
#import "ExtenderInfo.h"

@implementation OutputExtenderCell

- (void)awakeFromNib{

    self.backgroundColor = [UIColor clearColor];
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;
    [Tools style:LabelStyleExtenderType forLabel:self.cellNameLabel];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

-(void)setDataWithExtender:(ExtenderInfo *) extender {

    if (extender.status == 1) {
        [self.outputSwitch setOn:YES];
    }
    else{
        [self.outputSwitch setOn:NO];
    }

    self.cellNameLabel.text = extender.label;
    self.outputSwitch.onTintColor = COLOR_BLUE;

    if ([extender.code isEqualToString: EXTENDER_OUTPUT_1]) {
        self.outputSwitch.tag = CELL_TAG_1;

    }
    else if ([extender.code isEqualToString: EXTENDER_OUTPUT_2]) {
        self.outputSwitch.tag = CELL_TAG_2;
    }
}

@end
