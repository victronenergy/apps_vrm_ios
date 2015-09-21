//
//  M2MImagesCollectionViewDataSource.m
//  VictronEnergy
//
//  Created by Lime on 03/06/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MImagesCollectionViewDataSource.h"
#import "M2MImagesCollectionViewCell.h"
#import "M2MNoRightsCollectionViewCell.h"

@implementation M2MImagesCollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (!self.selectedSite.canEditSite && [self.selectedSite.imageURLS count] == 0) {

        return 1;

    } else {
        NSInteger numberOfCells = [self.selectedSite.imageURLS count];

        if (self.selectedSite.canEditSite && self.inFooterOfSiteDetail) {
            numberOfCells ++;
        }

        return  numberOfCells;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.selectedSite.canEditSite && [self.selectedSite.imageURLS count] == 0) {
        M2MNoRightsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"M2MNoRightsCollectionViewCell" forIndexPath:indexPath];

        cell.noRightsLabel.text = NSLocalizedString(@"gallery_no_rights", @"no rights text for the gallery");

        return cell;

    } else {
        M2MImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];

        if (indexPath.row == [self.selectedSite.imageURLS count] ) {

            cell.imageView.image = [UIImage imageNamed:@"ic_photo_gallery.png"];
            cell.imageView.contentMode = UIViewContentModeCenter;
            cell.inFooterOfSiteDetail = YES;
            cell.backgroundColor = [UIColor whiteColor];
            [cell setBorderForImageView];

        } else {

            [cell setImageWithImageUrl:self.selectedSite.imageURLS[indexPath.row] siteID:self.selectedSite.siteID inFooterOfSiteDetail:self.inFooterOfSiteDetail];

            if (self.inFooterOfSiteDetail) {
                cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            } else {
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                cell.imagesCollectionViewController = self.delegate;
            }
        }

        return cell;
    }
}

@end
