//
//  GeneratorButtonCell.h
//  VictronEnergy
//
//  Created by Thijs on 9/4/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@class SiteDetailViewController;

@interface GeneratorButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *generatorButton;
@property (assign, nonatomic) BOOL siteAlreadyInList;

@property (weak, nonatomic) IBOutlet UIView *backgroundBorderView;

-(void)setDataWithSiteSettingsList:(NSDictionary *)settings selectedSite:(SiteInfo *)selectedSite outputList:(NSMutableArray *)outputList tableviewController:(SiteDetailViewController *)tableviewController;


@end
