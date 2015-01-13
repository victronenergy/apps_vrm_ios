//
//  LoginViewController.m
//  Victron Energy
//
//  Created by Victron Energy on 3/4/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "LoginViewController.h"
#import "SiteListTableViewController.h"
#import "SitesScrollViewController.h"
#import "Data.h"
#import "KeychainItemWrapper.h"
#import "SVWebViewController.h"
#import "Tools.h"

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

    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];

    if ([password length] != 0 && [username length] != 0) {

        NSDate *startLogin = [NSDate date];

        [self.view setUserInteractionEnabled:NO];

        self.emailTextField.text = username;
        self.passwordTextField.text = password;

        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setValue:username forKey:kM2MWebServiceUsername];
        [postDict setValue:password forKey:kM2MWebServicePassword];
        [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
        [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];

        [SVProgressHUD show];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [SVProgressHUD dismiss];

            UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
            if (alert) {
                [alert show];
            } else {

                NSDate *finishLogin = [NSDate date];
                NSTimeInterval executionTime = [finishLogin timeIntervalSinceDate:startLogin];
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

                [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:GA_EVENT_CATEGORY_WEBSERVICE
                                                                    interval:[NSNumber numberWithDouble:executionTime]
                                                                        name:GA_WITH_NAME_LOGIN
                                                                       label:@"splash"] build]];

                [Data sharedData].sessionId= [[[responseObject objectForKey:kM2MResponseData] objectForKey:kM2MResponseUser] objectForKey:kM2MResponseSessionId];
                [Data sharedData].username = self.emailTextField.text;
                [Data sharedData].password = self.passwordTextField.text;

                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
                [keychainItem setObject: self.passwordTextField.text forKey:(__bridge id)(kSecValueData)];
                [keychainItem setObject: self.emailTextField.text forKey:(__bridge id)(kSecAttrAccount)];

                self.emailTextField.text = nil;
                self.passwordTextField.text = nil;

                [self.view setUserInteractionEnabled:YES];

                [Data sharedData].userIsLoggedIn = YES;
                [self dismissLoginView];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];

            UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

            if (alert) {
                [alert show];
            }
            [self.view setUserInteractionEnabled:YES];
        }];
    }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_full.png"]];
        self.navigationItem.hidesBackButton = YES;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (IBAction)forgotPasswordButtonPressed:(id)sender {
    if ([Tools validateEmail:self.emailTextField.text]) {
        NSString *fullURL = [NSString stringWithFormat:@"https://vrm.victronenergy.com/user/reset-password-request/email/%@" ,self.emailTextField.text];

        NSURL *url = [NSURL URLWithString:fullURL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];

        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURLRequest:request];
        [self.navigationController pushViewController:webViewController animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"no_email_title", @"no_email_title")
                              message:NSLocalizedString(@"no_email_message", @"no_email_message")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)demoButtonPressed:(id)sender {

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_BUTTON_PRESS
                                                           label:@"demo_button"
                                                           value:nil] build]];



    NSDate *startLogin = [NSDate date];

    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:LOGIN_DEMO_EMAIL forKey:kM2MWebServiceUsername];
    [postDict setValue:LOGIN_DEMO_PASSWORD forKey:kM2MWebServicePassword];
    [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];

    [SVProgressHUD show];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];

        UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
        if (alert) {
            [alert show];
        } else {
            NSDate *finishLogin = [NSDate date];
            NSTimeInterval executionTime = [finishLogin timeIntervalSinceDate:startLogin];
            NSNumber *executionTimeNumber = [NSNumber numberWithDouble:executionTime];

            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

            [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:GA_EVENT_CATEGORY_WEBSERVICE
                                                                 interval:executionTimeNumber
                                                                     name:GA_WITH_NAME_LOGIN
                                                                    label:@"login"] build]];

            [Data sharedData].sessionId= [[[responseObject objectForKey:kM2MResponseData] objectForKey:kM2MResponseUser] objectForKey:kM2MResponseSessionId];
            [Data sharedData].username = LOGIN_DEMO_EMAIL;
            [Data sharedData].password = LOGIN_DEMO_PASSWORD;
            [Data sharedData].userIsDemoUser = YES;

            KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
            [keychainItem setObject: LOGIN_DEMO forKey:(__bridge id)(kSecAttrAccount)];

            self.emailTextField.text = nil;
            self.passwordTextField.text = nil;

            [Data sharedData].userIsLoggedIn = YES;

            [self dismissLoginView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD dismiss];

        UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

        if (alert) {
            [alert show];
        }
        [self.view setUserInteractionEnabled:YES];
    }];

}

- (IBAction)loginButtonPressed:(id)sender {

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_BUTTON_PRESS
                                                           label:@"login_button"
                                                           value:nil] build]];
    if (![Tools validateEmail:self.emailTextField.text]) {

        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"error_title", @"error_title")
                              message:NSLocalizedString(@"no_email_message", @"no_email_message")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
                              otherButtonTitles:nil];
        [alert show];
    }else if ([self.passwordTextField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"error_title", @"error_title")
                              message:NSLocalizedString(@"no_password_message", @"no_password_message")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
                              otherButtonTitles:nil];
        [alert show];
    }else{
        NSDate *startLogin = [NSDate date];

        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setValue:self.emailTextField.text forKey:kM2MWebServiceUsername];
        [postDict setValue:self.passwordTextField.text forKey:kM2MWebServicePassword];
        [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
        [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];

        [SVProgressHUD show];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [SVProgressHUD dismiss];

            UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
            if (alert) {
                [alert show];
            } else {
                NSDate *finishLogin = [NSDate date];
                NSTimeInterval executionTime = [finishLogin timeIntervalSinceDate:startLogin];
                NSNumber *executionTimeNumber = [NSNumber numberWithDouble:executionTime];

                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

                [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:GA_EVENT_CATEGORY_WEBSERVICE
                                                                    interval:executionTimeNumber
                                                                        name:GA_WITH_NAME_LOGIN
                                                                       label:@"login"] build]];


                [Data sharedData].sessionId= [[[responseObject objectForKey:kM2MResponseData] objectForKey:kM2MResponseUser] objectForKey:kM2MResponseSessionId];

                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEY_CHAIN_IDENTIFIER accessGroup:nil];
                [keychainItem setObject: self.passwordTextField.text forKey:(__bridge id)(kSecValueData)];
                [keychainItem setObject: self.emailTextField.text forKey:(__bridge id)(kSecAttrAccount)];

                self.emailTextField.text = nil;
                self.passwordTextField.text = nil;

                [Data sharedData].userIsLoggedIn = YES;

                [self dismissLoginView];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];

            UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

            if (alert) {
                [alert show];
            }
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
