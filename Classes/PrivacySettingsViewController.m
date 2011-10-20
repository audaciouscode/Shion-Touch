//
//  PrivacySettingsViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "PrivacySettingsViewController.h"
#import "LocationManager.h"

#import "Camera.h"
#import "Device.h"
#import "ApplicationModel.h"

@implementation PrivacySettingsViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Privacy Settings";
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloth.png"]]; // [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0];
	self.view.backgroundColor = [UIColor clearColor];
	
	[super viewWillAppear:animated];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}

- (IBAction) setReportsLocation:(id) sender
{
	UISwitch * toggle = sender;
	
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:toggle.on] forKey:@"report_location"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
//	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	NSUInteger section = [indexPath indexAtPosition:0];
	NSUInteger index = [indexPath indexAtPosition:1];
	
	if (section == 0)
	{
		UISwitch * toggle = nil;
		NSString *CellIdentifier = @"PrivacySettingsCellLocation";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
			cell.textLabel.backgroundColor = [UIColor clearColor];

			toggle = [[[UISwitch alloc] initWithFrame:CGRectMake(198.0, 8.0, 160.0, 44.0)] autorelease];
		
			[toggle setOn:[[LocationManager sharedManager] reportsLocation] animated:NO];
			[toggle addTarget:self action:@selector(setReportsLocation:) forControlEvents:UIControlEventValueChanged];
		
			[cell.contentView addSubview:toggle];
		}

		if (index == 0)
		{
			cell.textLabel.text = @"Report Location:";
		} 
	
		return cell;
	}
	else if (section == 1)
	{
		NSString *CellIdentifier = @"PrivacySettingsCellPhotos";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.backgroundColor = [UIColor clearColor];
			
			cell.textLabel.text = @"Clear Camera Caches";
			cell.textLabel.textAlignment = UITextAlignmentCenter;
		}
		
		return cell;
	}
	
	return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger section = [indexPath indexAtPosition:0];

	if (section == 1)
	{
		for (Device * device in [[ApplicationModel sharedModel] allDevices])
		{
			if ([device isKindOfClass:[Camera class]])
			{
				Camera * camera = (Camera *) device;
				
				[camera clearPhotos];
			}
		}
	}
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

