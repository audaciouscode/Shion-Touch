//
//  ChimeViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/29/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ChimeViewController.h"
#import "XMPPManager.h"

@implementation ChimeViewController

- (IBAction) ring:(id) sender
{
	NSString * command = [NSString stringWithFormat:@"shion:ringDevice(\"%@\")", [device identifier]];
	
	[[XMPPManager sharedManager] sendCommand:command forDevice:device];
}

- (BOOL) editable
{
	return YES;
}

@end
