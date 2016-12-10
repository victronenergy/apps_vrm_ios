//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <MessageUI/MessageUI.h>

#import "SVModalWebViewController.h"

@interface SVWebViewController : UIViewController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
- (id)initWithURLRequest:(NSURLRequest*)URLRequest;
- (void)setToken:(NSString*)token;
- (bool)isDone;
@property (nonatomic, readwrite) SVWebViewControllerAvailableActions availableActions;

@end
