//
//  TriggerViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 7/4/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "TriggerViewController.h"
#import "XMPPManager.h"

@implementation TriggerViewController

@synthesize trigger;

- (void) favorite:(id) sender
{
	NSString * imageName = @"star-small-yellow.png";
	
	if ([trigger favorite])
		imageName = @"star-small.png";
	
	
	UIBarButtonItem * favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
																		style:UIBarButtonItemStyleBordered 
																	   target:self
																	   action:@selector(favorite:)];
	
	self.navigationItem.rightBarButtonItem = favoriteButton;
	
	[favoriteButton release];
	
	[trigger setFavorite:([trigger favorite] == NO)];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:self];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = [trigger name];
	
	NSString * imageName = @"star-small.png";
	
	if ([trigger favorite])
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
		return @"Details";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0)
		return 1;
	else
		return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell * cell = nil;
	
	if ([indexPath indexAtPosition:0] > 0)
		cell = 	[tableView dequeueReusableCellWithIdentifier:@"TriggerDetailCell"];
	else
		cell = [tableView dequeueReusableCellWithIdentifier:@"TriggerActivateCell"];
	
    if (cell == nil) 
	{
		if ([indexPath indexAtPosition:0] > 0)
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"TriggerDetailCell"] autorelease];
		else
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TriggerActivateCell"] autorelease];
	}
	
	if ([indexPath indexAtPosition:0] > 0)
	{
		NSUInteger row = [indexPath indexAtPosition:1];
		
		if (row == 0)
		{
			cell.textLabel.text = @"Type";
			cell.detailTextLabel.text = [trigger type];
		}
		else if (row == 1)
		{
			cell.textLabel.text = @"Action";
			cell.detailTextLabel.text = [trigger action];
		}
		else if (row == 2)
		{
			cell.textLabel.text = @"Last Fired";

			if ([trigger fired] != nil)
			{
				NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
				[formatter setDateStyle:NSDateFormatterLongStyle];
				[formatter setTimeStyle:NSDateFormatterShortStyle];
				cell.detailTextLabel.text = [formatter stringFromDate:[trigger fired]];
			
				[formatter release];
			}
			else
				cell.detailTextLabel.text = @"Never";
		}
		else if (row == 3)
		{
			cell.textLabel.text = @"Conditions";
			cell.detailTextLabel.text = [trigger conditions];
		}
	}
	else
	{
		cell.textLabel.text = [NSString stringWithFormat:@"Activate %@", [trigger name]];
		cell.detailTextLabel.text = @"Simulates the trigger activation conditions.";
		cell.imageView.image = [UIImage imageNamed:@"snapshot_activate.png"];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger index = [indexPath indexAtPosition:0];
	
	if (index == 0)
	{
		NSString * command = [NSString stringWithFormat:@"shion:fireTrigger(\"%@\")", [trigger identifier]];
		
		[[XMPPManager sharedManager] sendCommand:command forTrigger:trigger];
	}

	[tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

@end

