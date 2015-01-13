//
//  ExtenderDetailViewController.h
//  VictronEnergy
//
//  Created by Victron Energy on 4/9/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtenderInfo.h"
#import "SiteInfo.h"
#import <MessageUI/MessageUI.h>

@interface ExtenderDetailViewController : GAITrackedViewController <UIImagePickerControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *extenderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundBorderImageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIImageView *detailBackgroundImageView;

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) NSData *pngData;

@property (strong, nonatomic) ExtenderInfo *selectedExtender;
@property (strong, nonatomic) SiteInfo  *selectedSite;
@property (weak, nonatomic) NSString *phoneNumber;
@property (weak, nonatomic) NSString *smsOutput;

@property (assign, nonatomic) BOOL isNameChanged;
@property (assign, nonatomic) BOOL isPhotoChanged;

@property (weak, nonatomic) IBOutlet UIButton *updateImageButton;

- (void)saveExtender:(id)sender;

@end
