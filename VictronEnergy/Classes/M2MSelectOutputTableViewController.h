//
//  M2MSelectOutputTableViewController.h
//  VictronEnergy
//
//  Created by Lime on 02/04/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsDetailTableViewController.h"

@interface M2MSelectOutputTableViewController : UITableViewController
@property (weak, nonatomic) UIPopoverController *popoverDelegate;
@property (weak, nonatomic) SettingsDetailTableViewController *delegate;
@property (nonatomic, assign) NSInteger selectedOutput;
@property (strong, nonatomic) NSString *selectedOutputName;
@property (strong, nonatomic) NSArray *outputsArray;
@end
