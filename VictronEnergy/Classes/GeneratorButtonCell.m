//
//  GeneratorButtonCell.m
//  VictronEnergy
//
//  Created by Thijs on 9/4/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "GeneratorButtonCell.h"
#import "ExtenderInfo.h"
#import "SiteDetailViewController.h"

@implementation GeneratorButtonCell

-(void)awakeFromNib{

    [Tools style:ButtonStyleNormal forButton:self.generatorButton];
    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.siteAlreadyInList = NO;

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}

-(void)setDataWithSiteSettingsList:(NSDictionary *)settings selectedSite:(SiteInfo *)selectedSite outputList:(NSMutableArray *)outputList tableviewController:(SiteDetailViewController *)tableviewController{

    self.hidden = NO;
    self.generatorButton.hidden = NO;

    // Enable or disable the button according to the rights of this user
    if (selectedSite.canEditSite == NO) {
        self.generatorButton.enabled = NO;
    }

    // Check if a site has settings and if so, set the generator button text according to the settings and the selected extenderstatus
    if (!settings) {

        [self.generatorButton setTitle: NSLocalizedString(@"generator_button_not_set", @"generator_button_not_set") forState:normal];
        tableviewController.hasSetGeneratorSettings = NO;

    } else {

        // Set the generator button text according to the settings and the selected extender status
        ExtenderInfo *extender = [ExtenderInfo getExtenderForSettingsList:settings thatMatchesTheExtenderInTheoutputList:outputList];
        tableviewController.hasSetGeneratorSettings =  YES;

        if ([extender.code isEqualToString:EXTENDER_OUTPUT_1]) {
            tableviewController.selectedOutput = 0;
        } else if ([extender.code isEqualToString:EXTENDER_OUTPUT_2]) {
            tableviewController.selectedOutput = 1;
        }

        if (extender.status == 1 )
        {
            if ([[settings objectForKey:KEY_GENERATOR_STATE] isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [self.generatorButton setTitle: NSLocalizedString(@"generator_button_start", @"generator_button_start") forState:normal];
                tableviewController.startGenerator = YES;

            }
            else if ([[settings objectForKey:KEY_GENERATOR_STATE] isEqualToNumber:[NSNumber numberWithInt:1]])
            {
                [self.generatorButton setTitle: NSLocalizedString(@"generator_button_stop", @"generator_button_stop") forState:normal];
                tableviewController.startGenerator = NO;
            }
        }
        else if (extender.status == 0 )
        {
            if ([[settings objectForKey:KEY_GENERATOR_STATE] isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [self.generatorButton setTitle: NSLocalizedString(@"generator_button_stop", @"generator_button_stop") forState:normal];
                tableviewController.startGenerator = NO;
            }
            else if ([[settings objectForKey:KEY_GENERATOR_STATE] isEqualToNumber:[NSNumber numberWithInt:1]])
            {
                [self.generatorButton setTitle: NSLocalizedString(@"generator_button_start", @"generator_button_start") forState:normal];
                tableviewController.startGenerator = YES;
            }
        }
    }
}

@end
