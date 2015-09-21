//
//  M2MNoRightsCollectionViewCell.m
//  VictronEnergy
//
//  Created by Lime on 08/07/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MNoRightsCollectionViewCell.h"

@implementation M2MNoRightsCollectionViewCell


- (void)drawRect:(CGRect)rect
{
    [Tools style:LabelStyleLookInside forLabel:self.noRightsLabel];
}


@end
