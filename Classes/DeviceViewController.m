//
//  DeviceViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "DeviceViewController.h"
#import "Appliance.h"
#import "Lamp.h"
#import "Thermostat.h"
#import "Phone.h"
#import "Controller.h"
#import "MotionSensor.h"
#import "House.h"
#import "Chime.h"
#import "MobileDevice.h"
#import "Camera.h"
#import "Tivo.h"

#import "ApplianceViewController.h"
#import "LampViewController.h"
#import "ThermostatViewController.h"
#import "PhoneViewController.h"
#import "ControllerViewController.h"
#import "MotionSensorViewController.h"
#import "HouseViewController.h"
#import "ChimeViewController.h"
#import "MobileDeviceViewController.h"
#import "CameraListViewController.h"
#import "TivoViewController.h"

#import "LocationViewController.h"

@implementation DeviceViewController

@synthesize device;
@synthesize controlsVisible;

+ (UIViewController *) controllerForDevice:(Device *) device
{
	DeviceViewController * controller = nil;
	
	if ([device isKindOfClass:[Lamp class]])
		controller = [[LampViewController alloc] initWithNibName:@"LampViewController" bundle:nil];
	else if ([device isKindOfClass:[Appliance class]])
		controller = [[ApplianceViewController alloc] initWithNibName:@"ApplianceViewController" bundle:nil];
	else if ([device isKindOfClass:[Thermostat class]])
		controller = [[ThermostatViewController alloc] initWithNibName:@"ThermostatViewController" bundle:nil];
	else if ([device isKindOfClass:[Phone class]])
		controller = [[PhoneViewController alloc] initWithNibName:@"PhoneViewController" bundle:nil];
	else if ([device isKindOfClass:[Controller class]])
		controller = [[ControllerViewController alloc] initWithNibName:@"ControllerViewController" bundle:nil];
	else if ([device isKindOfClass:[MotionSensor class]])
		controller = [[MotionSensorViewController alloc] initWithNibName:@"MotionSensorViewController" bundle:nil];
	else if ([device isKindOfClass:[House class]])
		controller = [[HouseViewController alloc] initWithNibName:@"HouseViewController" bundle:nil];
	else if ([device isKindOfClass:[Chime class]])
		controller = [[ChimeViewController alloc] initWithNibName:@"ChimeViewController" bundle:nil];
	else if ([device isKindOfClass:[MobileDevice class]])
		controller = [[MobileDeviceViewController alloc] initWithNibName:@"MobileDeviceViewController" bundle:nil];
	else if ([device isKindOfClass:[Tivo class]])
		controller = [[TivoViewController alloc] initWithNibName:@"TivoViewController" bundle:nil];
	else if ([device isKindOfClass:[Phone class]])
		controller = [[PhoneViewController alloc] initWithNibName:@"PhoneViewController" bundle:nil];
	else
		controller = [[DeviceViewController alloc] initWithNibName:@"DeviceViewController" bundle:nil];

	if ([controller isKindOfClass:[DeviceViewController class]])
	{
		BOOL visible = NO;

		id show = [[NSUserDefaults standardUserDefaults] valueForKey:@"show_controls"];
		
		if (show != nil && [show boolValue])
			visible = YES;
		else
		{
			id showControls = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@-controls-visible", [device identifier]]];
			
			if (showControls != nil)
				visible = [showControls boolValue];
			else if (show != nil)
				visible = [show boolValue];
			else
				visible = YES;
		}
		
		controller.controlsVisible = visible;
		controller.device = device;
	}
	else if ([controller isKindOfClass:[MobileDeviceViewController class]])
		controller.device = device;
	else if ([controller isKindOfClass:[CameraListViewController class]])
		controller.device = device;
	else if ([controller isKindOfClass:[TivoViewController class]])
		controller.device = device;
	
	return [controller autorelease];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"view_refresh" object:nil];
	}
	
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"view_refresh" object:nil];
	
	[super dealloc];
}

- (void) refresh:(NSNotification *) theNote
{
	[self.view setNeedsDisplay];
	[widget refresh];
	[controls setNeedsDisplay];
}

- (void) viewWillDisappear:(BOOL)animated
{
	NSString * key = [NSString stringWithFormat:@"%@-controls-visible", [device identifier]];
	
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:self.controlsVisible] forKey:key];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = [device name];
	
	NSString * imageName = @"star-small.png";
	
	if ([device favorite])
		imageName = @"star-small-yellow.png";
	
	UIBarButtonItem * favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
																		style:UIBarButtonItemStyleBordered 
																	   target:self
																	   action:@selector(favorite:)];
	self.navigationItem.rightBarButtonItem = favoriteButton;

	[favoriteButton release];

	if (self.controlsVisible)
		[controls show:NO];
	else
		[controls hide:NO];

	controls.device = device;
	widget.device = device;

	[super viewWillAppear:animated];
}

- (void) favorite:(id) sender
{
	NSString * imageName = @"star-small-yellow.png";
	
	if ([device favorite])
		imageName = @"star-small.png";
		
	
	UIBarButtonItem * favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
																		style:UIBarButtonItemStyleBordered 
																	   target:self
																	   action:@selector(favorite:)];
	
	self.navigationItem.rightBarButtonItem = favoriteButton;
	
	[favoriteButton release];
	
	[device setFavorite:([device favorite] == NO)];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:self];
}

@end
