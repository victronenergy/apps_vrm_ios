//
//  SitesOKCell.m
//  VictronEnergy
//
//  Created by Mandarin on 21/02/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "SitesOKCell.h"
#import "M2MSummaryWidget.h"
#import "M2MWidgetCollectionCell.h"
#import "SiteListTableViewController.h"

@implementation SitesOKCell

-(void)awakeFromNib{

    self.backgroundColor = COLOR_BACKGROUND;
    self.contentView.backgroundColor = COLOR_BACKGROUND;

    [Tools style:LabelStyleSiteTitle forLabel:self.nameLabel];

    self.backgroundViewForFrame.backgroundColor = COLOR_WHITE;
    self.backgroundViewForFrame.layer.borderColor = COLOR_LINE.CGColor;
    self.backgroundViewForFrame.layer.borderWidth = 1.0f;

#warning iPad - For some reason iOS stretches the view for which we created an outlet in storyboard. By programmatically creating a view with the same size we can force iOS to respect the set size.
    UIView *contentViewSelected = [[UIView alloc] initWithFrame:self.frame];
    UIView *siteViewSelected = [[UIView alloc] initWithFrame:CGRectMake(self.backgroundViewForFrame.frame.origin.x, self.backgroundViewForFrame.frame.origin.y, self.backgroundViewForFrame.frame.size.width, self.backgroundViewForFrame.frame.size.height)];
    siteViewSelected.backgroundColor = COLOR_GREY_SELECTION;
    contentViewSelected.backgroundColor = COLOR_BACKGROUND;
    [contentViewSelected addSubview:siteViewSelected];
    self.selectedBackgroundView = contentViewSelected;

    self.pageControl.pageIndicatorTintColor = COLOR_BULLETS_NORMAL;
    self.pageControl.currentPageIndicatorTintColor = COLOR_BULLETS_SELECTION;
}

-(void)setDataWithSiteObject:(SiteInfo *)siteInfo andTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath andIsLoading:(BOOL)isLoading{

    self.nameLabel.text = siteInfo.name;
    self.widgetsArray = siteInfo.siteSummaryWidgets;
    self.indexPath = indexPath;
    self.tableView = tableView;
    self.isLoading = isLoading;

    [self.widgetCollectionView reloadData];

    self.pageControl.numberOfPages = ceilf([self.widgetsArray count]/3);
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.widgetCollectionView.contentOffset.x / kPageControlOffSetX;
}

@end
