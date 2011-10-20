//
//  ThermostatViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ThermostatViewController.h"
#import "ThermostatModeViewController.h"
#import "ThermostatCoolPointViewController.h"
#import "ThermostatHeatPointViewController.h"
#import "ThermostatFanModeViewController.h"

#import "ThermostatControllerView.h"

#import "Thermostat.h"

@implementation ThermostatViewController

- (void)viewWillAppear:(BOOL)animated
{
	[controls setDevice:device];
	
	[super viewWillAppear:animated];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 3;
}

- (IBAction) promptForMode:(id) sender
{
	ThermostatModeViewController * modeView = [[ThermostatModeViewController alloc] initWithNibName:@"ThermostatModeViewController" bundle:nil];
	modeView.thermostat = (Thermostat *) device;
	
	[self.navigationController pushViewController:modeView animated:YES];
	[modeView release];
}

- (IBAction) toggleFan:(id) sender
{
	ThermostatFanModeViewController * fanView = [[ThermostatFanModeViewController alloc] initWithNibName:@"ThermostatFanModeViewController" bundle:nil];
	fanView.thermostat = (Thermostat *) device;
	
	[self.navigationController pushViewController:fanView animated:YES];
	[fanView release];
}

- (IBAction) promptForCoolPoint:(id) sender
{
	ThermostatCoolPointViewController * pointView = [[ThermostatCoolPointViewController alloc] initWithNibName:@"ThermostatCoolPointViewController" bundle:nil];
	pointView.thermostat = (Thermostat *) device;
	
	[self.navigationController pushViewController:pointView animated:YES];
	[pointView release];
}

- (IBAction) promptForHeatPoint:(id) sender
{
	ThermostatHeatPointViewController * pointView = [[ThermostatHeatPointViewController alloc] initWithNibName:@"ThermostatHeatPointViewController" bundle:nil];
	pointView.thermostat = (Thermostat *) device;
	
	[self.navigationController pushViewController:pointView animated:YES];
	[pointView release];
}



@end
