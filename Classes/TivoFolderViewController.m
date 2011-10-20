//
//  TivoFolderViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TivoFolderViewController.h"

#import "TivoShowViewController.h"

@implementation TivoFolderViewController

@synthesize folder;
@synthesize device;

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = [folder valueForKey:@"title"];
	
	[super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [[folder valueForKey:@"children"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger row = [indexPath indexAtPosition:1];
	
	UITableViewCell * cell = nil;
	
	NSString * cellIdentifier = @"TivoShowCellIdentifier";
		
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
	if (cell == nil) 
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		
	NSDictionary * show = [[folder valueForKey:@"children"] objectAtIndex:row];
		
	cell.textLabel.text = [show valueForKey:@"title"];
		
	if ([show valueForKey:@"children"] != nil)
	{
		cell.imageView.image = [UIImage imageNamed:@"tivo_folder.png"];
			
		NSUInteger count = [device countShows:[show valueForKey:@"children"]];
			
		if (count == 1)
			cell.detailTextLabel.text = @"1 recording";
		else
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d recordings", count];
	}
	else
	{
		cell.imageView.image = [UIImage imageNamed:@"tivo_show.png"];
		cell.detailTextLabel.text = [show valueForKey:@"episode"];
	}		
		
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger row = [indexPath indexAtPosition:1];
	
	UIViewController * controller = nil;
	
	NSDictionary * item = [[folder valueForKey:@"children"] objectAtIndex:row];
		
	if ([item valueForKey:@"children"] != nil)
	{
		TivoFolderViewController * c = [[TivoFolderViewController alloc] initWithNibName:@"TivoFolderViewController" bundle:nil];
		c.folder = item;
		c.device = device;
		
		controller = c;
	}
	else
	{
		TivoShowViewController * c = [[TivoShowViewController alloc] initWithNibName:@"TivoShowViewController" bundle:nil];
		c.show = item;
			
		controller = c;
	}
	
	if (controller != nil)
		[self.navigationController pushViewController:controller animated:YES];
}


@end

