//
//  M2MWidgetCollectionCell.h
//  VictronEnergy
//
//  Created by Victron Energy on 01/05/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M2MSummaryWidget.h"

@interface M2MWidgetCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *summaryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *summeryValueImageView;

-(void)setDataWithSummaryWidget:(M2MSummaryWidget *)widget andIsLoading:(BOOL)isLoading;

@end
