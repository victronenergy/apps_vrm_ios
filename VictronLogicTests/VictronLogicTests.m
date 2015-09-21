//
//  VictronLogicTests.m
//  VictronLogicTests
//
//  Created by Thijs on 3/7/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "VictronLogicTests.h"
#import "SiteListTableViewController.h"

@implementation VictronLogicTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.testLoginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.testLoginViewController performSelectorOnMainThread:@selector(view) withObject:nil waitUntilDone:YES];

//    self.testSiteListTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"SiteListTableViewController"];
//   // [self.testLoginViewController performSelectorOnMainThread:@selector(view) withObject:nil waitUntilDone:YES];
}


- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void) testLoginLabelIsNotNIL
{
    STAssertNotNil(self.testLoginViewController.loginLabel, @"not nil");
}

- (void) testLoginLabelText
{
    NSString *string1 =[NSString stringWithFormat:@"%@",_testLoginViewController.loginLabel.text];
    STAssertEqualObjects(string1, @"Login", @"tekst is Login");
}

- (void) testDemoButtonText
{
    NSString *buttonText =[NSString stringWithFormat:@"%@",_testLoginViewController.demoButton.titleLabel.text];
    STAssertEqualObjects(buttonText, @"Demo", @"tekst is Demo");
}

-(void) testButtonIsPressed
{
    [_testLoginViewController.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];

    //[_testLoginViewController demoButtonPressed:nil];

  //  STAssertNotNil(_testDemoListViewController, @"niet Nil");

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];

    self.testDemoListViewController = [storyboard instantiateViewControllerWithIdentifier:@"DemoListViewController"];

    STAssertNotNil(_testDemoListViewController, @"niet Nil");

}

-(void) testNumberOfSectionsIsEqualTo1
{
    SiteListTableViewController *sltvc = [[SiteListTableViewController alloc]init];
    [sltvc view];
    STAssertEquals([sltvc numberOfSectionsInTableView:nil], 1, @"is gelijk aan 1");

}

-(void) testCellIsNotNil
{
    SiteListTableViewController *sltvc = [[SiteListTableViewController alloc]init];
    [sltvc view];
    //STAssertNotNil([ cell], @"is notnil");
}

@end
