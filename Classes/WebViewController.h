//
//  WebViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 5/25/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate>
{
	NSString * urlString;
	IBOutlet UIWebView * webView;
}

@property(retain) NSString * urlString;

@end
