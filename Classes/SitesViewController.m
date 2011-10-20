//
//  SitesViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "SitesViewController.h"
#import "ApplicationModel.h"
#import "SiteViewController.h"

@implementation SitesViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Sites";
	
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
	NSArray * sites = [[ApplicationModel sharedModel] allSites];
	
	return [sites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"AllSitesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSArray * sites = [[ApplicationModel sharedModel] allSites];
	
	NSString * s = [sites objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	cell.textLabel.text = s;
	
	NSArray * snapshots = [[ApplicationModel sharedModel] snapshotsAtSite:s];
	
	NSUInteger count = [snapshots count];
	
	if (count == 1)
		cell.detailTextLabel.text = [NSString stringWithFormat:@"1 snapshot: %@", [[snapshots lastObject] name]];
	else
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d snapshots", count];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSArray * sites = [[ApplicationModel sharedModel] allSites];
	
	NSString * site = [sites objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	SiteViewController * controller = [[SiteViewController alloc] initWithNibName:@"SiteViewController" bundle:nil];
	controller.site = site;
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
}


@end

