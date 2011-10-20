//
//  CategoryViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "CategoryViewController.h"

#import "Snapshot.h"
#import "SnapshotViewController.h"
#import "ApplicationModel.h"

@implementation CategoryViewController

@synthesize category;

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = self.category;
	
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
	return [[[ApplicationModel sharedModel] snapshotsWithCategory:self.category] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"SnapshotCategoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	NSArray * snapshots = [[ApplicationModel sharedModel] snapshotsWithCategory:self.category];
	
	Snapshot * s = [snapshots objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	cell.textLabel.text = [s name];
	cell.detailTextLabel.text = [s description];
	cell.imageView.image = [UIImage imageNamed:@"snapshot.png"];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSArray * viewControllers = self.navigationController.viewControllers;
	
	UIViewController * previousController = nil;
	
	if ([viewControllers count] > 2)
		previousController = [viewControllers objectAtIndex:([viewControllers count] - 2)];
	
	Snapshot * snapshot = [[[ApplicationModel sharedModel] snapshotsWithCategory:self.category] objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];

	if (previousController && [previousController isKindOfClass:[SnapshotViewController class]])
	{
		SnapshotViewController * prevDevController = (SnapshotViewController *) previousController;
		
		if (prevDevController.snapshot == snapshot)
		{
			[self.navigationController popViewControllerAnimated:YES];
			
			return;
		}
	}
	
	SnapshotViewController * controller = [[[SnapshotViewController alloc] initWithNibName:@"SnapshotViewController" bundle:nil] autorelease];
	
	controller.snapshot = snapshot;
	
	[self.navigationController pushViewController:controller animated:YES];
}

@end

