//
//  LoginViewController.m
//  Victron Energy
//
//  Created by Thijs on 3/4/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "LoginViewController.h"
#import "SiteListTableViewController.h"
#import "SitesScrollViewController.h"
#import "Data.h"
#import "KeychainItemWrapper.h"
#import "SVWebViewController.h"
#import "Tools.h"
#import "M2MLoginService.h"
#import "M2MCredentials.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Login";
    self.view.backgroundColor = COLOR_BACKGROUND;

    self.headerBackground.image = [[UIImage imageNamed:@"heading_corner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kHeaderInsetImageTop, kHeaderInsetImageLeft, kHeaderInsetImageBottom, kHeaderInsetImageRight)];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [Tools style:LabelStyleLoginTitle forLabel:self.loginLabel];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [Tools style:LabelStyleLoginTitleiPad forLabel:self.loginLabel];
    }


    [Tools style:LabelStyleLookInside forLabel:self.lookinsideLabel];

    [Tools style:TextfieldStyleNormal forTextfield:self.emailTextField];
    [Tools style:TextfieldStyleNormal forTextfield:self.passwordTextField];

    [Tools style:ButtonStyleForgotPassword forButton:self.forgotPasswordButton];
    self.backgroundFrame.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundFrame.layer.borderWidth = 1;

    [self.forgotPasswordButton setTitle: NSLocalizedString(@"forgot_password_button", @"forgot_password_button") forState:normal];

    [Tools style:ButtonStyleNormal forButton:self.loginButton];
    [self.loginButton setTitle: NSLocalizedString(@"login_button", @"login_button") forState:normal];

    [Tools style:ButtonStyleNormal forButton:self.demoButton];
    [self.demoButton setTitle: NSLocalizedString(@"demo_button", @"demo_button") forState:normal];

    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGesture.numberOfTapsRequired = 1;
    self.tapGesture.delegate = self;
    [self.view addGestureRecognizer:self.tapGesture];
    self.tapGesture.enabled = NO;
    self.navigationItem.backBarButtonItem.title = NSLocalizedString(@"back_button_title", @"back_button_title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];



    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_full.png"]];
        self.navigationItem.hidesBackButton = YES;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (IBAction)forgotPasswordButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://vrm.victronenergy.com/forgot-password"]];
//    if ([Tools validateEmail:self.emailTextField.text]) {
//        NSString *fullURL = [NSString stringWithFormat:@"https://acceptancevrm.victronenergy.com/forgot-password" ,self.emailTextField.text];
//
//        NSURL *url = [NSURL URLWithString:fullURL];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
//
//        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURLRequest:request];
//        [self.navigationController pushViewController:webViewController animated:YES];
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:NSLocalizedString(@"no_email_title", @"no_email_title")
//                              message:NSLocalizedString(@"no_email_message", @"no_email_message")
//                              delegate:self
//                              cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
//                              otherButtonTitles:nil];
//        [alert show];
//    }
}

- (IBAction)demoButtonPressed:(id)sender {

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_BUTTON_PRESS
                                                           label:@"demo_button"
                                                           value:nil] build]];

    [self loginWithUsername:LOGIN_DEMO_EMAIL password:LOGIN_DEMO_PASSWORD];

}

- (IBAction)loginButtonPressed:(id)sender {

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_BUTTON_PRESS
                                                           label:@"login_button"
                                                           value:nil] build]];

    [self loginWithUsername:self.emailTextField.text password:self.passwordTextField.text];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    if (![Tools validateEmail:username]) {

        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"error_title", @"error_title")
                              message:NSLocalizedString(@"no_email_message", @"no_email_message")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
                              otherButtonTitles:nil];
        [alert show];
    }else if ([password isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"error_title", @"error_title")
                              message:NSLocalizedString(@"no_password_message", @"no_password_message")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
                              otherButtonTitles:nil];
        [alert show];
    }else{

        M2MLoginService *loginService = [M2MLoginService sharedInstance];
        M2MCredentials *credentials = [M2MCredentials new];
        credentials.username = username;
        credentials.password = password;

        [SVProgressHUD show];
        [loginService loginWithCredentials:credentials success:^(NSInteger statusCode){
            [SVProgressHUD dismiss];
            UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:statusCode];
            if (!alert) {
                self.emailTextField.text = nil;
                self.passwordTextField.text = nil;
                [self dismissLoginView];
            }
        } failure:^(NSInteger statusCode){
            [SVProgressHUD dismiss];

            [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:statusCode];
            [self.view setUserInteractionEnabled:YES];
        }];
    }
}

/** Dismisses the login view, and when on iPad in portrait mode, also shows the master view popover.
 *  Note that in landscape mode the master view is shown by default. */
- (void)dismissLoginView {
    // iPad - in portrait mode we want to show the master view popover after login.
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) &&
        UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        // Obtain a reference to the master view
        SiteListTableViewController *siteListTableViewController = (SiteListTableViewController *)[[((UISplitViewController *)self.presentingViewController).viewControllers firstObject] topViewController];
        [self dismissViewControllerAnimated:YES completion:^(void){
            [siteListTableViewController.detailViewManager showMasterPopoverInPortrait];
        }];
    } else { // Either on iPhone, or iPad with orientation landscape: no need to explicitly show the master view.
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.tapGesture.enabled = YES;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        self.view.frame = CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height);
    }else{
        self.view.frame = CGRectMake(0,-64,self.view.frame.size.width,self.view.frame.size.height);
    }

    [UIView commitAnimations];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if ((touch.view == self.loginButton || touch.view == self.demoButton)) {

        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        self.tapGesture.enabled = NO;
        [self moveViewDown];
        return NO;
    }
    return YES;
}
-(void)moveViewDown{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            self.view.frame = CGRectMake(0, 64,self.view.frame.size.width,self.view.frame.size.height);
        }else{
            self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        }
        [UIView commitAnimations];
    }
}

-(void) handleTapGesture:(UIGestureRecognizer *) sender  {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.tapGesture.enabled = NO;
    [self moveViewDown];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self moveViewDown];
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewDidUnload {
    [self setForgotPasswordButton:nil];
    [super viewDidUnload];
}
@end
