//
//  SiteDetail2Cell.h
//  VictronEnergy
//
//  Created by Thijs on 3/27/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AttributesInfo.h"
#import "SiteInfo.h"

@interface BMVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *socLabel;
@property (weak, nonatomic) IBOutlet UILabel *voltageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumedLabel;
@property (weak, nonatomic) IBOutlet UILabel *dcSystemValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dcSystemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dcSystemArrowImage;
@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;

- (void)setDataWithSite:(SiteInfo *)siteInfo;

@end
