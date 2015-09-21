//
//  M2MDetailOKCell.h
//  VictronEnergy
//
//  Created by Lime on 01/04/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@interface M2MDetailOKCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackground;

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo;

@end
