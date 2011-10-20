//
//  PlatformsViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "PlatformsViewController.h"
#import "PlatformViewController.h"

#import "ApplicationModel.h"

@implementation PlatformsViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Platforms";
	
    [super viewWillAppear:animated];
	
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
	NSArray * platforms = [[ApplicationModel sharedModel] allPlatforms];
	
	return [platforms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"AllPlatformsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSArray * platforms = [[ApplicationModel sharedModel] allPlatforms];
	
	NSString * p = [platforms objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	cell.textLabel.text = p;
	
	NSArray * devices = [[ApplicationModel sharedModel] devicesWithPlatform:p];
	
	NSUInteger count = [devices count];
	
	if (count == 1)
		cell.detailTextLabel.text = [NSString stringWithFormat:@"1 device: %@", [[devices lastObject] name]];
	else
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d devices", count];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSArray * platforms = [[ApplicationModel sharedModel] allPlatforms];
	
	NSString * platform = [platforms objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	PlatformViewController * controller = [[PlatformViewController alloc] initWithNibName:@"PlatformViewController" bundle:nil];
	controller.platform = platform;
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
}

@end

