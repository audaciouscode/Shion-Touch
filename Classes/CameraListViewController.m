//
//  CameraListViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 12/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraListViewController.h"

#import "Camera.h"

#import "OnePhotoViewController.h"
#import "CameraPhoto.h"

@implementation CameraListViewController

@synthesize device;

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
	
    [super viewWillAppear:animated];
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

#pragma mark Table view methods

- (IBAction) captureImage
{
	Camera * camera = (Camera *) self.device;

	[camera captureImage];
}

- (NSArray *) photosForDateString:(NSString *) dateString
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEEE, MMMM d, yyyy"];

	NSMutableArray * matches = [NSMutableArray array];
	
	Camera * camera = (Camera *) self.device;
	
	NSArray * photos = [camera photos];
	
	for (NSMutableDictionary * photo in photos)
	{
		NSString * photoDate = [formatter stringFromDate:[photo valueForKey:@"date"]];
		
		if ([dateString isEqual:photoDate])
			[matches addObject:photo];
	}
	
	[formatter release];

	return matches;
}

- (NSArray *) dateStrings
{
	NSMutableArray * dateStrings = [NSMutableArray array];
	
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEEE, MMMM d, yyyy"];

	Camera * camera = (Camera *) self.device;

	NSArray * photos = [camera photos];
	
	for (NSDictionary * photo in photos)
	{
		NSString * dateString = [formatter stringFromDate:[photo valueForKey:@"date"]];
		
		if (![dateStrings containsObject:dateString])
			[dateStrings addObject:dateString];
	}
	
	[formatter release];

	return dateStrings;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [[self dateStrings] count] + 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return @"Camera Actions";
	
	return [[self dateStrings] objectAtIndex:(section - 1)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0)
		return 1;
	
	return [[self photosForDateString:[[self dateStrings] objectAtIndex:(section - 1)]]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"CameraDeviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
	if ([indexPath indexAtPosition:0] == 0)
	{
		cell.textLabel.text = @"Capture Image";
		cell.detailTextLabel.text = @"Records the current image";
		cell.imageView.image = [UIImage imageNamed:@"device_type_camera"];
	}
	else
	{
		NSMutableDictionary * photo = [[self photosForDateString:[[self dateStrings] objectAtIndex:([indexPath indexAtPosition:0] - 1)]] objectAtIndex:[indexPath indexAtPosition:1]];
	
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"h:mm a"];
		cell.textLabel.text = [formatter stringFromDate:[photo valueForKey:@"date"]];
		[formatter release];
		
		cell.imageView.image = [photo valueForKey:@"uiimage"];
		cell.detailTextLabel.text = device.site;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([indexPath indexAtPosition:0] == 0)
	{
		[self captureImage];
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else
	{
		NSDictionary * photo = [[self photosForDateString:[[self dateStrings] objectAtIndex:([indexPath indexAtPosition:0] - 1)]] objectAtIndex:[indexPath indexAtPosition:1]];

		CameraPhoto * cp = [[CameraPhoto alloc] initWithURLString:[photo valueForKey:@"url"]];
	
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"h:mm a"];
		cp.title = [formatter stringFromDate:[photo valueForKey:@"date"]];
		[formatter release];
	
		OnePhotoViewController * controller = [[OnePhotoViewController alloc] initWithPhoto:cp];
		controller.navigationBarStyle = UIBarStyleBlackOpaque;
		controller.statusBarStyle = UIStatusBarStyleBlackOpaque;
		
		[self.navigationController pushViewController:controller animated:YES];
		[cp release];
		[controller release];
	}
}

@end

