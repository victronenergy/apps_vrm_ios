//
//  VictronLogicTests.h
//  VictronLogicTests
//
//  Created by Thijs on 3/7/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "LoginViewController.h"
#import "SiteListTableViewController.h"
#import "DemoListViewController.h"

@interface VictronLogicTests : SenTestCase

@property (nonatomic, strong) LoginViewController *testLoginViewController;
@property (nonatomic, strong) SiteListTableViewController *testSiteListTableViewController;

@property (nonatomic, strong) DemoListViewController *testDemoListViewController;

@end
