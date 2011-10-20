//
//  ApplianceViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ApplianceViewController.h"
#import "Appliance.h"

#import "XMPPManager.h"

@implementation ApplianceViewController

- (IBAction) update:(id) sender
{
	if (![sender isKindOfClass:[UISlider class]])
		  return;

	UISlider * slider = (UISlider *) sender;
		  
	float sliderLevel = slider.value;
	
	if (sliderLevel < 128)
		sliderLevel = 0;
	else
		sliderLevel = 255;

	[slider setValue:sliderLevel animated:YES];
	
	NSNumber * level = [NSNumber numberWithFloat:sliderLevel];
	Appliance * appliance = (Appliance *) device;
	
	appliance.level = level;
	
	NSString * command = [NSString stringWithFormat:@"shion:activateDevice(\"%@\")", [device identifier]];
	
	if ([level floatValue] == 0)
		command = [NSString stringWithFormat:@"shion:deactivateDevice(\"%@\")", [device identifier]];
	
	[[XMPPManager sharedManager] sendCommand:command forDevice:device];
}

@end
