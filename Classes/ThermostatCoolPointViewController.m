//
//  ThermostatCoolPointViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ThermostatCoolPointViewController.h"
#import "XMPPManager.h"

@implementation ThermostatCoolPointViewController

@synthesize thermostat;

- (void)viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = @"Set Cool Point";
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloth.png"]]; // [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0];
	self.view.backgroundColor = [UIColor clearColor];
	
	NSNumber * temp = [thermostat coolPoint];
	
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
	
	[super viewWillAppear:animated];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView
{
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component
{
	if ([thermostat coolPoint])
		return 128;
	else
		return 129;
}

- (NSString * )pickerView:(UIPickerView *) pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component
{
	if (row == 128)
		return @"Unknown";
	else
		return [NSString stringWithFormat:@"%d°", row];
}

- (void) pickerView:(UIPickerView *) pickerView didSelectRow:(NSInteger) row inComponent:(NSInteger) component
{
	if (row < 128)
	{
		[thermostat setValue:[NSNumber numberWithInteger:row] forKey:@"thermostat_cool_point"];

		NSString * command = [NSString stringWithFormat:@"shion:setCoolPoint_forThermostat(%d, \"%@\")", row, [thermostat identifier]];
		[[XMPPManager sharedManager] sendCommand:command forDevice:thermostat];
	}
	else
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Invalid Cool Point"
														 message:@"Please select a valid temperature."
														delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
		
		[alert show];
		
		[alert release];
	}
}

@end
