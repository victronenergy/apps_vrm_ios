//
//  ExtenderCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 3/28/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "ExtenderCell.h"

@implementation ExtenderCell

-(void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;
    self.backgroundBorderView.backgroundColor = COLOR_SUB_HEADER;
    [Tools style:LabelStyleExtenderTitle forLabel:self.extenderTitleLabel];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

@end
