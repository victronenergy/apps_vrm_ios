//
//  M2MImagesCollectionViewCell.h
//  VictronEnergy
//
//  Created by Lime on 03/06/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>
#import "M2MImagesCollectionViewController.h"

@interface M2MImagesCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@property (nonatomic) CGFloat lastZoomScale;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, assign) BOOL inFooterOfSiteDetail;

@property (strong, nonatomic) M2MImagesCollectionViewController *imagesCollectionViewController;

- (void)setImageWithImageUrl:(NSString *)imageUrl siteID:(NSInteger)siteID inFooterOfSiteDetail:(BOOL)inFooterOfSiteDetail;

-(void)setBorderForImageView;

@end
