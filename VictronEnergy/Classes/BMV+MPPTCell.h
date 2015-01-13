//
//  BMV+MPPTCell.h
//  VictronEnergy
//
//  Created by Mandarin on 30/01/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AttributesInfo.h"
#import "SiteInfo.h"

@interface BMV_MPPTCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *batteryVoltageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dcSystemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dcSystemValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dcSystemArrowImage;
@property (weak, nonatomic) IBOutlet UILabel *consumedLabel;
@property (weak, nonatomic) IBOutlet UILabel *batterySocLabel;
@property (weak, nonatomic) IBOutlet UIImageView *solarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *solarArrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *solarWattLabel;

-(void)setDataWithAttributesInfo:(AttributesInfo *)attributesInfo withSite:(SiteInfo *)siteInfo;

@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;

@end
