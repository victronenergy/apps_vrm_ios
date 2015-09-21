//
//  M2MAboutHeaderTableViewCell.m
//  VictronEnergy
//
//  Created by Lime on 04/07/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MAboutHeaderTableViewCell.h"
#import "Tools.h"

@implementation M2MAboutHeaderTableViewCell

- (void)awakeFromNib
{
    // Initialization code

    self.headerImageView.image = [[UIImage imageNamed:@"heading_corner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kHeaderInsetImageTop, kHeaderInsetImageLeft, kHeaderInsetImageBottom, kHeaderInsetImageRight)];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.headerLabel.text = [NSString stringWithFormat:@"Version %@",version];

    [Tools style:LabelStyleSectionHeader forLabel:self.headerLabel];


    self.contentView.backgroundColor = COLOR_BACKGROUND;

}

@end
