//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewController.h"
#import "SVProgressHUD.h"

@interface SVWebViewController () <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong, readonly) UIActionSheet *pageActionSheet;

@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURLRequest *URLRequest;


- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
- (id)initWithURLRequest:(NSURLRequest*)URLReq;
- (void)loadURLRequest:(NSURLRequest*)URLReq;
- (void)loadURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;

@end


@implementation SVWebViewController

@synthesize availableActions;

@synthesize URL, mainWebView, URLRequest;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem, pageActionSheet;

#pragma mark - setters and getters

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIBarButtonItem *)backBarButtonItem {

    if (!backBarButtonItem) {
        backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
		backBarButtonItem.width = 18.0f;
        backBarButtonItem.tintColor = COLOR_DARK_GREY;
    }
    return backBarButtonItem;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"orientation change");
    [mainWebView stringByEvaluatingJavaScriptFromString:@"var e = document.createEvent('Events'); "
     @"e.initEvent('orientationchange', true, false);"
     @"document.dispatchEvent(e); "];
    
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!forwardBarButtonItem) {
        forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
		forwardBarButtonItem.width = 18.0f;
        forwardBarButtonItem.tintColor = COLOR_DARK_GREY;
    }
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {

    if (!refreshBarButtonItem) {
        refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
        refreshBarButtonItem.tintColor = COLOR_DARK_GREY;
    }

    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {

    if (!stopBarButtonItem) {
        stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
        stopBarButtonItem.tintColor = COLOR_DARK_GREY;
    }
    return stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {

    if (!actionBarButtonItem) {
        actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    }
    actionBarButtonItem.tintColor = COLOR_DARK_GREY;
    return actionBarButtonItem;
}

- (UIActionSheet *)pageActionSheet {

    if(!pageActionSheet) {
        pageActionSheet = [[UIActionSheet alloc]
                        initWithTitle:self.mainWebView.request.URL.absoluteString
                        delegate:self
                        cancelButtonTitle:nil
                        destructiveButtonTitle:nil
                        otherButtonTitles:nil];

        if((self.availableActions & SVWebViewControllerAvailableActionsCopyLink) == SVWebViewControllerAvailableActionsCopyLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Copy Link", @"SVWebViewController", @"")];

        if((self.availableActions & SVWebViewControllerAvailableActionsOpenInSafari) == SVWebViewControllerAvailableActionsOpenInSafari)
            [pageActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Open in Safari", @"SVWebViewController", @"")];

        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]] && (self.availableActions & SVWebViewControllerAvailableActionsOpenInChrome) == SVWebViewControllerAvailableActionsOpenInChrome)
            [pageActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Open in Chrome", @"SVWebViewController", @"")];

        if([MFMailComposeViewController canSendMail] && (self.availableActions & SVWebViewControllerAvailableActionsMailLink) == SVWebViewControllerAvailableActionsMailLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Mail Link to this Page", @"SVWebViewController", @"")];

        [pageActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Cancel", @"SVWebViewController", @"")];
        pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
    }

    return pageActionSheet;
}

#pragma mark - Initialization

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {

    if(self = [super init]) {
        self.URL = pageURL;
        self.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsOpenInChrome | SVWebViewControllerAvailableActionsMailLink;
    }

    return self;
}

- (id)initWithURLRequest:(NSURLRequest*)URLReq{
    if(self = [super init]) {
        self.URLRequest = URLReq;
        self.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsOpenInChrome | SVWebViewControllerAvailableActionsMailLink;
    }

    return self;
}

- (void)loadURLRequest:(NSURLRequest *)URLReq {
    [mainWebView loadRequest:URLReq];
}

- (void)loadURL:(NSURL *)pageURL {
    [mainWebView loadRequest:[NSURLRequest requestWithURL:pageURL]];
}

#pragma mark - View lifecycle

- (void)loadView {
    mainWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainWebView.delegate = self;
    mainWebView.scalesPageToFit = YES;
    [self loadURLRequest:self.URLRequest];
    self.view = mainWebView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    mainWebView = nil;
    backBarButtonItem = nil;
    forwardBarButtonItem = nil;
    refreshBarButtonItem = nil;
    stopBarButtonItem = nil;
    actionBarButtonItem = nil;
    pageActionSheet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    // Clear cookies this is needed to make the login work properly
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");

	[super viewWillAppear:animated];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD dismiss];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;

    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)dealloc
{
    [mainWebView stopLoading];
 	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    mainWebView.delegate = nil;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
    self.actionBarButtonItem.enabled = !self.mainWebView.isLoading;

    UIBarButtonItem *refreshStopBarButtonItem = self.mainWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;

    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

        NSArray *items;
        CGFloat toolbarWidth = 250.0f;

        if(self.availableActions == 0) {
            toolbarWidth = 200.0f;
            items = [NSArray arrayWithObjects:
                     refreshStopBarButtonItem,
                     nil];
        } else {
            fixedSpace.width = 30.0f;
            items = [NSArray arrayWithObjects:
                     self.actionBarButtonItem,
                     refreshStopBarButtonItem,
                     nil];
        }

        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        toolbar.tintColor = COLOR_NAV_BAR;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_6_1) {
            toolbar.barTintColor = COLOR_NAV_BAR;
        }
        toolbar.translucent = NO;
        toolbar.clipsToBounds = YES;
        self.navigationItem.rightBarButtonItems = items;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
    [SVProgressHUD show];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    [SVProgressHUD dismiss];

    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if ([error code] != NSURLErrorCancelled) {
        //show error alert, etc.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"error_title", @"error_title")
                              message:NSLocalizedString(@"error_message", @"error_message")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"error_message_cancel_button", @"error_message_cancel_button")
                              otherButtonTitles:nil];
        [alert show];

    }
    [SVProgressHUD dismiss];
    [self updateToolbarItems];
}

#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    NSLog(@"go back clicked");
    [mainWebView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [mainWebView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    [mainWebView reload];
}

- (void)stopClicked:(UIBarButtonItem *)sender {
    [mainWebView stopLoading];
	[self updateToolbarItems];
}

- (void)actionButtonClicked:(id)sender {

    if(pageActionSheet)
        return;

    [self.pageActionSheet showFromBarButtonItem:self.actionBarButtonItem animated:YES];
}

- (void)doneButtonClicked:(id)sender {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    [self dismissModalViewControllerAnimated:YES];
#else
    [self dismissViewControllerAnimated:YES completion:NULL];
#endif
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];

	if([title localizedCompare:NSLocalizedStringFromTable(@"Open in Safari", @"SVWebViewController", @"")] == NSOrderedSame)
        [[UIApplication sharedApplication] openURL:self.mainWebView.request.URL];

    if([title localizedCompare:NSLocalizedStringFromTable(@"Open in Chrome", @"SVWebViewController", @"")] == NSOrderedSame) {
        NSURL *inputURL = self.mainWebView.request.URL;
        NSString *scheme = inputURL.scheme;

        NSString *chromeScheme = nil;
        if ([scheme isEqualToString:@"http"]) {
            chromeScheme = @"googlechrome";
        } else if ([scheme isEqualToString:@"https"]) {
            chromeScheme = @"googlechromes";
        }

        if (chromeScheme) {
            NSString *absoluteString = [inputURL absoluteString];
            NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
            NSString *urlNoScheme =
            [absoluteString substringFromIndex:rangeForScheme.location];
            NSString *chromeURLString =
            [chromeScheme stringByAppendingString:urlNoScheme];
            NSURL *chromeURL = [NSURL URLWithString:chromeURLString];

            [[UIApplication sharedApplication] openURL:chromeURL];
        }
    }

    if([title localizedCompare:NSLocalizedStringFromTable(@"Copy Link", @"SVWebViewController", @"")] == NSOrderedSame) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.mainWebView.request.URL.absoluteString;
    }

    else if([title localizedCompare:NSLocalizedStringFromTable(@"Mail Link to this Page", @"SVWebViewController", @"")] == NSOrderedSame) {

		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];

		mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
  		[mailViewController setMessageBody:self.mainWebView.request.URL.absoluteString isHTML:NO];
		mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
		[self presentModalViewController:mailViewController animated:YES];
#else
        [self presentViewController:mailViewController animated:YES completion:NULL];
#endif
	}

    pageActionSheet = nil;
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
	[self dismissModalViewControllerAnimated:YES];
#else
    [self dismissViewControllerAnimated:YES completion:NULL];
#endif
}

@end
