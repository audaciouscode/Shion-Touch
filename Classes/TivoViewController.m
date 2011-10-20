//
//  TivoViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TivoViewController.h"

#import "TivoRemoteViewController.h"
#import "TivoFolderViewController.h"
#import "TivoShowViewController.h"

@implementation TivoViewController

@synthesize device;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = [self.device name];
	
	NSString * imageName = @"star-small.png";
	
	if ([device favorite])
		imageName = @"star-small-yellow.png";
	
	UIBarButtonItem * favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
																		style:UIBarButtonItemStyleBordered 
																	   target:self
																	   action:@selector(favorite:)];
	self.navigationItem.rightBarButtonItem = favoriteButton;
	
	[favoriteButton release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"model_updated" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"view_refresh" object:nil];
	
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"view_refresh" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"model_updated" object:nil];
	
    [super viewWillDisappear:animated];
}

- (void) favorite:(id) sender
{
	NSString * imageName = @"star-small-yellow.png";
	
	if ([device favorite])
		imageName = @"star-small.png";
	
	
	UIBarButtonItem * favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
																		style:UIBarButtonItemStyleBordered 
																	   target:self
																	   action:@selector(favorite:)];
	
	self.navigationItem.rightBarButtonItem = favoriteButton;
	
	[favoriteButton release];
	
	[device setFavorite:([device favorite] == NO)];
}

- (void) reload:(NSNotification *) theNote
{
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section
{
//	if (section == 0)
//		return @"Remote Control";

	return @"Recorded Programs";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
//	if (section == 1)
		return [[device shows] count];
	
//    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger row = [indexPath indexAtPosition:1];
	
	UITableViewCell * cell = nil;
	
/*    if (section == 0)
	{
		NSString * cellIdentifier = @"TivoRemoteCellIdentifier";
		
		cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;

		cell.textLabel.text = @"Remote Control";
		cell.imageView.image = [UIImage imageNamed:@"tivo_remote.png"];
	}
    else if (section == 1)
	{
*/		NSString * cellIdentifier = @"TivoShowCellIdentifier";
		
		cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;

		NSDictionary * show = [[device shows] objectAtIndex:row];

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
//	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger row = [indexPath indexAtPosition:1];

	UIViewController * controller = nil;

	NSDictionary * item = [[self.device shows] objectAtIndex:row];
		
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

