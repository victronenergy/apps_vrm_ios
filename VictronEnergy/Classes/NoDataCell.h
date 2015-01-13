//
//  NoDataCell.h
//  VictronEnergy
//
//  Created by Victron Energy on 5/28/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *noDataTextView;
@property (weak, nonatomic) IBOutlet UIImageView *noDataSettingsImage;

-(void)setNoDataSettingsText:(BOOL)canEditSite;

@end
