//
// Created by Jim van Zummeren on 20/07/15.
// Copyright (c) 2015 Thijs Bouma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SiteInfo;


@interface M2MLastUpdateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)setDataWithSiteObject:(SiteInfo *)siteInfo;
@end