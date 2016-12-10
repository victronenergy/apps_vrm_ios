//
//  AppDelegate.h
//  Victron Energy
//
//  Created by Thijs on 3/5/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVWebViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableString *globalEmail;
@property (strong, nonatomic) NSMutableString *token;

@property (strong, nonatomic) UIViewController *controller;

- (void)requestTwoFactorToken:(NSString *)username password:(NSString *)password code:(NSString *)code web:(SVWebViewController *) webview redirect:(NSString*)path;
- (void)requestToken:(NSString*)username password:(NSString*)password web:(SVWebViewController *) webview redirect:(NSString*)path;
- (void)storeUserEmail:(NSString *)email;
- (void)showTwoFactorDialog:(NSString *)username password:(NSString *)password web:(SVWebViewController *) webview;
- (void)getToken:(NSString*)username password:(NSString*)password web:(SVWebViewController *) webview redirect:(NSString*)path controller:(UIViewController*)view;
@end
