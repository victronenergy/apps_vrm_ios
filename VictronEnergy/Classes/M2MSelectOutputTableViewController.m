//
//  M2MSelectOutputTableViewController.m
//  VictronEnergy
//
//  Created by Victron Energy on 02/04/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import "M2MSelectOutputTableViewController.h"
#import "M2MSelectOutputCell.h"
#import "SettingsDetailTableViewController.h"
#import "ExtenderInfo.h"

@interface M2MSelectOutputTableViewController ()

@end

@implementation M2MSelectOutputTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"select_output_title", @"select_output_title");
    self.tableView.backgroundColor = COLOR_BACKGROUND;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    M2MSelectOutputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"M2MSelectOutputCell" forIndexPath:indexPath];
    ExtenderInfo *extender = self.outputsArray[indexPath.row];
    cell.outputLabel.text = extender.label;

    // If a user has never selected an output selectedOutputName is empty, @""
    if ([self.selectedOutputName length] && self.selectedOutput == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //Get a reference to the previous viewController
        SettingsDetailTableViewController *controller = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];

        [controller setSelectedOutputWithOutputIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];

    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.delegate setSelectedOutputWithOutputIndex:indexPath.row];
        [self.popoverDelegate dismissPopoverAnimated:YES];
    }
}

@end
