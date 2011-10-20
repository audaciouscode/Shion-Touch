//
//  SnapshotsViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "SnapshotsViewController.h"
#import "ApplicationModel.h"

#import "AllSnapshotsViewController.h"
#import "CategoriesViewController.h"
#import "SitesViewController.h"

@implementation SnapshotsViewController

@synthesize options;

- (NSString *) detailsForOption:(NSString *) option
{
	if ([option isEqual:@"All Snapshots"])
	{
		NSArray * snapshots = [[ApplicationModel sharedModel] allSnapshots];
		
		NSUInteger count = [snapshots count];
		
		if (count == 1)
			return [NSString stringWithFormat:@"1 snapshot: %@", [[snapshots lastObject] name]];
		else
			return [NSString stringWithFormat:@"%d snapshots", count];
	}
	else if ([option isEqual:@"By Category"])
	{
		NSArray * categories = [[ApplicationModel sharedModel] allCategories];
		
		NSUInteger count = [categories count];
		
		if (count == 1)
			return [NSString stringWithFormat:@"1 category: %@", [categories lastObject]];
		else
			return [NSString stringWithFormat:@"%d locations", count];
	}
	else if ([option isEqual:@"By Site"])
	{
		NSArray * sites = [[ApplicationModel sharedModel] allSites];
		
		NSUInteger count = [sites count];
		
		if (count == 1)
			return [NSString stringWithFormat:@"1 site: %@", [sites lastObject]];
		else
			return [NSString stringWithFormat:@"%d sites", count];
	}
	else
		return [NSString stringWithFormat:@"TODO: %@", option];
}

- (UIImage *) imageForOption:(NSString *) option
{
	if ([option isEqual:@"All Snapshots"])
		return [UIImage imageNamed:@"snapshots_all.png"];
	else if ([option isEqual:@"By Category"])
		return [UIImage imageNamed:@"snapshots_categories.png"];
	else if ([option isEqual:@"By Site"])
		return [UIImage imageNamed:@"snapshots_site.png"];
	else
		return nil;
}

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Snapshots";
	
    [super viewWillAppear:animated];
	
	self.options = [NSArray arrayWithObjects:@"All Snapshots", @"By Category", @"By Site", nil];
	
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
    static NSString * CellIdentifier = @"SnapshotsCell";
    
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
	if ([option isEqual:@"All Snapshots"])
		return [[[AllSnapshotsViewController alloc] initWithNibName:@"AllSnapshotsViewController" bundle:nil] autorelease];
	else if ([option isEqual:@"By Category"])
		return [[[CategoriesViewController alloc] initWithNibName:@"CategoriesViewController" bundle:nil] autorelease];
	else if ([option isEqual:@"By Site"])
		return [[[SitesViewController alloc] initWithNibName:@"SitesViewController" bundle:nil] autorelease];
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSString * option = [self.options objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	UIViewController * controller = [self viewControllerForOption:option];
	
	if (controller != nil)
		[self.navigationController pushViewController:controller animated:YES];
}

@end

