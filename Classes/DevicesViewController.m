//
//  DevicesViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "DevicesViewController.h"
#import "AllDevicesViewController.h"
#import "LocationsViewController.h"
#import "TypesViewController.h"
#import "PlatformsViewController.h"

#import "ApplicationModel.h"

@implementation DevicesViewController

@synthesize options;

- (UIImage *) imageForOption:(NSString *) option
{
	if ([option isEqual:@"All Devices"])
		return [UIImage imageNamed:@"devices_all.png"];
	else if ([option isEqual:@"By Location"])
		return [UIImage imageNamed:@"devices_location.png"];
	else if ([option isEqual:@"By Type"])
		return [UIImage imageNamed:@"devices_type.png"];
	else if ([option isEqual:@"By Platform"])
		return [UIImage imageNamed:@"devices_platform.png"];
	else
		return nil;
}

- (NSString *) detailsForOption:(NSString *) option
{
	if ([option isEqual:@"All Devices"])
	{
		NSArray * devices = [[ApplicationModel sharedModel] allDevices];
	
		NSUInteger count = [devices count];
		
		if (count == 1)
			return [NSString stringWithFormat:@"1 device: %@", [[devices lastObject] name]];
		else
			return [NSString stringWithFormat:@"%d devices", count];
	}
	else if ([option isEqual:@"By Location"])
	{
		NSArray * locations = [[ApplicationModel sharedModel] locations];
		
		NSUInteger count = [locations count];
		
		if (count == 1)
			return [NSString stringWithFormat:@"1 location: %@", [[locations lastObject] name]];
		else
			return [NSString stringWithFormat:@"%d locations", count];
	}
	else if ([option isEqual:@"By Type"])
	{
		NSArray * types = [[ApplicationModel sharedModel] allTypes];
		
		NSUInteger count = [types count];
		
		if (count == 1)
			return [NSString stringWithFormat:@"1 major device type: %@", [types lastObject]];
		else
			return [NSString stringWithFormat:@"%d major device types", count];
	}
	else if ([option isEqual:@"By Platform"])
	{
		NSArray * platforms = [[ApplicationModel sharedModel] allPlatforms];
		
		NSUInteger count = [platforms count];
		
		if (count == 1)
			return [NSString stringWithFormat:@"1 device platform: %@", [platforms lastObject]];
		else
			return [NSString stringWithFormat:@"%d device platforms", count];
	}
	else
		return [NSString stringWithFormat:@"TODO: %@", option];
}

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Devices";
	
    [super viewWillAppear:animated];
	
	self.options = [NSArray arrayWithObjects:@"All Devices", @"By Location", @"By Type", @"By Platform", nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"model_updated" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"model_updated" object:nil];
	
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
	return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"DevicesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
	NSString * option = [self.options objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	cell.textLabel.text = option;
    cell.detailTextLabel.text = [self detailsForOption:option];
	cell.imageView.image = [self imageForOption:option];
	
    return cell;
}

- (UIViewController *) viewControllerForOption:(NSString *) option
{
	if ([option isEqual:@"All Devices"])
		return [[[AllDevicesViewController alloc] initWithNibName:@"AllDevicesViewController" bundle:nil] autorelease];
	else if ([option isEqual:@"By Location"])
		return [[[LocationsViewController alloc] initWithNibName:@"LocationsViewController" bundle:nil] autorelease];
	else if ([option isEqual:@"By Type"])
		return [[[TypesViewController alloc] initWithNibName:@"TypesViewController" bundle:nil] autorelease];
	else if ([option isEqual:@"By Platform"])
		return [[[PlatformsViewController alloc] initWithNibName:@"PlatformsViewController" bundle:nil] autorelease];

	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSString * option = [self.options objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];

	UIViewController * controller = [self viewControllerForOption:option];
	
	if (controller != nil)
		[self.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc 
{
    [super dealloc];
}

@end

