//
//  BMV+MultiCell.h
//  VictronEnergy
//
//  Created by Thijs on 9/4/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributesInfo.h"
#import "SiteInfo.h"

@interface BMV_MultiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *acInPhase1Label;
@property (weak, nonatomic) IBOutlet UILabel *acInPhase2Label;
@property (weak, nonatomic) IBOutlet UILabel *acInPhase3Label;
@property (weak, nonatomic) IBOutlet UILabel *acSystemPhase1Label;
@property (weak, nonatomic) IBOutlet UILabel *acSystemPhase2Label;
@property (weak, nonatomic) IBOutlet UILabel *acSystemPhase3Label;
@property (weak, nonatomic) IBOutlet UILabel *dcCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryVoltageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *acInNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *acOutNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dcSystemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dcSystemValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentArrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *acOutArrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *dcSystemArrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *acInArrowImage;
@property (weak, nonatomic) IBOutlet UILabel *consumedLabel;
@property (weak, nonatomic) IBOutlet UILabel *batterySocLabel;

@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;

- (void)setDataWithSite:(SiteInfo *)siteInfo;

@end
