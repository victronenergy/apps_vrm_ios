//
//  SitesOKCell.m
//  VictronEnergy
//
//  Created by Mandarin on 21/02/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "SitesOKCell.h"
#import "M2MSummaryWidget.h"
#import "M2MWidgetCollectionCell.h"
#import "SiteListTableViewController.h"
#import "M2MDateFormats.h"

@interface SitesOKCell ()
@property (nonatomic) BOOL didLayoutSubviews;
@end

@implementation SitesOKCell

-(void)awakeFromNib{

    self.backgroundColor = COLOR_BACKGROUND;
    self.contentView.backgroundColor = COLOR_BACKGROUND;

    [Tools style:LabelStyleSiteTitle forLabel:self.nameLabel];
    [Tools style:LabelStyleLastUpdate forLabel:self.lastUpdateLabel];

    self.backgroundViewForFrame.backgroundColor = COLOR_WHITE;
    self.backgroundViewForFrame.layer.borderColor = COLOR_LINE.CGColor;
    self.backgroundViewForFrame.layer.borderWidth = 1.0f;

    self.pageControl.pageIndicatorTintColor = COLOR_BULLETS_NORMAL;
    self.pageControl.currentPageIndicatorTintColor = COLOR_BULLETS_SELECTION;
}

- (void)layoutSubviews
{
    if(!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.backgroundViewForFrame.frame];
        self.selectedBackgroundView.backgroundColor = COLOR_GREY_SELECTION;
    }
}

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo andTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath andIsLoading:(BOOL)isLoading{

    self.nameLabel.text = siteInfo.name;
    self.widgetsArray = siteInfo.siteSummaryWidgets;
    self.indexPath = indexPath;
    self.tableView = tableView;
    self.isLoading = isLoading;

    NSString *dateString = [[M2MDateFormats sharedInstance] dateStringFromTimeStamp:siteInfo.lastUpdated];
    NSString *lastUpdateLabel = NSLocalizedString(@"last_update_label", @"");
    self.lastUpdateLabel.text = [NSString stringWithFormat:@"%@ %@", lastUpdateLabel, dateString];

    [self.widgetCollectionView reloadData];

    self.pageControl.numberOfPages = ceilf([self.widgetsArray count] / kNumberOfWidgetsPerPage);
    self.pageControl.currentPage = 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SiteListTableViewController *vc = (SiteListTableViewController *) self.tableView.dataSource;
    [vc tableView:self.tableView didSelectRowAtIndexPath:self.indexPath];
    [self.tableView selectRowAtIndexPath:self.indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.widgetsArray count]) {
        return [self.widgetsArray count];
    }
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    M2MWidgetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"M2MWidgetCollectionCell" forIndexPath:indexPath];
    [cell setDataWithSummaryWidget:[self.widgetsArray objectAtIndex:indexPath.row] andIsLoading:self.isLoading];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.widgetCollectionView.frame.size.width / kNumberOfWidgetsPerPage, self.widgetCollectionView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.widgetCollectionView.contentOffset.x / kPageControlOffSetX;
}

@end
