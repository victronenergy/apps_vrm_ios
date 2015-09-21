//
//  M2MAboutViewController.m
//  VictronEnergy
//
//  Created by Lime on 04/07/14.
//  Copyright (c) 2014 Thijs Bouma. All rights reserved.
//

#import "M2MAboutViewController.h"
#import "M2MAboutTextTableViewCell.h"
#import "M2MAboutHeaderTableViewCell.h"
#import "M2MAboutLinksTableViewCell.h"

@interface M2MAboutViewController ()

@end

@implementation M2MAboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_BACKGROUND;
    self.tableView.backgroundColor = COLOR_BACKGROUND;

    self.title = NSLocalizedString(@"about_title", @"title of about screen");

    self.tableView.contentInset = UIEdgeInsetsMake(16.0f, 0.0f, 16.0f, 0.0f);
    
    [[UINavigationBar appearance]setBarTintColor:COLOR_NAV_BAR];
    [[UINavigationBar appearance]setTintColor:COLOR_DARK_GREY];

}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            M2MAboutHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"M2MAboutHeaderTableViewCell" forIndexPath:indexPath];
            return cell;
        }
        case 1: {
            M2MAboutTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"M2MAboutTextTableViewCell" forIndexPath:indexPath];
            cell.aboutTextView.attributedText = [self aboutText];

            cell.clipsToBounds = YES;

            CALayer *rightBorder = [CALayer layer];
            rightBorder.borderColor = COLOR_LINE.CGColor;
            rightBorder.borderWidth = 1;
            rightBorder.frame = CGRectMake(0, -1, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame)+2);

            [cell.layer addSublayer:rightBorder];

            return cell;
        }
        case 2: {
            M2MAboutLinksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"M2MAboutLinksTableViewCell" forIndexPath:indexPath];

            cell.clipsToBounds = YES;

            CALayer *rightBorder = [CALayer layer];
            rightBorder.borderColor = COLOR_LINE.CGColor;
            rightBorder.borderWidth = 1;
            rightBorder.frame = CGRectMake(0, -1, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame)+1);

            [cell.layer addSublayer:rightBorder];
            return cell;
        }
        default:
            return [UITableViewCell new];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = 60.0f;
    switch (indexPath.row) {
        case 0: {
            height = 60;
            break;        }
        case 1: {

            NSInteger aboutTextWidth = 288;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                aboutTextWidth = 700;
            }
            CGRect frame = [[[self aboutText]string] boundingRectWithSize:CGSizeMake(aboutTextWidth, MAXFLOAT)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:LABEL_ABOUT_TEXT_FONT}
                                                                  context:nil];
            height = frame.size.height + 60;
            break;
        }
        case 2: {
            height = 60;
            break;
        }
        default:
            height = 60;
            break;
    }

    return height;
}

#pragma mark - Helper methods
- (NSMutableAttributedString *)aboutText{

    NSMutableAttributedString *aboutText = [[NSMutableAttributedString alloc]init];

    NSMutableAttributedString *firstText = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"about_text_1", @"first part of the about text")];
    [firstText addAttributes:@{NSForegroundColorAttributeName: COLOR_GREY,
                               NSFontAttributeName: LABEL_ABOUT_TEXT_FONT} range:NSMakeRange(0, firstText.length)];
    [aboutText appendAttributedString:firstText];

    NSMutableAttributedString *secondHeaderText = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"about_header_2", @"second header of the about text")];
    [secondHeaderText addAttributes:@{NSForegroundColorAttributeName: COLOR_DARK_GREY,
                                      NSFontAttributeName: LABEL_ABOUT_TEXT_HEADER_FONT} range:NSMakeRange(0, secondHeaderText.length)];
    [aboutText appendAttributedString:secondHeaderText];

    NSMutableAttributedString *secondtText = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"about_text_2", @"second part of the about text")];
    [secondtText addAttributes:@{NSForegroundColorAttributeName: COLOR_GREY,
                                 NSFontAttributeName: LABEL_ABOUT_TEXT_FONT} range:NSMakeRange(0, secondtText.length)];
    [aboutText appendAttributedString:secondtText];

    NSMutableAttributedString *thirdHeaderText = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"about_header_3", @"second header of the about text")];
    [thirdHeaderText addAttributes:@{NSForegroundColorAttributeName: COLOR_DARK_GREY,
                                     NSFontAttributeName: LABEL_ABOUT_TEXT_HEADER_FONT} range:NSMakeRange(0, thirdHeaderText.length)];
    [aboutText appendAttributedString:thirdHeaderText];

    NSMutableAttributedString *thirdText = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"about_text_3", @"first part of the about text")];
    [thirdText addAttributes:@{NSForegroundColorAttributeName: COLOR_GREY,
                               NSFontAttributeName: LABEL_ABOUT_TEXT_FONT} range:NSMakeRange(0, thirdText.length)];
    [aboutText appendAttributedString:thirdText];

    NSMutableAttributedString *fourthHeaderText = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"about_header_4", @"second header of the about text")];
    [fourthHeaderText addAttributes:@{NSForegroundColorAttributeName: COLOR_DARK_GREY,
                                      NSFontAttributeName: LABEL_ABOUT_TEXT_HEADER_FONT} range:NSMakeRange(0, fourthHeaderText.length)];
    [aboutText appendAttributedString:fourthHeaderText];

    NSMutableAttributedString *fourthText = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"about_text_4", @"first part of the about text")];
    [fourthText addAttributes:@{NSForegroundColorAttributeName: COLOR_GREY,
                                NSFontAttributeName: LABEL_ABOUT_TEXT_FONT} range:NSMakeRange(0, fourthText.length)];
    [aboutText appendAttributedString:fourthText];

    NSMutableAttributedString *fifthText = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"about_text_5", @"first part of the about text")];
    [fifthText addAttributes:@{NSForegroundColorAttributeName: COLOR_GREY,
                               NSFontAttributeName: LABEL_ABOUT_TEXT_FONT} range:NSMakeRange(0, fifthText.length)];
    [aboutText appendAttributedString:fifthText];

    return aboutText;
}

#pragma mark Button actions
- (IBAction)facebookButtonPressed:(id)sender {

    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:kFacebookURLShort]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFacebookURL]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFacebookURLHTTPS]];
    }
}

- (IBAction)twitterButtonPressed:(id)sender {

    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:kTwitterURLShort]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kTwitterURL]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kTwitterURLHTTPS]];
    }
}

- (IBAction)linkedInButtonPressed:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kLinkedInHTTPS]];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
