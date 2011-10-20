//
//  SnapshotViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "SnapshotViewController.h"
#import "LocationViewController.h"
#import "XMPPManager.h"
#import "ApplicationModel.h"

@implementation SnapshotViewController

@synthesize snapshot;

- (void) favorite:(id) sender
{
	NSString * imageName = @"star-small-yellow.png";
	
	if ([snapshot favorite])
		imageName = @"star-small.png";
	
	
	UIBarButtonItem * favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
																		style:UIBarButtonItemStyleBordered 
																	   target:self
																	   action:@selector(favorite:)];
	
	self.navigationItem.rightBarButtonItem = favoriteButton;
	
	[favoriteButton release];
	
	[snapshot setFavorite:([snapshot favorite] == NO)];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:self];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = [snapshot name];
	
	NSString * imageName = @"star-small.png";
	
	if ([snapshot favorite])
		imageName = @"star-small-yellow.png";
	
	UIBarButtonItem * favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
																		style:UIBarButtonItemStyleBordered 
																	   target:self
																	   action:@selector(favorite:)];
	
	self.navigationItem.rightBarButtonItem = favoriteButton;
	
	[favoriteButton release];

	[super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return @"Actions";
	else
		return @"Devices";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0)
		return 1;
	else
		return [self.snapshot.devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell * cell = nil;
	
	if ([indexPath indexAtPosition:0] > 0)
		cell = 	[tableView dequeueReusableCellWithIdentifier:@"SnapshotDeviceCell"];
	else
		cell = [tableView dequeueReusableCellWithIdentifier:@"SnapshotActivateCell"];

    if (cell == nil) 
	{
		if ([indexPath indexAtPosition:0] > 0)
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SnapshotDeviceCell"] autorelease];
		else
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SnapshotActivateCell"] autorelease];
	}
	
	if ([indexPath indexAtPosition:0] > 0)
	{
		NSInteger index = [indexPath indexAtPosition:([indexPath length] - 1)];
	
		NSDictionary * deviceDict = [snapshot.devices objectAtIndex:index];
	
		cell.textLabel.text = [deviceDict valueForKey:@"name"];
		
		Device * d = [[ApplicationModel sharedModel] deviceForIdentifier:[deviceDict valueForKey:@"identifier"]];
		
		NSString * deviceDescription = @"Unknown";
		
		if (d != nil)
			deviceDescription = [d shortDescription];
		
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (Current %@)", [deviceDict valueForKey:@"description"], deviceDescription];
	}
	else
	{
		cell.textLabel.text = [NSString stringWithFormat:@"Activate %@", [snapshot name]];
		cell.detailTextLabel.text = @"Configures the devices as shown below.";
		cell.imageView.image = [UIImage imageNamed:@"snapshot_activate.png"];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger index = [indexPath indexAtPosition:0];
	
	if (index == 0)
	{
		NSString * command = [NSString stringWithFormat:@"shion:activateSnapshot(\"%@\")", [snapshot identifier]];
		
		[[XMPPManager sharedManager] sendCommand:command forSnapshot:snapshot];
	}
	
	[tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

@end
