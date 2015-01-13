//
//  TemperatureExtenderCell.h
//  VictronEnergy
//
//  Created by Victron Energy on 3/28/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtenderInfo.h"

@interface TemperatureExtenderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureImage;
@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;

@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;

-(void)setDataWithExtender:(ExtenderInfo *) extender;

@end
