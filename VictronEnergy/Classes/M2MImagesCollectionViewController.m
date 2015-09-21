//
//  M2MImagesCollectionViewController.m
//  VictronEnergy
//
//  Created by Lime on 04/06/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MImagesCollectionViewController.h"
#import "M2MImagesCollectionViewDataSource.h"
#import "Data.h"
#import "M2MLoginService.h"
#import "M2MSiteService.h"
#import "M2MSiteInfoService.h"

@interface M2MImagesCollectionViewController ()

@property (nonatomic, assign) BOOL toolBarsAreHidden;

@property (strong, nonatomic) M2MImagesCollectionViewDataSource *collectionViewDataSource;

@end

@implementation M2MImagesCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.collectionView.dataSource = self.collectionViewDataSource;
    self.collectionViewDataSource.delegate = self;

    [self updateTitleText];

    if (!self.selectedSite.canEditSite) {
        [self.bottomToolBar setHidden:YES];
    }
}

-(void)setDataSource:(id)dataSource
{
    M2MImagesCollectionViewDataSource *viewDataSource = dataSource;
    viewDataSource.inFooterOfSiteDetail = NO;
    self.collectionViewDataSource = viewDataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTitleText
{
    [self setTitle:[NSString stringWithFormat:@"%i of %i", self.currentIndex + 1, [self.selectedSite.imageURLS count]]];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self removeViewControllerAndChangeSettings];
}

- (IBAction)deleteImageButtonPressed:(id)sender {

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:NSLocalizedString(@"delete_image", @"delete_image")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"alert_No", @"No")
                                            otherButtonTitles:NSLocalizedString(@"alert_Yes", @"Yes"), nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteImage];
    }
}

-(void)removeViewControllerAndChangeSettings{
    self.collectionViewDataSource.inFooterOfSiteDetail = YES;

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)deleteImage{

    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:[M2MLoginService sharedInstance].currentSessionId forKey:kM2MWebServiceSessionId];
    [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];
    [postDict setValue:[NSNumber numberWithInteger:self.selectedSite.siteID] forKey:kM2MWebServiceSiteId];
    [postDict setValue:self.selectedSite.imageURLS[self.currentIndex] forKey:kM2MWebServiceImagesName];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    __weak typeof(self)weakSelf = self;
    [manager POST:URL_SERVER_IMAGE_DELETE parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [weakSelf reloadSite];
        if(weakSelf.onImageDelete){
            weakSelf.onImageDelete();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD dismiss];

        [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
    }];
}

-(void)reloadSite
{
    __weak typeof(self)weakSelf = self;

    [[M2MSiteInfoService new] getSiteWithID:self.selectedSite.siteID success:^(SiteInfo *site) {
        weakSelf.selectedSite = site;
        weakSelf.collectionViewDataSource.selectedSite = site;
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView layoutIfNeeded];

        if (![weakSelf.collectionViewDataSource.selectedSite.imageURLS count]) {
            [weakSelf removeViewControllerAndChangeSettings];
        } else {
            weakSelf.currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
            [weakSelf updateTitleText];
        }

    } failure:^(NSInteger statusCode) {
        [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:statusCode];
    }];
}

-(void)changeStyleToFullScreenOrSmallScreen
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         if (self.toolBarsAreHidden) {
                             if (self.selectedSite.canEditSite) {
                                 [self.bottomToolBar setHidden:NO];
                             }
                             [self.navigationController setNavigationBarHidden:NO animated:YES];
                             self.toolBarsAreHidden = NO;
                             self.collectionView.backgroundColor = [UIColor whiteColor];
                         } else {
                             [self.bottomToolBar setHidden:YES];
                             [self.navigationController setNavigationBarHidden:YES animated:YES];
                             self.toolBarsAreHidden = YES;
                             self.collectionView.backgroundColor = [UIColor blackColor];
                         }
                     } completion:nil];

    [[UIApplication sharedApplication] setStatusBarHidden:self.toolBarsAreHidden withAnimation:UIStatusBarAnimationNone];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return self.toolBarsAreHidden;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    [self updateTitleText];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UIDeviceOrientationIsLandscape(fromInterfaceOrientation)) {
        [self.collectionView setContentOffset:CGPointMake(([[UIScreen mainScreen] applicationFrame].size.width ) * self.currentIndex, 0)];
    } else {
        [self.collectionView setContentOffset:CGPointMake(([[UIScreen mainScreen] applicationFrame].size.height ) * self.currentIndex, 0)];
    }

    [self.collectionView reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width * self.currentIndex, 0)];

    return CGSizeMake((collectionView.frame.size.width ), (collectionView.frame.size.height ));
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{

    return YES;
}

@end
