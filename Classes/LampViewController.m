//
//  LampViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "LampViewController.h"
#import "Lamp.h"
#import "XMPPManager.h"

@implementation LampViewController

- (IBAction) update:(id) sender
{
	if (![sender isKindOfClass:[UISlider class]])
		return;
	
	UISlider * slider = (UISlider *) sender;

	float sliderLevel = slider.value;
	
	if ([device unidirectional])
	{
		if (sliderLevel < 128)
			sliderLevel = 0;
		else
			sliderLevel = 255;
	
		[slider setValue:sliderLevel animated:YES];
	}
	else
	{
		int intLevel = (int) sliderLevel;
		
		int mod = intLevel % 32;
		
		if (mod < 16)
			intLevel -= mod;
		else
			intLevel += (32 - mod);
		
		if (intLevel > 255)
			intLevel = 255;
		else if (intLevel < 0)
			intLevel = 0;

		sliderLevel = (float) intLevel;

		[slider setValue:sliderLevel animated:YES];
	}

	NSNumber * level = [NSNumber numberWithFloat:sliderLevel];
	Lamp * lamp = (Lamp *) device;
	
	lamp.level = level;

	float normalizedLevel = [level floatValue] / 255;

	NSString * command = [NSString stringWithFormat:@"shion:setLevel_forDevice(%f, \"%@\")", normalizedLevel, [device identifier]];
	
	[[XMPPManager sharedManager] sendCommand:command forDevice:device];
}

- (IBAction) brighten:(id) sender
{
	// TODO
	
	NSLog(@"Send brighten command");
}

- (IBAction) dim:(id) sender
{
	// TODO
	
	NSLog(@"Send dim command");
}



@end
