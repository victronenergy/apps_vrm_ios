//
//  OutputExtenderCell.h
//  VictronEnergy
//
//  Created by Thijs on 3/28/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtenderInfo.h"

@interface OutputExtenderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *outputSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *outputImage;

@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;

-(void)setDataWithExtender:(ExtenderInfo *) extender;

@end
