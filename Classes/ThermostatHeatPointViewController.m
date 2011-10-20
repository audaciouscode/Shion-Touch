//
//  ThermostatHeatPointViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ThermostatHeatPointViewController.h"
#import "XMPPManager.h"

@implementation ThermostatHeatPointViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.navigationItem.title = @"Set Heat Point";
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloth.png"]]; // [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0];
	self.view.backgroundColor = [UIColor clearColor];
	
	NSNumber * temp = [thermostat heatPoint];
	
	picker.showsSelectionIndicator = YES;
	
	if (temp)
	{
		currentPoint.text = [NSString stringWithFormat:@"%@°", temp];
		
		[picker selectRow:[temp integerValue] inComponent:0 animated:NO];
	}
	else
	{
		currentPoint.text = @"Unknown";
		
		[picker selectRow:128 inComponent:0 animated:NO];
	}
	
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component
{
	if ([thermostat heatPoint])
		return 128;
	else
		return 129;
}

- (void) pickerView:(UIPickerView *) pickerView didSelectRow:(NSInteger) row inComponent:(NSInteger) component
{
	if (row < 128)
	{
		[thermostat setValue:[NSNumber numberWithInteger:row] forKey:@"thermostat_heat_point"];

		NSString * command = [NSString stringWithFormat:@"shion:setHeatPoint_forThermostat(%d, \"%@\")", row, [thermostat identifier]];
		[[XMPPManager sharedManager] sendCommand:command forDevice:thermostat];
	}
	else
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Invalid Heat Point"
														 message:@"Please select a valid temperature."
														delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
		
		[alert show];
		
		[alert release];
	}
}


@end
