//
//  ExtenderCell.h
//  VictronEnergy
//
//  Created by Victron Energy on 3/28/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtenderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *extenderTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;

@end
