//
//  HouseViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/29/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "HouseViewController.h"
#import "XMPPManager.h"

@implementation HouseViewController

- (IBAction) allOff:(id) sender
{
	NSString * command = [NSString stringWithFormat:@"shion:allOffForHouse(\"%@\")", [device identifier]];
	
	[[XMPPManager sharedManager] sendCommand:command forDevice:device];
}

- (IBAction) lightsOff:(id) sender
{
	NSString * command = [NSString stringWithFormat:@"shion:lightsOffForHouse(\"%@\")", [device identifier]];
	
	[[XMPPManager sharedManager] sendCommand:command forDevice:device];
}

- (IBAction) lightsOn:(id) sender
{
	NSString * command = [NSString stringWithFormat:@"shion:lightsOnForHouse(\"%@\")", [device identifier]];
	
	[[XMPPManager sharedManager] sendCommand:command forDevice:device];
}

- (BOOL) editable
{
	return YES;
}

@end
