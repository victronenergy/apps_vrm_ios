//
//  ExtenderCell.h
//  VictronEnergy
//
//  Created by Thijs on 3/28/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtenderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *extenderTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;

@end
