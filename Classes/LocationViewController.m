//
//  LocationViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "LocationViewController.h"
#import "PhoneViewController.h"

#import "Device.h"
#import "Snapshot.h"

#import "ApplicationModel.h"
#import "DeviceViewController.h"
#import "SnapshotViewController.h"

@implementation LocationViewController

@synthesize location;

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = [location name];
	
    [super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"model_updated" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"view_refresh" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"model_updated" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"view_refresh" object:nil];
	
    [super viewWillAppear:animated];
}

- (void) reload:(NSNotification *) theNote
{
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[[ApplicationModel sharedModel] devicesForLocation:location] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"LocationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	NSArray * devices = [[ApplicationModel sharedModel] devicesForLocation:location];
	
	Device * d = [devices objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	cell.textLabel.text = [d name];
	cell.detailTextLabel.text = [d description];
	cell.imageView.image = [d statusImage];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSArray * viewControllers = self.navigationController.viewControllers;
	
	UIViewController * previousController = nil;
	
	if ([viewControllers count] > 2)
		previousController = [viewControllers objectAtIndex:([viewControllers count] - 2)];
	
	NSArray * devices = [[ApplicationModel sharedModel] devicesForLocation:location];
	Device * device = [devices objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	if (previousController && [previousController isKindOfClass:[DeviceViewController class]])
	{
		DeviceViewController * prevDevController = (DeviceViewController *) previousController;
		
		if (prevDevController.device == device)
		{
			[self.navigationController popViewControllerAnimated:YES];
			
			return;
		}
	}
	
	UIViewController * controller = [DeviceViewController controllerForDevice:device];
	
	if ([controller isKindOfClass:[DeviceViewController class]])
	{
		DeviceViewController * deviceView = (DeviceViewController *) controller;
		deviceView.device = device;
	}
	if ([controller isKindOfClass:[PhoneViewController class]])
	{
		PhoneViewController * deviceView = (PhoneViewController *) controller;
		deviceView.device = device;
	}
	
	[self.navigationController pushViewController:controller animated:YES];
}

@end

