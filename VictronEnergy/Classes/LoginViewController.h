//
//  LoginViewController.h
//  Victron Energy
//
//  Created by Thijs on 3/4/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : GAITrackedViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookinsideLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *demoButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundFrame;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackground;

@property (weak, nonatomic) NSString *tempSessionId;

@property (nonatomic) UITapGestureRecognizer *tapGesture;

- (IBAction)forgotPasswordButtonPressed:(id)sender;

- (IBAction)demoButtonPressed:(id)sender;

- (IBAction)loginButtonPressed:(id)sender;

@end
