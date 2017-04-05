//
//  AppDelegate.m
//  Victron Energy
//
//  Created by Thijs on 3/5/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "AppDelegate.h"
#import "SiteListTableViewController.h"
#import "SitesScrollViewController.h"
#import "SiteDetailViewController.h"
#import "GAI.h"
#import "NSDate+TimeAgo.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "SVWebViewController.h"
#import "M2MCredentials.h"
#import "M2MCredentialsStorage.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    // Override point for customization after application launch.

    [[UINavigationBar appearance]setBarTintColor:COLOR_NAV_BAR];
    [[UINavigationBar appearance]setTintColor:COLOR_DARK_GREY];
    
    self.globalEmail = [[NSMutableString alloc] init];
    self.token = [[NSMutableString alloc] init];
    self.token = @"";

    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-36047521-1"];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];


    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                          NSForegroundColorAttributeName: BACK_BUTTON_TEXT_COLOR,
                                                          NSFontAttributeName: BACK_BUTTON_TEXT_FONT
                                                          } forState:UIControlStateNormal];

    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: LABEL_HEADERS_TEXT_COLOR,
                                                            NSFontAttributeName: LABEL_HEADERS_TEXT_FONT}];

    // Setup splitview controller:
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers firstObject];
        SiteListTableViewController *mvc = (SiteListTableViewController *)navigationController.topViewController;
        splitViewController.delegate = mvc.detailViewManager;
        mvc.detailViewManager.splitViewController = splitViewController;
        mvc.detailViewManager.navigationController.navigationBar.translucent = NO;
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    UIBackgroundTaskIdentifier backgroundIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void) {
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getToken:(NSString*)username password:(NSString*)password web:(SVWebViewController *) webview redirect:(NSString*)path controller:(UIViewController *)view site:(NSInteger *)siteId{
    self.controller = view;
    self.selectedSiteId = siteId;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.controller.view addSubview:self.activityIndicator];
    [self.activityIndicator setHidden:FALSE];
    [self.activityIndicator startAnimating];
    
    NSLog(@"TOKEN: %@", [self userToken]);
    if ([self userToken] != (id)[NSNull null] && [self userToken].length > 0) {
        NSLog(@"Token is set, generate auth token");
        [self generateToken:[self userToken] web:webview];
    } else {
        NSLog(@"Token is empty, get a user token");
        [self requestToken:username password:password web:webview redirect:path];
    }
}

- (void)requestToken:(NSString*)username password:(NSString*)password web:(SVWebViewController *) webview redirect:(NSString*)path{
    
    NSLog(@"Token request %@ %@", username, password);
    
    //Check if user token is present. If it is -> generate token and load webview
    //If not -> Get a user token, generate token and load webview
    
    if (self.userToken == (id)[NSNull null] || self.userToken.length == 0 ) {
        //The user doesn't have a user token, fetch one from the api
        NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
        [requestParameters setValue:username forKey:@"username"];
        [requestParameters setValue:password forKey:@"password"];
        
        NSLog(@"Token params: %@", requestParameters);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:WEBVIEW_URL_LOGIN_REQUEST parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //TODO: Test API and see if this alert is really needed in the success block
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Weird array response");
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                
                NSLog(@"%@", responseDict);
                
                if ((int)[responseDict valueForKey:@"verification_sent"]) {
                    NSLog(@"Two factor auth is enabled");
                    [self showTwoFactorDialog:username password:password web:webview redirect:path];
                } else if ([responseDict valueForKey:@"token"] != (id)[NSNull null]) {
                    NSLog(@"Successful login");
//
                    [self storeUserEmail:username];
//
                    NSString *token = [responseDict valueForKey:@"token"];
//                    [webview setToken:token redirect:path];
                    self.userToken = token;
                    NSLog(@"Received User Token: %@", token);
                    
                    //Generate a sign in token
                    [self generateToken:self.userToken web:webview];
                } else {
                    NSString *urlstring = [NSString stringWithFormat:@"https://vrm.victronenergy.com/login"];
                    NSLog(@"Got null token and no verification sent. SMS credits are empty?: %@", urlstring);
                    NSURL *url = [NSURL URLWithString:urlstring];
                    [webview loadURL:url];
                    
                    [self.activityIndicator stopAnimating];
                    [self.activityIndicator setHidden:TRUE];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Token Request Failed: %@", error);
            
            NSString *urlstring = [NSString stringWithFormat:@"https://vrm.victronenergy.com/login"];
            NSLog(@"Failure: %@", urlstring);
            NSURL *url = [NSURL URLWithString:urlstring];
            [webview loadURL:url];
            
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:TRUE];
        }];
    } else {
        //The user already has a token. Generate sign in token and redirect the webview
        [self generateToken:self.userToken web:webview];
    }
}

- (void)generateToken:(NSString *)token web:(SVWebViewController *) webview {
    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *string = @"Bearer ";
    NSMutableString *authString = [string mutableCopy];
    [authString appendString:token];
    
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"X-Authorization"];
    
    [manager GET:GENERATE_TOKEN_URL parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //TODO: Test API and see if this alert is really needed in the success block
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSLog(@"Weird array response");
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = responseObject;
            
            if ([responseDict valueForKey:@"verification_sent"]) {
                NSLog(@"Two factor auth is enabled");
//                [self showTwoFactorDialog:username password:password web:webview redirect:path];
            } else {
                NSLog(@"Successful login");
                //
//                [self storeUserEmail:username];
                //
                NSString *t = [responseDict valueForKey:@"token"];
                //                    [webview setToken:token redirect:path];
//                self.token = t;
                NSLog(@"Received Generated Token: %@", t);
                
                NSString *urlstring = [NSString stringWithFormat:@"https://vrm.victronenergy.com/login?token=%@&redirect=/installation/%ld/dashboard", t, (long)self.selectedSiteId];
                
                NSLog(@"Website Url: %@", urlstring);
                
                NSURL *url = [NSURL URLWithString:urlstring];
                [webview loadURL:url];
                
                [self.activityIndicator stopAnimating];
                [self.activityIndicator setHidden:TRUE];
                
                //Generate a sign in token
//                [self generateToken:self.userToken web:webview];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Token Request Failed: %@", error);
        
        NSString *urlstring = [NSString stringWithFormat:@"https://vrm.victronenergy.com/login"];
        NSLog(@"Failure: %@", urlstring);
        NSURL *url = [NSURL URLWithString:urlstring];
        [webview loadURL:url];
        
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:TRUE];
    }];
}

- (void)requestTwoFactorToken:(NSString *)username password:(NSString *)password code:(NSString *)code web:(SVWebViewController *) webview redirect:(NSString*)path{
    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
    [requestParameters setValue:username forKey:@"username"];
    [requestParameters setValue:password forKey:@"password"];
    [requestParameters setValue:code forKey:@"sms_token"];
    
    NSLog(@"Token params: %@", requestParameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:WEBVIEW_URL_LOGIN_REQUEST parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //TODO: Test API and see if this alert is really needed in the success block
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSLog(@"Weird array response");
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = responseObject;
            
            if ([responseDict valueForKey:@"verification_sent"] || [responseDict valueForKey:@"token"] == (id)[NSNull null]) {
                NSLog(@"Two factor auth is enabled");
                [self showTwoFactorDialog:username password:password web:webview redirect:path];
            } else {
                NSLog(@"Successful login");
                
                [self storeUserEmail:username];
                
                NSString *t = [responseDict valueForKey:@"token"];
//                [webview setToken:t redirect:path];
                self.userToken = t;
                NSLog(@"Received Token: %@", t);
                
                [self generateToken:t web:webview];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Token Request Failed: %@", error);
        
        NSString *urlstring = [NSString stringWithFormat:@"https://vrm.victronenergy.com/login"];
        NSLog(@"Failure: %@", urlstring);
        NSURL *url = [NSURL URLWithString:urlstring];
        [webview loadURL:url];
        
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:TRUE];
    }];
}

- (void)storeUserEmail:(NSString *)email {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.globalEmail = email;
}

- (void)showTwoFactorDialog:(NSString *)username password:(NSString *)password web:(SVWebViewController *) webview redirect:(NSString*)path{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Verification"
                                                                              message: @"Enter the code sent to you via SMS in the field below"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Verification Code";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * textfield = textfields[0];
        
        NSString *code = textfield.text;
        
        if (![code  isEqual: @""]) {
            //Try to get a user token with the entered sms code
            [self requestTwoFactorToken:username password:password code:code web:webview redirect:path];
        } else {
            //No sms code given in, just show them a sign in page
            NSString *urlstring = [NSString stringWithFormat:@"https://vrm.victronenergy.com/login"];
            NSLog(@"CANCEL SMS token, show login page: %@", urlstring);
            NSURL *url = [NSURL URLWithString:urlstring];
            [webview loadURL:url];
            [self.controller dismissViewControllerAnimated:YES completion:nil];
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:TRUE];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //Canceled sms token dialog, show a login page
        NSString *urlstring = [NSString stringWithFormat:@"https://vrm.victronenergy.com/login"];
        NSLog(@"CANCEL SMS token, show login page: %@", urlstring);
        NSURL *url = [NSURL URLWithString:urlstring];
        [webview loadURL:url];
        [self.controller dismissViewControllerAnimated:YES completion:nil];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:TRUE];
    }]];
    [self.controller presentViewController:alertController animated:YES completion:nil];
}

@end
