//
//  WebViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 5/25/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize urlString;

- (void) viewWillAppear:(BOOL) animated
{
	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
							  
	[webView loadRequest:request];
	
	webView.delegate = self;
	
	UIBarButtonItem * actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(webActions:)];
										
	self.navigationItem.rightBarButtonItem = actionButton;
	
	[actionButton release];
	
	[super viewWillAppear:animated];
}

- (void) webView:(UIWebView *) webView didFailLoadWithError:(NSError *) error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) webViewDidFinishLoad:(UIWebView *) webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) webViewDidStartLoad:(UIWebView *) webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) webActions:(id) sender
{
	UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:self.navigationItem.title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Launch in Safari", nil];

	[sheet showInView:self.parentViewController.tabBarController.view];
}

- (void) actionSheet:(UIActionSheet *) actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString]];
	
	[actionSheet autorelease];
}
	
@end
