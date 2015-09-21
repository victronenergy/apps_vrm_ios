//
//  M2MImagesCollectionViewController.h
//  VictronEnergy
//
//  Created by Lime on 04/06/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteInfo.h"

@interface M2MImagesCollectionViewController : UIViewController <UICollectionViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) SiteInfo *selectedSite;

@property (assign, nonatomic) NSInteger currentIndex;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@property(nonatomic, copy) void (^onImageDelete)();

-(void)changeStyleToFullScreenOrSmallScreen;
-(void)setDataSource:(id)dataSource;

@end
