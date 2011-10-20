//
//  ThermostatControllerView.m
//  Shion Touch
//
//  Created by Chris Karr on 4/26/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ThermostatControllerView.h"

#define DESC_SIZE 0

@implementation ThermostatControllerView

- (void) willMoveToWindow:(UIWindow *)newWindow
{
	if ([device isKindOfClass:[Thermostat class]])
	{
		CGRect area = [self mutableArea];
		
		CGFloat bottom = area.origin.y + area.size.height;
		
		heatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[heatButton setFrame:CGRectMake(20, bottom - 37 - 20, 280, 37)];
		[self addSubview:heatButton];
		
		coolButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[coolButton setFrame:CGRectMake(20, bottom - 20 - 37 - 47, 280, 37)];
		[self addSubview:coolButton];
		
		modeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[modeButton setFrame:CGRectMake(20, bottom - 20 - 37 - 47 - 47, 136, 37)];
		[self addSubview:modeButton];
		
		fanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[fanButton setFrame:CGRectMake(136 + 30, bottom - 20 - 37 - 47 - 47, 136, 37)];
		[self addSubview:fanButton];
		
		[heatButton addTarget:parentController action:@selector(promptForHeatPoint:) forControlEvents:UIControlEventTouchUpInside];
		[coolButton addTarget:parentController action:@selector(promptForCoolPoint:) forControlEvents:UIControlEventTouchUpInside];
		[modeButton addTarget:parentController action:@selector(promptForMode:) forControlEvents:UIControlEventTouchUpInside];
		[fanButton addTarget:parentController action:@selector(toggleFan:) forControlEvents:UIControlEventTouchUpInside];
		
		/*		NSMutableString * tips = [NSMutableString string];
		 [tips appendString:@"Mode: Determines when thermostat activates\n"];
		 [tips appendString:@"Fan: Touch to activate fan independent of therostat state\n"];
		 [tips appendString:@"Cool point: Temp. above which the thermostat begins to cool\n"];
		 [tips appendString:@"Cool point: Temp. below which the thermostat begins to heat"];
		 
		 UIFont * font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
		 
		 UILabel * descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, area.size.height - 10 - 138 - (47  * 3) - 20, area.size.width - 40, 138)];
		 descriptionLabel.text = tips;
		 descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
		 descriptionLabel.textColor = [UIColor lightGrayColor];
		 descriptionLabel.backgroundColor = [UIColor clearColor];
		 descriptionLabel.textAlignment = UITextAlignmentLeft;
		 descriptionLabel.numberOfLines = 0;
		 descriptionLabel.font = font;
		 [self addSubview:descriptionLabel];
		 [descriptionLabel release]; */
	}
	
	[self setNeedsDisplay];
}

- (void) setNeedsDisplay
{
	if ([device isKindOfClass:[Thermostat class]])
	{
		Thermostat * thermostat = (Thermostat *) device;
		NSNumber * heat = [thermostat heatPoint];
		
		if (heat)
			[heatButton setTitle:[NSString stringWithFormat:@"Heat Point: %@°", heat] forState:UIControlStateNormal];
		else
			[heatButton setTitle:@"Heat Point: Unknown" forState:UIControlStateNormal];

		NSNumber * cool = [thermostat coolPoint];

		if (cool)
			[coolButton setTitle:[NSString stringWithFormat:@"Cool Point: %@°", cool] forState:UIControlStateNormal];
		else
			[coolButton setTitle:@"Cool Point: Unknown" forState:UIControlStateNormal];
		
		NSString * modeString = [thermostat mode];
		[modeButton setTitle:[NSString stringWithFormat:@"Mode: %@", modeString] forState:UIControlStateNormal];
		
		if ([thermostat fanActive])
			[fanButton setTitle:@"Fan: On" forState:UIControlStateNormal];
		else
			[fanButton setTitle:@"Fan: Off" forState:UIControlStateNormal];
	}
	
	[super setNeedsDisplay];
}

- (CGSize) fullSize
{
	CGSize size = self.frame.size;
	size.height = DESC_SIZE + 20 + 47 + 47 + 47 + 20;
	
	return size;
}

@end
