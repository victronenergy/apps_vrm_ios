//
//  SiteDetailViewController.m
//  VictronEnergy
//
//  Created by Thijs on 3/27/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "SiteDetailViewController.h"
#import "SiteDetailCell.h"
#import "M2MDetailAlarmCell.h"
#import "M2MDetailOKCell.h"
#import "M2MDetailOutDatedCell.h"
#import "BMVCell.h"
#import "MultiCell.h"
#import "ExtenderCell.h"
#import "TemperatureExtenderCell.h"
#import "InputExtenderCell.h"
#import "OutputExtenderCell.h"
#import "ButtonsCell.h"
#import "NoDataCell.h"
#import "Tools.h"
#import "Data.h"
#import "AttributesInfo.h"
#import "ExtenderInfo.h"
#import "SettingsDetailTableViewController.h"
#import "ExtenderDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HistoricDataViewController.h"
#import "GeneratorButtonCell.h"
#import "BMV+Multi+MPPTCell.h"
#import "BMV+MultiCell.h"
#import "BMV+Multi+PVICell.h"
#import "BMV+MPPTCell.h"

#import "M2MImagesCollectionViewDataSource.h"
#import "M2MImagesCollectionViewController.h"
#import "M2MLoginService.h"
#import "M2MSiteService.h"
#import "M2MAttributesService.h"
#import "M2MExtendersService.h"
#import "M2MSiteInfoService.h"
#import "M2MLastUpdateCell.h"

const NSInteger kCollectionViewRowHeigthIPhone = 104;
const NSInteger kCollectionViewRowHeigthIPad = 114;

@interface SiteDetailViewController()

@property (nonatomic, strong) M2MImagesCollectionViewDataSource *imagesCollectionViewDataSource;

@end

@implementation SiteDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageCollectionView.dataSource = self.imagesCollectionViewDataSource;
    self.imagesCollectionViewDataSource.inFooterOfSiteDetail = YES;

    self.tableView.backgroundColor = COLOR_BACKGROUND;
    self.tableView.tableFooterView.backgroundColor = COLOR_BACKGROUND;
    self.imageCollectionView.backgroundColor = COLOR_BACKGROUND;
    self.selectedOutput = 0;

    [self addSettingsButton];
    [self getSettingsList];

    [self.tableView addSubview:self.refreshHeaderView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadSite];
}

- (void)setSelectedSite:(SiteInfo *)selectedSite
{
    _selectedSite = selectedSite;

    self.navigationItem.title = selectedSite.name;
    self.imagesCollectionViewDataSource.selectedSite = selectedSite;
    if(!selectedSite.siteAttributes){
        [self getSiteAttributes];
    }else{
        [self getExtenders];
    }
}

-(void) identifyScenarioNew
{
    BOOL hasMulti = NO;
    BOOL hasSolarCharger = NO;
    BOOL hasPvInverterOnOut = NO;

    NSArray *arrayWithAttributes = @[kAttributeAC_ConsumptionL1,kAttributePV_DC_Coupled,kAttributePV_AC_CoupledOutputL1];
    for (NSString *attributeCode in arrayWithAttributes){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY attributes.attributeCode == %@", attributeCode];
        BOOL exists =  [predicate evaluateWithObject:self.selectedSite.siteAttributes];
        if (exists) {
            if ([attributeCode isEqualToString:kAttributeAC_ConsumptionL1]) {
                hasMulti = YES;
            } else if ([attributeCode isEqualToString:kAttributePV_DC_Coupled]) {
                hasSolarCharger = YES;
            } else if ([attributeCode isEqualToString:kAttributePV_AC_CoupledOutputL1]) {
                hasPvInverterOnOut = YES;
            }
        }
    }
    // Checks which overview is the active overview for this site
    if (hasMulti && !hasSolarCharger && hasPvInverterOnOut) {
        self.currentOverview = BMV_MULTI_PVINVERTER;
    } else if (hasMulti && hasSolarCharger) {
        self.currentOverview = BMV_MULTI_MPPT;
    } else if (!hasMulti && hasSolarCharger) {
        self.currentOverview = BMV_MPPT;
    } else if (hasMulti && !hasSolarCharger && !hasPvInverterOnOut) {
        self.currentOverview = BMV_MULTI;
    } else {
        self.currentOverview = BMV;
    }
}

-(void)reloadSite
{
    __weak typeof(self)weakSelf = self;
    [[M2MSiteInfoService new] getSiteWithID:self.selectedSite.siteID success:^(SiteInfo *site) {
        _selectedSite = site;
        weakSelf.imagesCollectionViewDataSource.selectedSite = weakSelf.selectedSite;
        [self getSiteAttributes];

    } failure:^(NSInteger statusCode) {
        [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:statusCode];
        [self doneLoadingTableViewData];
    }];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //Reload the site to prevent weird layout buggs
    [self reloadSite];
    
}

-(void)getSiteAttributes
{
    __weak typeof(self)weakSelf = self;

    __block NSNumber *siteID = @(self.selectedSite.siteID);

    [[M2MAttributesService new] loadSiteAttributesWithSiteID:siteID success:^(AttributesInfo *attributes){
        if (attributes) {
            weakSelf.selectedSite.siteAttributes = attributes;
            [self getExtenders];
        }
    } failure:^(NSInteger statusCode){
        [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:statusCode];
        [self doneLoadingTableViewData];
    }];
}

-(void)getExtenders
{
    __weak SiteDetailViewController *weakSelf = self;

    self.reloadExtenderName = [NSString stringWithFormat:@"extender%ld", (long) self.selectedSite.siteID];

    if (self.selectedSite.hasIOExtender) {

        [[M2MExtendersService new] loadExtendersForSite:self.selectedSite.siteID success:^(NSArray *extenders){
            weakSelf.extendersList = [extenders mutableCopy];
            [weakSelf extendersLoaded];
        } failure:^(NSInteger statusCode){
            [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:statusCode];
        }];
    }else{
        [self doneLoadingTableViewData];
        [self reloadTableViewData];
    }
}

- (void)extendersLoaded
{
    self.tempExtenderList = [[NSMutableArray alloc] initWithArray:self.extendersList];

    self.outputList = [[NSMutableArray alloc] init];

    for (ExtenderInfo *extender in self.extendersList){
        if ([[extender.code substringToIndex:2] isEqualToString:EXTENDER_OUTPUT]) {
            [self.outputList addObject:extender];
        }
    }

    [self doneLoadingTableViewData];
    [self reloadTableViewData];
}
-(void) reloadTableViewData {
    [self.selectedSite setSummaryWidgetsforAttributes:self.selectedSite.siteAttributes];
    [self identifyScenarioNew];
    [self.tableView reloadData];
    [self setHeightForTableViewFooterBasedOnImages];
    [self.imageCollectionView reloadData];
    [self.imageCollectionView layoutIfNeeded];
}

- (void)getSettingsList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.siteSettingsList = [[NSMutableArray alloc] init];
    self.siteSettingsList = [NSMutableArray arrayWithArray:[defaults arrayForKey:KEY_SITE_SETTINGSLIST]];

    for (NSDictionary *siteSettingsDictionary in self.siteSettingsList) {
        if ([[siteSettingsDictionary objectForKey:KEY_SELECTED_SITE_ID] isEqualToNumber:[NSNumber numberWithInteger:self.selectedSite.siteID]]) {
            self.siteSettingsListResults = siteSettingsDictionary;
        }
    }
}

- (void)addSettingsButton
{
    UIImage *rightBarButton = [UIImage imageNamed:@"button_settings.png"];
    UIImage *rightBarButtonPressed = [UIImage imageNamed:@"button_settings_pressed.png"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:rightBarButton forState:UIControlStateNormal];
    [button setImage:rightBarButtonPressed forState:UIControlStateSelected];
    button.frame = CGRectMake(0.0, 0.0, rightBarButton.size.width, rightBarButton.size.height);
    [button addTarget:self action:@selector(settingsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(IBAction)settingsButtonPressed:(id)sender
{
    SettingsDetailTableViewController *settingsDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsDetailTableViewController"];
    settingsDetailController.siteName = self.selectedSite.name;
    settingsDetailController.selectedSite = self.selectedSite;
    settingsDetailController.siteHasGenerator = self.selectedSite.hasGenerator;
    settingsDetailController.outputList = self.outputList;
    if (self.selectedSite.hasIOExtender) {
        if ([self.extendersList count]) {
            settingsDetailController.extendersList = self.extendersList;
            settingsDetailController.siteHasIOExtenders = self.selectedSite.hasIOExtender;
        }
    }else{
        settingsDetailController.siteHasIOExtenders = 0; //has no extenders so we set it to 0
    }

    [self.navigationController pushViewController:settingsDetailController animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    _reloading = YES;
    [self reloadSite];
}

- (void)doneLoadingTableViewData{
    //  model should call this when its done loading
    if(_reloading) {
        _reloading = NO;
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }

}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];

}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{

    [self performSelectorOnMainThread:@selector(reloadTableViewDataSource) withObject:nil waitUntilDone:NO];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_GESTURE
                                                          action:GA_WITH_ACTION_PULL
                                                           label:@"refresh_summary_pull"
                                                           value:nil] build]];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading

}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{

    return [NSDate date]; // should return date data source was last changed

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.selectedSite.hasIOExtender == 1 && [self.extendersList count] > 0) {
        return 2;
    }

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!self.selectedSite.siteAttributes) {
        return 1;
    } else {
        if (section == 0) {
            return 4;
        } else {
            NSInteger tableViewCells = [self.extendersList count] + 1;
            if (self.selectedSite.hasIOExtender == 1 && [self.extendersList count] > 0) {
                tableViewCells ++;
            }
            return (tableViewCells);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row ) {

            case 0:{
                UITableViewCell *cell = [self cellForSiteStatus:self.selectedSite.siteStatus withTableView:tableView];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = COLOR_BACKGROUND;
                return cell;
            }
            case 1:{
                M2MLastUpdateCell *cell = (M2MLastUpdateCell *)[tableView dequeueReusableCellWithIdentifier:@"LastUpdateCell"];
                [cell setDataWithSiteObject:self.selectedSite];
                return cell;
            }
            case 2:{
                return [self cellForOverview:self.currentOverview withTableView:tableView];
            }
            case 3:{
                return [tableView dequeueReusableCellWithIdentifier:@"buttonsCell"];
            }default : {
                return [UITableViewCell new];
            }
        }

    } else {
        if (indexPath.row == 0) {
            ExtenderCell *cell = (ExtenderCell *)[tableView dequeueReusableCellWithIdentifier:@"ExtenderCell"];
            cell.settingsButton.enabled = self.selectedSite.canEditSite;

            return cell;

        } else if (indexPath.row > 0 && indexPath.row <= [self.extendersList count]){
            ExtenderInfo *extender = self.tempExtenderList[indexPath.row - 1];

            return [self getCellForExtender:extender withTableView:tableView];

        } else {
            GeneratorButtonCell *cell = (GeneratorButtonCell *)[tableView dequeueReusableCellWithIdentifier:@"GeneratorButtonCell"];
            if (self.selectedSite.hasGenerator && self.selectedSite.hasIOExtender && [self.extendersList count] > 0){
                [cell setDataWithSiteSettingsList:self.siteSettingsListResults selectedSite:self.selectedSite outputList:self.outputList tableviewController:self];
            }
            else{
                cell.hidden = YES;
                cell.generatorButton.hidden = YES;
                // If the site has no generator we hide the cell and set the height to 16 so we have a spacing in the bottom
                [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, 16)];
            }
            return cell;
        }

    }
}

- (UITableViewCell *)getCellForExtender:(ExtenderInfo *)extender withTableView:(UITableView *)tableView
{
    NSString *imageName = [NSString stringWithFormat:@"%ld%@",(long) self.selectedSite.siteID, extender.code];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];

    if ([extender.code isEqualToString: EXTENDER_INPUT_1] || [extender.code isEqualToString: EXTENDER_INPUT_2] || [extender.code isEqualToString: EXTENDER_INPUT_3]) {
        InputExtenderCell *cell = (InputExtenderCell *)[tableView dequeueReusableCellWithIdentifier:@"InputExtenderCell"];

        [cell setDataWithExtender:extender];
        cell.inputImage.image = [UIImage imageWithData:pngData];
        return cell;
    }
    else if ([extender.code isEqualToString: EXTENDER_OUTPUT_1] || [extender.code isEqualToString: EXTENDER_OUTPUT_2]) {
        OutputExtenderCell *cell = (OutputExtenderCell *)[tableView dequeueReusableCellWithIdentifier:@"OutputExtenderCell"];

        [cell setDataWithExtender:extender];
        cell.outputSwitch.enabled = self.selectedSite.canEditSite;
        cell.outputImage.image = [UIImage imageWithData:pngData];
        return cell;

    }
    else if ([extender.code isEqualToString: EXTENDER_TEMPERATURE_1]) {
        TemperatureExtenderCell *cell = (TemperatureExtenderCell *)[tableView dequeueReusableCellWithIdentifier:@"TemperatureExtenderCell"];

        cell.temperatureImage.image = [UIImage imageWithData:pngData];
        [cell setDataWithExtender:extender];
        return cell;
    }

}

- (UITableViewCell *)cellForSiteStatus:(NSInteger)siteStatus withTableView:(UITableView *)tableView
{
    switch (siteStatus) {
        case ALARMS:{
            M2MDetailAlarmCell *cell = (M2MDetailAlarmCell *)[tableView dequeueReusableCellWithIdentifier:@"M2MDetailAlarmCell"];
            [cell setDataWithSiteObject:self.selectedSite];
            return cell;
        }
        case OK:{
            M2MDetailOKCell *cell = (M2MDetailOKCell *)[tableView dequeueReusableCellWithIdentifier:@"M2MDetailOKCell"];
            [cell setDataWithSiteObject:self.selectedSite];
            return cell;
        }case OLD:{
            M2MDetailOutDatedCell *cell = (M2MDetailOutDatedCell *)[tableView dequeueReusableCellWithIdentifier:@"M2MDetailOutDatedCell"];
            [cell setDataWithSiteObject:self.selectedSite];
            return cell;
        }
        default:
            return nil;
    }
}

- (UITableViewCell *)cellForOverview:(Scenario)overview withTableView:(UITableView *)tableView{

    switch(overview) {
        case BMV: {
            BMVCell *cell = (BMVCell *)[tableView dequeueReusableCellWithIdentifier:@"BMVCell"];
            [cell setDataWithSite:self.selectedSite];
            return cell;
        }
        case BMV_MULTI: {
            BMV_MultiCell *cell = (BMV_MultiCell *)[tableView dequeueReusableCellWithIdentifier:@"BMV+MultiCell"];
            [cell setDataWithSite:self.selectedSite];
            return cell;
        }
        case BMV_MULTI_MPPT: {
            BMV_Multi_MPPTCell *cell = (BMV_Multi_MPPTCell *)[tableView dequeueReusableCellWithIdentifier:@"BMV+Multi+MPPTCell"];
            [cell setDataWithSite:self.selectedSite];
            return cell;
        }
        case BMV_MULTI_PVINVERTER: {
            BMV_Multi_PVICell *cell = (BMV_Multi_PVICell *)[tableView dequeueReusableCellWithIdentifier:@"BMV+Multi+PVICell"];
            [cell setDataWithSite:self.selectedSite];
            return cell;
        }
        case MULTI: {
            MultiCell *cell = (MultiCell *)[tableView dequeueReusableCellWithIdentifier:@"MultiCell"];
            [cell setDataWithSite:self.selectedSite];
            return cell;
        }case BMV_MPPT: {
            BMV_MPPTCell *cell = (BMV_MPPTCell *)[tableView dequeueReusableCellWithIdentifier:@"BMV+MPPTCell"];
            [cell setDataWithSite:self.selectedSite];
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView
                      cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (EGORefreshTableHeaderView *)refreshHeaderView
{
    if(!_refreshHeaderView){
        _refreshHeaderView  = [[EGORefreshTableHeaderView alloc]
                initWithFrame:CGRectMake(0.0f,
                        0.0f - self.tableView.bounds.size.height,
                        self.view.frame.size.width,
                        self.tableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    return _refreshHeaderView;
}


- (IBAction)switchChange:(id)sender
{
    UISwitch* switchControl = sender;

    if ([self.selectedSite.phone length] == 0 || [self.selectedSite.phone isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                initWithTitle:nil
                      message:NSLocalizedString(@"no_phone_number_text", @"no_phone_number_text")
                     delegate:self
            cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
            otherButtonTitles:nil];
        [alert show];

        if (switchControl.on) {
            [switchControl setOn:NO];
        }
        else if (!switchControl.on) {
            [switchControl setOn:YES];
        }

    }else{
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            if (switchControl.tag == CELL_TAG_1) {
                self.smsOutput = NSLocalizedString(@"sms_Output1", @"sms_Output1");
            }
            else if (switchControl.tag == CELL_TAG_2) {
                self.smsOutput = NSLocalizedString(@"sms_Output2", @"sms_Output2");
            }

            if (switchControl.on) {
                controller.body = [NSString stringWithFormat:NSLocalizedString(@"sms_on", @"sms_on"), self.smsOutput];
            }
            else{
                controller.body = [NSString stringWithFormat:NSLocalizedString(@"sms_off", @"sms_off"), self.smsOutput];
            }
            controller.recipients = [NSMutableArray arrayWithObjects:self.selectedSite.phone, nil];
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];

        }
        else{
            if (switchControl.on) {
                [switchControl setOn:NO];
            }
            else if (!switchControl.on) {
                [switchControl setOn:YES];
            }
        }
    }
}

- (IBAction)changeGeneratorButtonPressed:(id)sender {

    if (self.hasSetGeneratorSettings) {
        if ([self.selectedSite.phone length] == 0 || [self.selectedSite.phone isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc]
                    initWithTitle:nil
                          message:NSLocalizedString(@"no_phone_number_text", @"no_phone_number_text")
                         delegate:self
                cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
                otherButtonTitles:nil];
            [alert show];
        }else{
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                                  action:GA_WITH_ACTION_BUTTON_PRESS
                                                                   label:@"generator_button"
                                                                   value:nil] build]];

            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                if (self.selectedOutput == 0) {
                    self.smsOutput = NSLocalizedString(@"sms_Output1", @"sms_Output1");
                }
                else if (self.selectedOutput== 1) {
                    self.smsOutput = NSLocalizedString(@"sms_Output2", @"sms_Output2");
                }

                if (self.startGenerator == YES) {
                    controller.body = [NSString stringWithFormat:NSLocalizedString(@"sms_off", @"sms_off"), self.smsOutput];
                }
                else{
                    controller.body = [NSString stringWithFormat:NSLocalizedString(@"sms_on", @"sms_on"), self.smsOutput];
                }
                controller.recipients = [NSMutableArray arrayWithObjects:self.selectedSite.phone, nil];
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:NSLocalizedString(@"settings_not_set_message", @"settings_not_set_message")
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
                                             otherButtonTitles:nil, nil];
        [alert show];
    }



}

- (IBAction)historicDataButtonPressed:(id)sender {

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:GA_EVENT_CATEGORY_ACTION
                                                          action:GA_WITH_ACTION_BUTTON_PRESS
                                                           label:@"historic_data_button"
                                                           value:nil] build]];

    HistoricDataViewController *historicDataViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"historicDataViewController"];

    historicDataViewController.selectedSite = self.selectedSite;
    historicDataViewController.siteHistoricAttributesInfo = self.selectedSite.siteAttributes;
    [self.navigationController pushViewController:historicDataViewController animated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark FooterView

-(void)setHeightForTableViewFooterBasedOnImages
{
    CGRect frame = self.tableView.tableFooterView.frame;

    CGFloat count = 1;

    if ([self.selectedSite.imageURLS count]) {
        count = count + [self.selectedSite.imageURLS count];
    }

    NSInteger roundedUp;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        roundedUp = ceil(count/6);
        frame.size.height = kCollectionViewRowHeigthIPad * roundedUp;
    } else {
        roundedUp = ceil(count/3);
        frame.size.height = kCollectionViewRowHeigthIPhone * roundedUp;
    }

    [self.tableView.tableFooterView setFrame:frame];
    self.tableView.tableFooterView = self.tableView.tableFooterView;
}

#pragma mark CollectionView

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.selectedSite.imageURLS count]) {

        // open an actionsheet with the camera or photelibrary options
        [[[UIActionSheet alloc] initWithTitle:nil
                                     delegate:self
                            cancelButtonTitle:NSLocalizedString(@"photo_picker_menu_close_button", @"photo_picker_menu_close_button")
                       destructiveButtonTitle:nil
                            otherButtonTitles:NSLocalizedString(@"take_photo_button_title", @"take_photo_button_title"), NSLocalizedString(@"photo_library_button_title", @"photo_library_button_title"), nil]
                showInView:self.parentViewController.view];

    } else {
        // open the screen where we show all the images

        UINavigationController *navControl =  [self.storyboard instantiateViewControllerWithIdentifier:@"M2MImagesCollectionViewController"];
        M2MImagesCollectionViewController *imageCollectionView = [[navControl viewControllers] firstObject];
        M2MImagesCollectionViewDataSource *dataSource = [M2MImagesCollectionViewDataSource new];
        dataSource.selectedSite = self.selectedSite;
        [imageCollectionView setDataSource:dataSource];
        imageCollectionView.selectedSite = self.selectedSite;
        imageCollectionView.currentIndex = indexPath.row;
        imageCollectionView.onImageDelete = ^{
            [self reloadSite];
        };

        [self.navigationController presentViewController:navControl animated:YES completion:nil];
    }
}

#pragma mark - CollectionView datasource
- (M2MImagesCollectionViewDataSource *)imagesCollectionViewDataSource
{
    if(!_imagesCollectionViewDataSource){
        _imagesCollectionViewDataSource= [[M2MImagesCollectionViewDataSource alloc] init];
    }
    return _imagesCollectionViewDataSource;
}

#pragma mark - image picker

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self getPhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [self getPhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        default:
            break;
    }
}

-(void)getPhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType{

    if([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];

        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        imagePicker.sourceType = sourceType;
        imagePicker.view.backgroundColor = [UIColor whiteColor];

        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
       didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;

    if(image){

        [self processTheImage:image];
    }
}
-(void)processTheImage:(UIImage *)image
{
    if (image)
    {
        // The new size is 480 x 640 this is the size we agreed on to use for iOS and Android.
        CGSize newSize = CGSizeZero;

        if (image.imageOrientation == 1) {
            newSize = CGSizeMake(640.0f, 480.0f);
        } else {
            newSize = CGSizeMake(480.0f, 640.0f);
        }

        UIGraphicsBeginImageContextWithOptions(newSize, YES, 1.0f);
        CGFloat aspect = image.size.width / image.size.height;

        if (newSize.width / aspect <= newSize.height)
        {
            [image drawInRect:CGRectMake(0, (newSize.height/2) - ((newSize.width / aspect)/2), newSize.width, newSize.width / aspect)];

        } else {
            [image drawInRect:CGRectMake((newSize.width/2) - ((newSize.height * aspect)/2), 0.0f, newSize.height * aspect, newSize.height)];
        }

        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *imageData = UIImageJPEGRepresentation(newImage, 1.0);

        __weak typeof(self)weakSelf = self;

        [self sendImageDataToSave:imageData completion:^(BOOL succes){
            if (succes) {
                [weakSelf reloadSite];
            }
        }];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{

    [picker dismissViewControllerAnimated:YES completion:Nil];
}

-(void)sendImageDataToSave:(NSData *)imageData completion:(void (^)(BOOL succes))completion{

    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:[M2MLoginService sharedInstance].currentSessionId forKey:kM2MWebServiceSessionId];
    [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];
    [postDict setValue:[NSNumber numberWithInteger:self.selectedSite.siteID] forKey:kM2MWebServiceSiteId];

    [SVProgressHUD show];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager POST:URL_SERVER_IMAGE_UPLOAD parameters:postDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:kM2MWebServiceImage fileName:kM2MWebServiceImage mimeType:@"image/jpeg"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        completion(YES);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
        completion(NO);
    }];
}

@end
