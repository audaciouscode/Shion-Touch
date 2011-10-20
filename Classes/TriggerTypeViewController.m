//
//  TriggerTypeViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 7/12/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "TriggerTypeViewController.h"
#import "Trigger.h"
#import "ApplicationModel.h"
#import "TriggerViewController.h"

@implementation TriggerTypeViewController

@synthesize type;

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = self.type;
	
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
    return [[[ApplicationModel sharedModel] triggersForType:self.type] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"TriggerTypeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

	NSArray * triggers = [[ApplicationModel sharedModel] triggersForType:self.type];
	NSUInteger row = [indexPath indexAtPosition:1];
	
	Trigger * trigger = [triggers objectAtIndex:row];
    
	cell.textLabel.text = [trigger name];
	cell.detailTextLabel.text = [trigger description];
	cell.detailTextLabel.text = [trigger conditions];
	cell.imageView.image = [UIImage imageNamed:@"trigger.png"];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger row = [indexPath indexAtPosition:1];

	NSArray * triggers = [[ApplicationModel sharedModel] triggersForType:self.type];
	
	Trigger * trigger = [triggers objectAtIndex:row];
	
	TriggerViewController * viewController = [[TriggerViewController alloc] initWithNibName:@"TriggerViewController" bundle:nil];
	viewController.trigger = trigger;
	
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}


@end

