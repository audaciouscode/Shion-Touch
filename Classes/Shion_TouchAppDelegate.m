//
//  Shion_TouchAppDelegate.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright CASIS 2010. All rights reserved.
//

#import "Shion_TouchAppDelegate.h"
#import "ApplicationModel.h"
#import "XMPPManager.h"

@implementation Shion_TouchAppDelegate

@synthesize window;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
	[ApplicationModel sharedModel];

	[[XMPPManager sharedManager] go];
	
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	return YES;
}

- (void)dealloc 
{
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

