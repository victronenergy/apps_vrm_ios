//
//  SettingsDetailTableViewController.m
//  VictronEnergy
//
//  Created by Thijs on 4/12/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "SettingsDetailTableViewController.h"
#import "ExtenderCell.h"
#import "OutputExtenderCell.h"
#import "TemperatureExtenderCell.h"
#import "InputExtenderCell.h"
#import "SettingsCell.h"
#import "SettingsHeaderCell.h"
#import "ExtenderInfo.h"
#import "Data.h"
#import "ExtenderDetailViewController.h"
#import "SiteDetailViewController.h"
#import "SitesScrollViewController.h"
#import "M2MSelectOutputTableViewController.h"
#import "M2MLoginService.h"
#import "M2MExtendersService.h"


@interface SettingsDetailTableViewController ()

@end

@implementation SettingsDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // Set the screen name on the tracker so that it is used in all hits sent from this screen.
    [tracker set:kGAIScreenName value:@"SettingsSite"];

    // Send a screenview.
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];


    self.tableView.backgroundColor = COLOR_BACKGROUND;

    self.navigationItem.title = NSLocalizedString(@"detailSettingsView_title", @"detailSettingsView_title");
    self.navigationItem.backBarButtonItem.title = NSLocalizedString(@"back_button_title", @"back_button_title");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.siteSettingsDict = [[NSMutableDictionary alloc]init];
    self.siteSettingsList = [NSMutableArray arrayWithArray:[defaults arrayForKey:KEY_SITE_SETTINGSLIST]];

    self.siteAlreadyExists = NO;

    self.selectedOutput = @"";
    self.outputIndexpath = [NSNumber numberWithInt:0];
    self.generatorState = 0;

    for (id siteDictionary in self.siteSettingsList) {

        if ([[siteDictionary objectForKey:KEY_SELECTED_SITE_ID] isEqualToNumber:[NSNumber numberWithInteger: self.selectedSite.siteID]])
        {
            self.outputIndexpath = [siteDictionary objectForKey:KEY_OUTPUT_INDEXPATH];
            self.generatorState = [[siteDictionary objectForKey:KEY_GENERATOR_STATE]intValue];
            ExtenderInfo *extender = [self.outputList objectAtIndex:[self.outputIndexpath integerValue]];
            self.selectedOutput = extender.label;
            self.siteAlreadyExists = YES;
        }
    }

    self.tableView.userInteractionEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated{

    if (self.selectedSite.hasIOExtender == 1) {
        [self getExtenders];
    }
}

-(void)getExtenders
{
    __weak SettingsDetailTableViewController *weakSelf = self;

    [[M2MExtendersService new] loadExtendersForSite:self.selectedSite.siteID success:^(NSArray *extenders){
        weakSelf.extendersList = [extenders mutableCopy];
        [weakSelf reloadTableView];
    } failure:^(NSInteger statusCode){
        [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:statusCode];
    }];
}

- (void)reloadTableView
{
    self.outputList = [[NSMutableArray alloc] init];

    for (ExtenderInfo *extender in self.extendersList){
        if ([[extender.code substringToIndex:2] isEqualToString:EXTENDER_OUTPUT]) {
            [self.outputList addObject:extender];
        }
    }

    [self.tableView reloadData];

    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    NSInteger tableViewCells = [self.extendersList count] +2;

    // If there are no extenders we only want to show the headerSettingsCell
    if (![self.extendersList count]) {
        tableViewCells = 1;
    }

    // If the site has a generator we also want to show the settingsCell
    if (self.siteHasGenerator == YES) {
        tableViewCells ++;
    }

    return tableViewCells;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If a site has no Generator we show 1 cell less, this index is used to for the right index based on self.siteHasGenerator
    NSInteger cellIndexBasedOnSiteHasGenerator = indexPath.row - self.siteHasGenerator;

    if (indexPath.row == 0) {
        SettingsHeaderCell *cell = (SettingsHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingsHeaderCell"];
        cell.backgroundColor = COLOR_BLUE;
        cell.settingsLabel.text = self.selectedSite.name;
        cell.hasGeneratorSwitch.on = self.siteHasGenerator;
        return cell;

    }else if (indexPath.row == 1 && self.siteHasGenerator) {
        SettingsCell *cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
        [cell setDataWithGeneratorState:self.generatorState andSelectedOutput:self.selectedOutput];
        return cell;

    } else if (cellIndexBasedOnSiteHasGenerator == 1) {
            ExtenderCell *cell = (ExtenderCell *)[tableView dequeueReusableCellWithIdentifier:@"extenderSettingsCell"];
            return cell;
    } else {

        ExtenderInfo *extender = [self.extendersList objectAtIndex:(cellIndexBasedOnSiteHasGenerator - 2)];

        NSString *imageName = [NSString stringWithFormat:@"%ld%@",(long)self.selectedSite.siteID, extender.code];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName];
        NSData *pngData = [NSData dataWithContentsOfFile:filePath];

        if ([extender.code isEqualToString: EXTENDER_INPUT_1] || [extender.code isEqualToString: EXTENDER_INPUT_2] || [extender.code isEqualToString: EXTENDER_INPUT_3]) {
            InputExtenderCell *cell = (InputExtenderCell *)[tableView dequeueReusableCellWithIdentifier:@"settingsInputCell"];
            [cell setDataWithExtender:extender];

            cell.inputImage.image = [UIImage imageWithData:pngData];
            return cell;
        }
        else if ([extender.code isEqualToString: EXTENDER_OUTPUT_1] || [extender.code isEqualToString: EXTENDER_OUTPUT_2]) {
            OutputExtenderCell *cell = (OutputExtenderCell *)[tableView dequeueReusableCellWithIdentifier:@"settingsOutputCell"];
            [cell setDataWithExtender:extender];
            cell.outputImage.image = [UIImage imageWithData:pngData];
            return cell;
        }
        else {
            TemperatureExtenderCell *cell = (TemperatureExtenderCell *)[tableView dequeueReusableCellWithIdentifier:@"settingsTemperatureCell"];
            [cell setDataWithExtender:extender];
            cell.temperatureImage.image = [UIImage imageWithData:pngData];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell.frame.size.height;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Determine if row is selectable based on the NSIndexPath
    // If a site has no Generator we show 1 cell less, this index is used to for the right index based on self.siteHasGenerator
    NSInteger cellIndexBasedOnSiteHasGenerator = indexPath.row - self.siteHasGenerator;
    if (cellIndexBasedOnSiteHasGenerator > 1)
    {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ExtenderDetailViewController *extenderDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"extenderDetail"];

    // If a site has no Generator we show 1 cell less, this index is used to for the right index based on self.siteHasGenerator
    NSInteger cellIndexBasedOnSiteHasGenerator = indexPath.row - self.siteHasGenerator;

    extenderDetail.selectedExtender = [self.extendersList objectAtIndex:(cellIndexBasedOnSiteHasGenerator - 2)];
    extenderDetail.selectedSite = self.selectedSite;
    [self.navigationController pushViewController:extenderDetail animated:YES];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_LIST_PRESS
                                                           label:@"io_extender_list"
                                                           value:nil] build]];
}

#pragma mark Switches

- (IBAction)switchChange:(id)sender {
    UISwitch* switchControl = sender;

    if (switchControl.on) {
        self.siteHasGenerator = YES;
    }
    else{
        self.siteHasGenerator = NO;
    }

    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:[M2MLoginService sharedInstance].currentSessionId forKey:KEY_SESSION_ID];
    [postDict setValue:@"1" forKey:KEY_DEVICE_ID];
    [postDict setValue:[NSNumber numberWithInteger:self.selectedSite.siteID] forKey:KEY_SITE_ID];
    [postDict setValue:[NSNumber numberWithBool:self.siteHasGenerator] forKey:KEY_HAS_GENERATOR];
    [postDict setValue:API_VERSION forKey:KEY_API_VERSION];

    [SVProgressHUD show];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URL_SERVER_SITES_SET_GENERATOR parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];

        if (switchControl.on) {
            switchControl.on = YES;
            self.selectedSite.hasGenerator = YES;
            [self.tableView reloadData];

        }
        else{
            switchControl.on = NO;
            self.selectedSite.hasGenerator = NO;
            [self.tableView reloadData];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == RETURN_CODE_SESSION_EXPIRED) {
            NSMutableDictionary *postDict = [Tools setPostDict];

            [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [SVProgressHUD dismiss];
                [M2MLoginService sharedInstance].currentSessionId = [responseObject objectForKey:KEY_SESSION_ID];
                [self switchChange:(id)sender];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
            }];
        } else {
            [SVProgressHUD dismiss];

            [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

            if (switchControl.on) {
                switchControl.on = NO;
                self.siteHasGenerator = NO;
            }
            else{
                switchControl.on = YES;
                self.siteHasGenerator = YES;
            }
        }
    }];
}

- (IBAction)selectOutputButtonPressed:(id)sender {
    M2MSelectOutputTableViewController *selectOutputController = [self.storyboard instantiateViewControllerWithIdentifier:@"M2MSelectOutputTableViewController"];
    selectOutputController.selectedOutput = [self.outputIndexpath integerValue];
    selectOutputController.selectedOutputName = self.selectedOutput;
    selectOutputController.outputsArray = self.outputList;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController:selectOutputController animated:YES];
    } else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Show the table in a popover
        self.selectOutputPopover = [[UIPopoverController alloc] initWithContentViewController:selectOutputController];
        selectOutputController.popoverDelegate = self.selectOutputPopover;
        selectOutputController.delegate = self;

        // Create a Rect, based on the button frame, from which to present the popover.
        CGRect buttonFrame = [sender frame];
        CGRect parentRect = [sender convertRect:((UIButton*)sender).bounds toView:self.view];
        parentRect.origin.x = buttonFrame.origin.x;

        self.selectOutputPopover.popoverContentSize = CGSizeMake(320.0, 120.0);
        [self.selectOutputPopover presentPopoverFromRect:parentRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void) setSelectedOutputWithOutputIndex:(NSInteger) index{
    ExtenderInfo *extender = [self.outputList objectAtIndex:index];
    self.selectedOutput = extender.label;
    self.outputIndexpath = [NSNumber numberWithInteger:index];
    [self saveNewSettingsToNSUserDefaults];
}

- (IBAction)segmentedControlValueChanged:(id)sender {
    UISegmentedControl *segmentedControl = sender;

    self.generatorState = segmentedControl.selectedSegmentIndex;
    [self saveNewSettingsToNSUserDefaults];
}

- (void) saveNewSettingsToNSUserDefaults{
    NSArray *keysCopy = [self.siteSettingsList copy];
    for (NSMutableDictionary *siteDictionary in keysCopy)
    {
        if ([[siteDictionary objectForKey:KEY_SELECTED_SITE_ID] isEqualToNumber:[NSNumber numberWithInteger:self.selectedSite.siteID]])
        {   self.siteAlreadyExists = YES;
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
            [tempDict setValue:self.outputIndexpath forKey:KEY_OUTPUT_INDEXPATH];
            [tempDict setValue:[NSNumber numberWithInteger:self.generatorState] forKey:KEY_GENERATOR_STATE];
            [tempDict setValue:[NSNumber numberWithInteger:self.selectedSite.siteID] forKey:KEY_SELECTED_SITE_ID];
            [tempDict setValue:[NSString stringWithString:self.selectedOutput] forKey:KEY_SELECTED_OUTPUT];
            [self.siteSettingsList replaceObjectAtIndex:[self.siteSettingsList indexOfObject:siteDictionary] withObject:tempDict];
            [[NSUserDefaults standardUserDefaults] setObject:self.siteSettingsList forKey:KEY_SITE_SETTINGSLIST];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if (self.siteAlreadyExists == NO)
    {
        if ([self.selectedOutput length]) {
            [self.siteSettingsDict setValue:self.selectedOutput forKey:KEY_SELECTED_OUTPUT];
            [self.siteSettingsDict setValue:self.outputIndexpath forKey:KEY_OUTPUT_INDEXPATH];
            [self.siteSettingsDict setValue:[NSNumber numberWithInteger:self.generatorState] forKey:KEY_GENERATOR_STATE];
            [self.siteSettingsDict setValue:[NSNumber numberWithInteger:self.selectedSite.siteID] forKey:KEY_SELECTED_SITE_ID];
            [self.siteSettingsList addObject:self.siteSettingsDict];
            self.siteAlreadyExists = YES;

            [[NSUserDefaults standardUserDefaults] setObject:self.siteSettingsList forKey:KEY_SITE_SETTINGSLIST];

            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }

        [self.tableView reloadData];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
