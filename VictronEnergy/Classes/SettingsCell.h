//
//  SettingsCell.h
//  VictronEnergy
//
//  Created by Victron Energy on 4/12/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@interface SettingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *generatorOutputLabel;
@property (weak, nonatomic) IBOutlet UILabel *generatorStateLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectOutputButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *stoppedLightView;
@property (weak, nonatomic) IBOutlet UIView *runningLightView;

@property (weak, nonatomic) IBOutlet UIView *selectOutputView;
@property (weak, nonatomic) IBOutlet UIView *selectGeneratorView;
@property (weak, nonatomic) IBOutlet UIView *frameForSegmentedControl;

-(void)setDataWithGeneratorState:(NSInteger)generatorState andSelectedOutput:(NSString *)selectedOutput;

@end
