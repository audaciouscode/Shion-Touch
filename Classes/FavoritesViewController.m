//
//  FavoritesViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "FavoritesViewController.h"
#import "PhoneViewController.h"

#import "ApplicationModel.h"
#import "Device.h"
#import "Snapshot.h"
#import "Trigger.h"
#import "DeviceViewController.h"
#import "SnapshotViewController.h"
#import "TriggerViewController.h"

@implementation FavoritesViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Favorites";

    [super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"favorites_changed" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"model_updated" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"view_refresh" object:nil];
	
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"favorites_changed" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"model_updated" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"view_refresh" object:nil];

    [super viewWillAppear:animated];
}

- (void) reload:(NSNotification *) theNote
{
	[self.tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView 
{
	return 3;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section
{
	if (section == 0)
		return @"Devices";
	else if (section == 1)
		return @"Snapshots";
	else 
		return @"Triggers";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0)
		return [[[ApplicationModel sharedModel] favoriteDevices] count];
	else if (section == 1)
		return [[[ApplicationModel sharedModel] favoriteSnapshots] count];
	else
		return [[[ApplicationModel sharedModel] favoriteTriggers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"DeviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	if ([indexPath indexAtPosition:0] == 0)
	{
		NSArray * devices = [[ApplicationModel sharedModel] favoriteDevices];
		
		Device * d = [devices objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
		
		cell.textLabel.text = [d name];
		cell.detailTextLabel.text = [d description];
		cell.imageView.image = [d statusImage];
    }
	else if ([indexPath indexAtPosition:0] == 1)
	{
		NSArray * snapshots = [[ApplicationModel sharedModel] favoriteSnapshots];
		
		Snapshot * s = [snapshots objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
		
		cell.textLabel.text = [s name];
		cell.detailTextLabel.text = [s description];
		cell.imageView.image = [UIImage imageNamed:@"snapshot.png"];
	}
	else 
	{
		NSArray * triggers = [[ApplicationModel sharedModel] favoriteTriggers];
		
		Trigger * t = [triggers objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
		
		cell.textLabel.text = [t name];
		cell.detailTextLabel.text = [t conditions];
		cell.imageView.image = [UIImage imageNamed:@"trigger.png"];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([indexPath indexAtPosition:0] == 0)
	{
		NSArray * devices = [[ApplicationModel sharedModel] favoriteDevices];
		Device * device = [devices objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
		
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
	else if ([indexPath indexAtPosition:0] == 1)
	{
		NSArray * snapshots = [[ApplicationModel sharedModel] favoriteSnapshots];
		Snapshot * snapshot = [snapshots objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
		
		SnapshotViewController * snapView = [[SnapshotViewController alloc] initWithNibName:@"SnapshotViewController" bundle:nil];
		
		snapView.snapshot = snapshot;
		
		[self.navigationController pushViewController:snapView animated:YES];
		
		[snapView release];
	}
	else
	{
		NSArray * triggers = [[ApplicationModel sharedModel] favoriteTriggers];
		Trigger * trigger = [triggers objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
		
		TriggerViewController * trigView = [[TriggerViewController alloc] initWithNibName:@"TriggerViewController" bundle:nil];
		
		trigView.trigger = trigger;
		
		[self.navigationController pushViewController:trigView animated:YES];
		
		[trigView release];
	}
}

@end

