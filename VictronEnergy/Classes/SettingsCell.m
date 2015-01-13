//
//  SettingsCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 4/12/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

-(void)awakeFromNib{

    self.backgroundColor = [UIColor clearColor];
    [Tools style:LabelStyleLookInside forLabel:self.generatorOutputLabel];
    [Tools style:LabelStyleLookInside forLabel:self.generatorStateLabel];
    [Tools style:ButtonStyleNormal forButton:self.selectOutputButton];

    [self setBorderForView:self.selectOutputView];
    [self setBorderForView:self.selectGeneratorView];

    self.runningLightView.backgroundColor = COLOR_GREY;
    self.runningLightView.layer.cornerRadius = 8.0f;

    self.stoppedLightView.backgroundColor = COLOR_GREY;
    self.stoppedLightView.layer.cornerRadius = 8.0f;

    // If the device is an iPhone change heigt of the segmented control according to the design
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        float newHeight = 38.0f;
        CGRect frame = self.segmentedControl.frame;
        [self.segmentedControl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight)];
    }

    // Set the textcolor for the normal and the selected state the same
    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:SEGMENTEDCONTROL_FONT,
                                           NSForegroundColorAttributeName:SEGMENTEDCONTROL_FONT_COLOR
                                                    }
                                forState:UIControlStateNormal];

    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:SEGMENTEDCONTROL_FONT,
                                                    NSForegroundColorAttributeName:SEGMENTEDCONTROL_FONT_COLOR
                                                    }
                                         forState:UIControlStateSelected];

    self.segmentedControl.tintColor = COLOR_WHITE;
    self.segmentedControl.backgroundColor = COLOR_LIGHT_GREY;

    self.segmentedControl.layer.borderColor = COLOR_LIGHT_GREY.CGColor;
    self.segmentedControl.layer.borderWidth = 2.0f;
    self.segmentedControl.layer.cornerRadius = 2.0f;

    // Added this view with a frame to give the segmentedcontrol an extra border according to the design
    self.frameForSegmentedControl.layer.borderColor = COLOR_LINE.CGColor;
    self.frameForSegmentedControl.layer.borderWidth = 2.0f;
    self.frameForSegmentedControl.layer.cornerRadius = 3.0f;
    self.frameForSegmentedControl.backgroundColor = COLOR_LIGHT_GREY;

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

-(void)setDataWithGeneratorState:(NSInteger)generatorState andSelectedOutput:(NSString *)selectedOutput{

    if (generatorState) {
        self.stoppedLightView.backgroundColor = COLOR_GREY;
        self.runningLightView.backgroundColor = COLOR_GREEN;
    } else {
        self.stoppedLightView.backgroundColor = COLOR_RED;
        self.runningLightView.backgroundColor = COLOR_GREY;
    }

    if ([selectedOutput length]) {
        [self.selectOutputButton setTitle:selectedOutput forState:UIControlStateNormal ];
    } else {
        NSString *selectOutput = NSLocalizedString(@"button_select_IO_Extender_output", @"Select output");
        [self.selectOutputButton setTitle:selectOutput forState:UIControlStateNormal ];
    }

    [self.segmentedControl setSelectedSegmentIndex:generatorState];
}

-(void) setBorderForView:(UIView *)view{
    view.layer.borderColor = COLOR_LINE.CGColor;
    view.layer.borderWidth = 1.0f;
    view.backgroundColor = COLOR_WHITE;
}

@end
