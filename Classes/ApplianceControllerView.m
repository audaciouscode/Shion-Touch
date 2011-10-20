//
//  ApplianceControllerView.m
//  Shion Touch
//
//  Created by Chris Karr on 4/26/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ApplianceControllerView.h"
#import "Appliance.h"

@implementation ApplianceControllerView

- (void) willMoveToWindow:(UIWindow *)newWindow
{
	CGRect area = [self mutableArea];

	UIFont * font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	
	UILabel * offLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, area.size.height - 43, 30, 23)];
	offLabel.textColor = [UIColor whiteColor];
	offLabel.backgroundColor = [UIColor clearColor];
	offLabel.textAlignment = UITextAlignmentRight;
	offLabel.text = @"Off";
	offLabel.font = font;
	[self addSubview:offLabel];
	[offLabel release];
	
	CGRect sliderArea = CGRectMake(60, area.size.height - 43, area.size.width - 120, 23);
	slider = [[UISlider alloc] initWithFrame:sliderArea];
	slider.minimumValue = 0;
	slider.maximumValue = 255;
	
	slider.continuous = NO;
	[slider addTarget:parentController action:@selector(update:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:slider];
	[slider release];

	UILabel * onLabel = [[UILabel alloc] initWithFrame:CGRectMake(area.size.width - 50, area.size.height - 43, 30, 23)];
	onLabel.textColor = [UIColor whiteColor];
	onLabel.backgroundColor = [UIColor clearColor];
	onLabel.textAlignment = UITextAlignmentLeft;
	onLabel.text = @"On";
	onLabel.font = font;
	[self addSubview:onLabel];
	[onLabel release];
	
	UILabel * descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, area.size.height - 43 - 20 - 69, area.size.width - 40, 69)];
	descriptionLabel.text = @"To activate or deactivate the selected appliance, drag slider to either the 'On' or 'Off' positions.";
	descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
	descriptionLabel.textColor = [UIColor lightGrayColor];
	descriptionLabel.backgroundColor = [UIColor clearColor];
	descriptionLabel.textAlignment = UITextAlignmentLeft;
	descriptionLabel.numberOfLines = 0;
	[self addSubview:descriptionLabel];
	[descriptionLabel release];
	
	[self setNeedsDisplay];
}

- (void) setNeedsDisplay
{
	if (device)
	{
		if ([device isKindOfClass:[Appliance class]])
		{
			Appliance * a = (Appliance *) device;
			
			slider.value = [a.level floatValue];
		}
	}

	[super setNeedsDisplay];
}

- (CGSize) fullSize
{
	CGSize size = self.frame.size;
	size.height = 10 + 69 + 20 + 23 + 20;
	
	return size;
}

@end
