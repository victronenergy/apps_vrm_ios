//
//  NoDataCell.h
//  VictronEnergy
//
//  Created by Thijs on 5/28/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *noDataTextView;
@property (weak, nonatomic) IBOutlet UIImageView *noDataSettingsImage;

-(void)setNoDataSettingsText:(BOOL)canEditSite;

@end
