//
//  SitesOKCell.h
//  VictronEnergy
//
//  Created by Mandarin on 21/02/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@interface SitesOKCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *backgroundViewForFrame;

@property (weak, nonatomic) IBOutlet UICollectionView *widgetCollectionView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *widgetsArray;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) BOOL isLoading;

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo andTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath andIsLoading:(BOOL)isLoading;

@end
