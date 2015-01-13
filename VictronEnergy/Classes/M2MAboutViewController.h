//
//  M2MAboutViewController.h
//  VictronEnergy
//
//  Created by Victron Energy on 04/07/14.
//  Copyright (c) 2014 Victron Energy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M2MAboutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end
