//
//  HistoricDataViewController.m
//  VictronEnergy
//
//  Created by Victron Energy on 5/7/13.
//  Copyright (c) 2013 Victron Energy. All rights reserved.
//

#import "HistoricDataViewController.h"
#import "HistoricDataInfo.h"
#import "Data.h"

@interface HistoricDataViewController ()

@end

@implementation HistoricDataViewController

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
	self.screenName = @"HistoricData - iPhone";
    self.view.backgroundColor = COLOR_BACKGROUND;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadViewWithData:) name:KEY_HISTORIC_DATA_NOTIFICATION object:nil];

    self.navigationItem.title = NSLocalizedString(@"historic_data_title", @"historic_data_title");
    self.navigationItem.backBarButtonItem.title = NSLocalizedString(@"back_button_title", @"back_button_title");

    [self.scroller setScrollEnabled:YES];
    [self.scroller setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scroller setContentSize:CGSizeMake(self.view.frame.size.width, 720)];

    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
    self.backgroundBorderView.layer.borderWidth = 1.0f;

    self.nameLabel.text = self.selectedSite.name;

    self.headerBackground.image = [[UIImage imageNamed:@"heading_corner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kHeaderInsetImageTop, kHeaderInsetImageLeft, kHeaderInsetImageBottom, kHeaderInsetImageRight)];

    [self getSiteAttributesForHistoricData];

    [Tools style:LabelStyleSectionHeader forLabel:self.nameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.ddNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.ldNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.adNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.ccNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.fdNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.tadNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.minvNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.maxvNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.tslcNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.asNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.lvaNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.hvaNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.lsvaNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.hsvaNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.minsvNameLabel];
    [Tools style:LabelStyleHistoricDataTitle forLabel:self.maxsvNameLabel];

    [Tools style:LabelStyleHistoricDataValue forLabel:self.ddValueLabel withFormat:AMPHOUR];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.ldValueLabel withFormat:AMPHOUR];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.adValueLabel withFormat:AMPHOUR];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.ccValueLabel withFormat:NONE];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.fdValueLabel withFormat:NONE];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.tadValueLabel withFormat:AMPHOUR];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.minvValueLabel withFormat:VOLT];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.maxvValueLabel withFormat:VOLT];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.tslcValueLabel withFormat:NONE];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.asValueLabel withFormat:NONE];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.lvaValueLabel withFormat:NONE];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.hvaValueLabel withFormat:NONE];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.lsvaValueLabel withFormat:NONE];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.hsvaValueLabel withFormat:NONE];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.minsvValueLabel withFormat:VOLT];
    [Tools style:LabelStyleHistoricDataValue forLabel:self.maxsvValueLabel withFormat:VOLT];


}
-(void)getSiteAttributesForHistoricData
{
    __block NSNumber *siteID = [NSNumber numberWithInteger:self.selectedSite.siteID];
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:[Data sharedData].sessionId forKey:kM2MWebServiceSessionId];
    [postDict setValue:kM2MWebServiceVerificationTokenValue forKey:kM2MWebServiceVerificationToken];
    [postDict setValue:kM2MWebServiceVersionNumber forKey:kM2MWebServiceVersion];
    [postDict setValue:siteID forKey:kM2MWebServiceSiteId];
    [postDict setValue:[NSNumber numberWithInteger:self.selectedSite.instanceNumber] forKey:kM2MWebServiceInstance];
    [postDict setValue:[NSString stringWithFormat:@"[%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@]",kHistoricDataDeepestDischarge,kHistoricDataLastDischarge, kHistoricDataAverageDischarge, kHistoricDataChargeCycles, kHistoricDataFullDischarge, kHistoricDataTotalAhDrawn, kHistoricDataMinimumVoltage, kHistoricDataMaximumVoltage, kHistoricDataTimeSinceLastFullCharge, kHistoricDataAutomaticSyncs, kHistoricDataLowVoltageAlarms, kHistoricDataHighVoltageAlarms, kHistoricDataLowStarterVoltageAlarms, kHistoricDataHighStarterVoltageAlarms, kHistoricDataMinimumStarterVoltage, kHistoricDataMaximumStarterVoltage] forKey:kM2MWebServiceAttributes];

    [SVProgressHUD show];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URL_SERVER_ATTRIBUTE_OBJECT parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];

        UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];
        if (alert) {
            [alert show];
        } else {
            NSDictionary *responseDictionary = [responseObject objectForKey:kM2MResponseData];
            NSArray *attributesArray = [responseDictionary objectForKey:kM2MResponseAttributes];
            self.siteHistoricAttributesInfo = [[AttributesInfo alloc]initWithArray:attributesArray];
            [self reloadViewWithData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == RETURN_CODE_SESSION_EXPIRED) {
            NSMutableDictionary *postDict = [Tools setPostDict];

            [manager POST:URL_SERVER_LOGIN parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [SVProgressHUD dismiss];
                [Data sharedData].sessionId=[responseObject objectForKey:KEY_SESSION_ID];
                [self getSiteAttributesForHistoricData];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [SVProgressHUD dismiss];

                UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

                if (alert) {
                    [alert show];
                }
            }];
        } else {
            [SVProgressHUD dismiss];

            UIAlertView *alert = [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:operation.response.statusCode];

            if (alert) {
                [alert show];
            }
        }
    }];
}

-(void)reloadViewWithData
{

    [self.view setNeedsDisplay];

    HistoricDataInfo *info = [[HistoricDataInfo alloc] initWithAttributesInfo:self.siteHistoricAttributesInfo];

    self.ddValueLabel.text = info.deepestDischarge;
    self.ldValueLabel.text =  info.lastDischarge;
    self.adValueLabel.text = info.averageDischarge;
    self.ccValueLabel.text = info.chargeCycles;
    self.fdValueLabel.text = info.fullDischarges;
    self.tadValueLabel.text = info.totalAhDrawn;
    self.minvValueLabel.text = info.minimumVoltage;
    self.maxvValueLabel.text = info.maximumVoltage;
    self.tslcValueLabel.text = info.timeSinceLastFullCharge;
    self.asValueLabel.text =  info.automaticSyncs;
    self.lvaValueLabel.text =  info.lowVoltgeAlarms;
    self.hvaValueLabel.text =  info.hightVoltageAlarms;
    self.lsvaValueLabel.text = info.lowStarterVoltageAlarms;
    self.hsvaValueLabel.text = info.highStarterVoltageAlarms;
    self.minsvValueLabel.text = info.minimumStarterVoltage;
    self.maxsvValueLabel.text = info.maximumStarterVoltage;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDdNameLabel:nil];
    [self setLdNameLabel:nil];
    [self setAdNameLabel:nil];
    [self setCcNameLabel:nil];
    [self setFdNameLabel:nil];
    [self setTadNameLabel:nil];
    [self setMinvNameLabel:nil];
    [self setMaxvNameLabel:nil];
    [self setTslcNameLabel:nil];
    [self setAsNameLabel:nil];
    [self setLvaNameLabel:nil];
    [self setHvaNameLabel:nil];
    [self setLsvaNameLabel:nil];
    [self setHsvaNameLabel:nil];
    [self setMinsvNameLabel:nil];
    [self setMaxsvNameLabel:nil];
    [self setDdValueLabel:nil];
    [self setLdValueLabel:nil];
    [self setAdValueLabel:nil];
    [self setCcValueLabel:nil];
    [self setFdValueLabel:nil];
    [self setTadValueLabel:nil];
    [self setMinvValueLabel:nil];
    [self setMaxvValueLabel:nil];
    [self setTslcValueLabel:nil];
    [self setAsValueLabel:nil];
    [self setLvaValueLabel:nil];
    [self setHvaValueLabel:nil];
    [self setLsvaValueLabel:nil];
    [self setHsvaValueLabel:nil];
    [self setMinsvValueLabel:nil];
    [self setMaxsvValueLabel:nil];
    [self setScroller:nil];
    [super viewDidUnload];
}
@end
