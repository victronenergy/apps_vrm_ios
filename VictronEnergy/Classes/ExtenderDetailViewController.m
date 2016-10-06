//
//  ExtenderDetailViewController.m
//  VictronEnergy
//
//  Created by Thijs on 4/9/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "ExtenderDetailViewController.h"
#import "Data.h"
#import "KeychainItemWrapper.h"
#import "M2MLoginService.h"

@interface ExtenderDetailViewController ()

@end

@implementation ExtenderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"IO";
    self.view.backgroundColor = COLOR_BACKGROUND;

    self.saveButton = [[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                       target:self
                       action:@selector(saveExtender:)];
    self.saveButton.style = UIBarButtonItemStyleBordered;

    self.navigationItem.rightBarButtonItem = nil;
    self.extenderImageView.userInteractionEnabled = YES;

    self.detailBackgroundImageView.layer.borderColor = [COLOR_LINE CGColor];
    self.detailBackgroundImageView.layer.borderWidth = 1.0f;
    self.detailBackgroundImageView.backgroundColor = COLOR_BACKGROUND;

    self.backgroundBorderImageView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderImageView.layer.borderWidth = 1.0f;

    [Tools style:ButtonStyleNormal forButton:self.cameraButton];
    [Tools style:TextfieldStyleNormal forTextfield:self.nameTextfield];

    self.nameTextfield.returnKeyType = UIReturnKeyDone;
    self.nameTextfield.delegate = self;

    self.isNameChanged = NO;
    self.isPhotoChanged = NO;

    NSString *imageName = [NSString stringWithFormat:@"%ld%@",(long)self.selectedSite.siteID, self.selectedExtender.code];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName];
    self.pngData = [NSData dataWithContentsOfFile:filePath];
    self.extenderImageView.image = [UIImage imageWithData:self.pngData];

    [self setNameTextfieldAndScreenTitle];
}

-(void)setNameTextfieldAndScreenTitle {
    self.nameTextfield.text = self.selectedExtender.label;

    if ([self.selectedExtender.code isEqualToString: EXTENDER_OUTPUT_1] || [self.selectedExtender.code isEqualToString: EXTENDER_OUTPUT_2]) {

        self.title = NSLocalizedString(@"output_title", @"output_title");
    }
    else if ([self.selectedExtender.code isEqualToString: EXTENDER_TEMPERATURE_1]){
        self.title = NSLocalizedString(@"temperature_title", @"temperature_title");
    }
    else if ([[self.selectedExtender.code substringToIndex:2] isEqualToString: EXTENDER_INPUT]){
        self.title = NSLocalizedString(@"input_title", @"input_title");
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self getPhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];            break;
        case 1:
            [self getPhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary]; break;
        default:
            break;
    }
}

-(void)getPhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType{

    if([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.allowsEditing = YES;

        [picker.navigationBar setBarTintColor:COLOR_NAV_BAR];

        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    self.isPhotoChanged = YES;
    [self checkIfPhotoOrNameIsChangedToShowSaveButton];

    self.extenderImageView.image = image;

    self.pngData = UIImagePNGRepresentation(image);

    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    // Check if there is already an image, if not then we set isPhotoChanged to NO
    if (!self.pngData) {
        self.isPhotoChanged = NO;
    }

    [self checkIfPhotoOrNameIsChangedToShowSaveButton];

    [picker dismissViewControllerAnimated:YES completion:Nil];
}

-(void)saveExtender:(id)sender
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_BUTTON_PRESS
                                                           label:@"io_back_button"
                                                           value:nil] build]];

    NSString *imageName = [NSString stringWithFormat:@"%ld%@",(long)self.selectedSite.siteID, self.selectedExtender.code];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName]; //Add the file name
    [self.pngData writeToFile:filePath atomically:YES]; //Write the file

    self.isPhotoChanged = NO;

    // If name is also changed we have send the new name, if not we pop the view
    if (self.isNameChanged){
        [self saveExtenderName];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

    [self checkIfPhotoOrNameIsChangedToShowSaveButton];
}

- (void) saveExtenderName
{
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:[M2MLoginService sharedInstance].currentSessionId forKey:kM2MWebServiceSessionId];
    [postDict setValue:@"1" forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:[NSNumber numberWithInteger:self.selectedSite.siteID] forKey:kM2MWebServiceSiteId];
    [postDict setValue:[NSNumber numberWithInteger:self.selectedExtender.dataAtributeID] forKey:kM2MWebServiceAttributeID];
    [postDict setValue:self.nameTextfield.text forKey:kM2MWebServiceLabel];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];

    [SVProgressHUD show];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URL_SERVER_SITES_SET_LABEL parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];

        self.isNameChanged = NO;
        [self checkIfPhotoOrNameIsChangedToShowSaveButton];

        [self.nameTextfield resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 403) {
            // Temporary added, When Matthijs made a decision this will be changed
            [SVProgressHUD dismiss];
            NSString *kM2MErrorTitle = @"Error!";
            NSString *kM2MErrorMessage = @"There has been a connection issue";
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:kM2MErrorTitle message:kM2MErrorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [theAlert show];

        } else if (operation.response.statusCode == RETURN_CODE_SESSION_EXPIRED) {
            NSMutableDictionary *postDict = [Tools setPostDict];

            [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [SVProgressHUD dismiss];
                [M2MLoginService sharedInstance].currentSessionId = [responseObject objectForKey:KEY_SESSION_ID];
                [self saveExtenderName];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [SVProgressHUD dismiss];

                [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
            }];
        } else {
            [SVProgressHUD dismiss];

            [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
        }
    }];
}
- (IBAction)updateImageButtonPressed:(id)sender {

    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:NSLocalizedString(@"photo_picker_menu_close_button", @"photo_picker_menu_close_button")
                   destructiveButtonTitle:nil
                        otherButtonTitles:NSLocalizedString(@"take_photo_button_title", @"take_photo_button_title"), NSLocalizedString(@"photo_library_button_title", @"photo_library_button_title"), nil]
     showInView:self.view];
}

- (IBAction)textFieldTextDidChange:(id)sender {
    if ([self.nameTextfield.text isEqualToString:self.selectedExtender.label]) {
        self.isNameChanged = NO;
    } else {
        self.isNameChanged = YES;
    }

    [self checkIfPhotoOrNameIsChangedToShowSaveButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

- (void)checkIfPhotoOrNameIsChangedToShowSaveButton {
    if (self.isNameChanged || self.isPhotoChanged) {
        self.navigationItem.rightBarButtonItem = self.saveButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setNameTextfield:nil];
    [self setExtenderImageView:nil];
    [super viewDidUnload];
}

@end
