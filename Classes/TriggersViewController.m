//
//  TriggersViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 7/12/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "TriggersViewController.h"
#import "ApplicationModel.h"
#import "TriggerTypeViewController.h"

@implementation TriggersViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"All Triggers";
	
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [[[ApplicationModel sharedModel] triggerTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"AllTriggersCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	NSArray * triggerTypes = [[ApplicationModel sharedModel] triggerTypes];
	NSUInteger row = [indexPath indexAtPosition:1];

	NSString * type = [triggerTypes objectAtIndex:row];
    
	cell.textLabel.text = type;
	
	NSUInteger typeCount = [[[ApplicationModel sharedModel] triggersForType:type] count];
	
	if (typeCount == 1)
		cell.detailTextLabel.text = @"1 trigger";
	else
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d triggers", typeCount];

	cell.imageView.image = [UIImage imageNamed:@"trigger.png"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSArray * triggerTypes = [[ApplicationModel sharedModel] triggerTypes];
	NSUInteger row = [indexPath indexAtPosition:1];
	
	NSString * type = [triggerTypes objectAtIndex:row];
	
	TriggerTypeViewController * viewController = [[TriggerTypeViewController alloc] initWithNibName:@"TriggerTypeViewController" bundle:nil];
	viewController.type = type;
	
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

@end

