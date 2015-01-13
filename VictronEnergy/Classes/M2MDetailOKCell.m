//
//  M2MDetailOKCell.m
//  VictronEnergy
//
//  Created by Victron Energy on 01/04/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "M2MDetailOKCell.h"

@implementation M2MDetailOKCell
-(void)awakeFromNib{

    self.backgroundColor = [UIColor clearColor];

    [Tools style:LabelStyleSectionHeader forLabel:self.nameLabel];

    self.headerBackground.image = [[UIImage imageNamed:@"heading_corner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kHeaderInsetImageTop, kHeaderInsetImageLeft, kHeaderInsetImageBottom, kHeaderInsetImageRight)];

    self.contentView.backgroundColor = COLOR_BACKGROUND;
}
-(void)setDataWithSiteObject:(SiteInfo *)siteInfo{

    self.nameLabel.text = siteInfo.name;
}

@end
