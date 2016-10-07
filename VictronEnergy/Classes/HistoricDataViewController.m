//
//  HistoricDataViewController.m
//  VictronEnergy
//
//  Created by Thijs on 5/7/13.
//  Copyright (c) 2013 Thijs Bouma. All rights reserved.
//

#import "HistoricDataViewController.h"
#import "HistoricDataInfo.h"
#import "Data.h"
#import "M2MLoginService.h"
#import "M2MHistoricDataService.h"

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
    self.navigationItem.title = NSLocalizedString(@"historic_data_title", @"historic_data_title");
    self.navigationItem.backBarButtonItem.title = NSLocalizedString(@"back_button_title", @"back_button_title");

    [self updateScrollViewLayout];

    //CHANGE: removed border for the redundant background view
//    self.backgroundBorderView.layer.borderColor = [COLOR_LINE CGColor];
//    self.backgroundBorderView.layer.borderWidth = 1.0f;

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
    __weak HistoricDataViewController *weakSelf = self;

    [[M2MHistoricDataService new] loadHistoricDataWithSiteID:self.selectedSite.siteID instanceNumber:self.selectedSite.instanceNumber success:^(AttributesInfo *attributesInfo) {
        NSLog(@"Attribute Info %@", attributesInfo);
        weakSelf.siteHistoricAttributesInfo = attributesInfo;
        [weakSelf updateScrollViewLayout];
        [weakSelf reloadViewWithData];
    } failure:^(NSInteger statusCode) {
        NSLog(@"%ld", (long)statusCode);
        [M2MNetworkErrorHandler checkToShowAlertViewForResponseCode:statusCode];
    }];
}

-(void)reloadViewWithData
{

    [self.view setNeedsDisplay];

    HistoricDataInfo *info = [[HistoricDataInfo alloc] initWithAttributesInfo:self.siteHistoricAttributesInfo];

    NSLog(@"Reload w Data %@", info.deepestDischarge);
    
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
    
    NSLog(@"Label values: %@", self.ddValueLabel.text);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateScrollViewLayout];
}

//Update the scrollview and contentview width and height to adjust it to the current device orientation
-(void)updateScrollViewLayout
{
    [self.scroller setScrollEnabled:YES];
    [self.scroller setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.boxView setFrame:CGRectMake(10,10, self.view.frame.size.width - 20, 720)];
    [self.scroller setContentSize:CGSizeMake(self.view.frame.size.width - 20, 720)];
    self.scroller.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
