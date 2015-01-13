//
//  SettingsHeaderCell.h
//  VictronEnergy
//
//  Created by Victron Energy on 16/04/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;

@property (weak, nonatomic) IBOutlet UISwitch *hasGeneratorSwitch;

@property (weak, nonatomic) IBOutlet UILabel *hasGeneratorLabel;

@property (weak, nonatomic) IBOutlet UIView *hasGeneratorView;

@end
