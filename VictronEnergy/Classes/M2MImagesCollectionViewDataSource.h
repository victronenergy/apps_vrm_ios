//
//  M2MImagesCollectionViewDataSource.h
//  VictronEnergy
//
//  Created by Victron Energy on 03/06/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M2MImagesCollectionViewController.h"
#import "SiteInfo.h"

@interface M2MImagesCollectionViewDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) SiteInfo *selectedSite;
@property (nonatomic, assign) BOOL inFooterOfSiteDetail;
@property (strong, nonatomic) M2MImagesCollectionViewController *delegate;

@end
