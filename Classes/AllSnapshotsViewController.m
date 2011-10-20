//
//  AllSnapshotsViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "AllSnapshotsViewController.h"

#import "SnapshotViewController.h"

#import "ApplicationModel.h"
#import "Snapshot.h"

@implementation AllSnapshotsViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"All Snapshots";
	
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
	NSArray * snapshots = [[ApplicationModel sharedModel] allSnapshots];
	
	return [snapshots count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"AllSnapshotsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSArray * snapshots = [[ApplicationModel sharedModel] allSnapshots];
	
	Snapshot * s = [snapshots objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	cell.textLabel.text = [s name];
    cell.detailTextLabel.text = [s description];
	cell.imageView.image = [UIImage imageNamed:@"snapshot.png"];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	Snapshot * snapshot = [[[ApplicationModel sharedModel] allSnapshots] objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	SnapshotViewController * controller = [[[SnapshotViewController alloc] initWithNibName:@"SnapshotViewController" bundle:nil] autorelease];
	
	controller.snapshot = snapshot;
	
	[self.navigationController pushViewController:controller animated:YES];
}


@end

