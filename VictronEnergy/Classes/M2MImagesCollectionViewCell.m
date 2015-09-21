//
//  M2MImagesCollectionViewCell.m
//  VictronEnergy
//
//  Created by Lime on 03/06/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MImagesCollectionViewCell.h"

@implementation M2MImagesCollectionViewCell

- (void)setImageWithImageUrl:(NSString *)imageUrl siteID:(NSInteger)siteID inFooterOfSiteDetail:(BOOL)inFooterOfSiteDetail
{
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.imageView.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.imageView addSubview:activityIndicator];
    self.inFooterOfSiteDetail = inFooterOfSiteDetail;

    NSString *requestUrl = @"";
    if (self.inFooterOfSiteDetail) {
        [self setBorderForImageView];
        requestUrl = [NSString stringWithFormat:@"%@/%ld/thumb_%@",URL_SERVER_FETCH_IMAGE, (long)siteID, imageUrl];
    } else {
        requestUrl = [NSString stringWithFormat:@"%@/%ld/%@",URL_SERVER_FETCH_IMAGE, (long)siteID, imageUrl];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewTapped:)];
        [self.scrollView addGestureRecognizer:tapGesture];
    }

    [activityIndicator startAnimating];

    // UrlRequest cachepolicy is set to NSURLCacheStorageNotAllowed because afnetworking does the caching. Explanation on the link below
    //http://stackoverflow.com/questions/16997393/memory-warning-in-uicollectionview-with-image
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0f];

    [self.imageView setImageWithURLRequest:urlRequest placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

                                       self.imageView.image = image;
                                       if (!self.inFooterOfSiteDetail && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                           [self updateConstraintsForZoomView];
                                       }
                                       [activityIndicator stopAnimating];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

                                       [activityIndicator stopAnimating];
                                       self.imageView.image = [UIImage imageNamed:@"warning.png"];
                                       if (!self.inFooterOfSiteDetail && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                           [self updateConstraintsForZoomView];
                                       }
                                   }
     ];

    self.backgroundColor = [UIColor clearColor];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (!self.inFooterOfSiteDetail) {
            [self updateZoom];
        }
    } else {
        [self.scrollView setZoomScale:1.0f];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect frame = self.scrollView.frame;
        frame.size.height = self.frame.size.height;
        self.scrollView.frame = frame;
    }
}

-(void)scrollViewTapped:(UITapGestureRecognizer *)gesture
{
    [self.imagesCollectionViewController changeStyleToFullScreenOrSmallScreen];
}

// Update zoom scale and constraints
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {

    if (!self.inFooterOfSiteDetail && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateZoom];
    }
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    if (!self.inFooterOfSiteDetail && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateConstraintsForZoomView];
    }
}

- (void) updateConstraintsForZoomView {

    if (!self.inFooterOfSiteDetail && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        float imageWidth = self.imageView.image.size.width;
        float imageHeight = self.imageView.image.size.height;

        float viewWidth = self.contentView.bounds.size.width;
        float viewHeight = self.contentView.bounds.size.height;

        // center image if it is smaller than screen
        float hPadding = (viewWidth - self.scrollView.zoomScale * imageWidth) / 2;
        if (hPadding < 0){
            hPadding = 0;
        }

        float vPadding = (viewHeight - self.scrollView.zoomScale * imageHeight) / 2;
        if (vPadding < 0){
            vPadding = 0;
        }

        self.constraintLeft.constant = hPadding;
        self.constraintRight.constant = hPadding;

        self.constraintTop.constant = vPadding;
        self.constraintBottom.constant = vPadding;
    }
}

// Zoom to show as much image as possible unless image is smaller than screen
- (void) updateZoom {
    if (!self.inFooterOfSiteDetail && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        float minZoom = MIN(self.contentView.bounds.size.width / self.imageView.image.size.width,
                            self.contentView.bounds.size.height / self.imageView.image.size.height);

        if (minZoom > 1){
            minZoom = 1;
        }

        self.scrollView.minimumZoomScale = minZoom;

        // Force scrollViewDidZoom fire if zoom did not change
        if (minZoom == self.lastZoomScale){
            minZoom += 0.000001;
        }

        self.lastZoomScale = self.scrollView.zoomScale = minZoom;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(void)setBorderForImageView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = COLOR_LINE.CGColor;
}

@end
