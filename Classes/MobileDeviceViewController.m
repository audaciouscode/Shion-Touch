//
//  MobileDeviceViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 8/17/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "MobileDeviceViewController.h"
#import "MobileDeviceLocationViewController.h"
#import "PhoneNumberFormatter.h"

@implementation MobileDeviceViewController

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

	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloth.png"]]; // [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0];
	self.view.backgroundColor = [UIColor clearColor];
	
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

#pragma mark -
#pragma mark View lifecycle

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0)
		return 4;
	else if (section == 1)
		return 2;
		
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger section = [indexPath indexAtPosition:0];
	NSUInteger row = [indexPath indexAtPosition:1];

	UITableViewCell * cell = nil;
	
	PhoneNumberFormatter * formatter = [[PhoneNumberFormatter alloc] init];
	
    if (section == 0)
	{
		NSString * cellIdentifier = @"MobileDeviceMetadataCellIdentifier";
		
		cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

		if (cell == nil) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];

		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;

		if (row == 0)
		{
			NSString * address = [device address];
			
			if ([address isEqual:@""])
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.detailTextLabel.text = @"Unavailable";
			}
			else
			{
				if ([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound)
				{
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				}
				cell.detailTextLabel.text = [formatter format:[device address] withLocale:@"us"];
			}

			cell.textLabel.text = @"Phone Number";
		}
		else if (row == 1)
		{
			cell.textLabel.text = @"Platform";
			cell.detailTextLabel.text = [device platform];
		}
		else if (row == 2)
		{
			cell.textLabel.text = @"Hardware";
			cell.detailTextLabel.text = [device model];
		}
		else if (row == 3)
		{
			cell.textLabel.text = @"Software";
			cell.detailTextLabel.text = [device version];
		}
	}
    else if (section == 1)
	{
		NSString * cellIdentifier = @"MobileDeviceLocationCellIdentifier";
		
		cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		if (row == 0)
		{
			cell.textLabel.text = @"Status";
			cell.detailTextLabel.text = [device status];
		}
		else if (row == 1)
		{
			cell.textLabel.text = @"Location";
			
			if ([device latitude] != nil && [device longitude] != nil)
			{
				cell.detailTextLabel.text = @"View Map";
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			}
			else
			{
				cell.detailTextLabel.text = @"Unknown";
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
	}
    else if (section == 2)
	{
		NSString * cellIdentifier = @"MobileDeviceCallerCellIdentifier";
		
		cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		NSString * caller = [device lastCaller];
		
		if ([caller isEqual:@""] || [caller isEqual:@"Unavailable"])
		{
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.detailTextLabel.text = @"Unavailable";
		}
		else
		{
			if ([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound)
			{
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			
			cell.detailTextLabel.text = [formatter format:caller withLocale:@"us"];
		}
		
		cell.textLabel.text = @"Last Caller";
	}
    else if (section == 3)
	{
		NSString * cellIdentifier = @"MobileDeviceBeaconCellIdentifier";
		
		cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		
		cell.textLabel.text = @"Activate Beacon";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	}
    
	[formatter release];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger section = [indexPath indexAtPosition:0];
	NSUInteger row = [indexPath indexAtPosition:1];

	if (section == 1 && row == 1)
	{
		if ([device latitude] != nil && [device longitude] != nil)
		{
			MobileDeviceLocationViewController * controller = [[MobileDeviceLocationViewController alloc] initWithNibName:@"MobileDeviceLocationViewController" bundle:nil];
			controller.device = device;
			
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
	}
	else if (section == 0 && row == 0)
	{
		if ([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound)
		{
			NSString * address = [device address];
			
			if (![address isEqual:@""])
			{
				NSString * message = [NSString stringWithFormat:@"Call %@", [device name]];
			
				UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:message
																	 delegate:self
															cancelButtonTitle:@"Ignore"
													   destructiveButtonTitle:@"Place Call"
															otherButtonTitles:nil, nil];
			
				[action showInView:[[UIApplication sharedApplication] keyWindow]];
			}
		}
	}
	else if (section == 2)
	{
		NSString * caller = [device lastCaller];
		
		if (![caller isEqual:@""] && ![caller isEqual:@"Unavailable"])
		{
			if ([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound)
			{
				PhoneNumberFormatter * phoneFormatter = [[PhoneNumberFormatter alloc] init];
				
				NSString * message = [NSString stringWithFormat:@"Call %@", [phoneFormatter format:caller withLocale:@"us"]];
				
				[phoneFormatter release];
				
				UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:message
																	 delegate:self
															cancelButtonTitle:@"Ignore"
													   destructiveButtonTitle:@"Place Call"
															otherButtonTitles:nil, nil];
				
				[action showInView:[[UIApplication sharedApplication] keyWindow]];
			}
		}
	}
	else if (section == 3)
	{
		[device beacon];
	}

	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([actionSheet.title isEqual:[NSString stringWithFormat:@"Call %@", [device name]]])
	{
		NSString * address = [device address];
		
		if (![address isEqual:@""])
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", address]]];
	}
	else
	{
		NSString * caller = [device lastCaller];
		
		if (![caller isEqual:@""])
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", caller]]];
	}
	
	[actionSheet autorelease];
}


@end

