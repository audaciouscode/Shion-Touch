//
//  DisplaySettingsViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "DisplaySettingsViewController.h"

@implementation DisplaySettingsViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Display Settings";
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloth.png"]]; // [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0];
	self.view.backgroundColor = [UIColor clearColor];
	
	[super viewWillAppear:animated];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 2;
}

- (IBAction) setShowsMobileClient:(id) sender
{
	UISwitch * toggle = sender;
	
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:toggle.on] forKey:@"show_mobile_clients"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Restart Shion Touch" message:@"Please restart Shion Touch for these changes to take effect." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (IBAction) setShowsControls:(id) sender
{
	UISwitch * toggle = sender;
	
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:toggle.on] forKey:@"show_controls"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
//	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	NSUInteger index = [indexPath indexAtPosition:1];
	
    static NSString *CellIdentifier = @"DisplaySettingsCell";
	
	UISwitch * toggle = nil;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		cell.textLabel.backgroundColor = [UIColor clearColor];

		toggle = [[[UISwitch alloc] initWithFrame:CGRectMake(198.0, 8.0, 160.0, 44.0)] autorelease];

		[cell.contentView addSubview:toggle];
    }

	if (index == 0)
	{
		cell.textLabel.text = @"Show Controls:";
		
		toggle.on = YES;
		
		id show = [[NSUserDefaults standardUserDefaults] valueForKey:@"show_controls"];
		
		if (show != nil)
			toggle.on = [show boolValue];
		
		[toggle addTarget:self action:@selector(setShowsControls:) forControlEvents:UIControlEventValueChanged];
	}
	if (index == 1)
	{
		cell.textLabel.text = @"Show Mobile Clients:";

		toggle.on = NO;
		
		id show = [[NSUserDefaults standardUserDefaults] valueForKey:@"show_mobile_clients"];

		if (show != nil)
			toggle.on = [show boolValue];
		
		[toggle addTarget:self action:@selector(setShowsMobileClient:) forControlEvents:UIControlEventValueChanged];
	} 
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	/* NSUInteger index = [indexPath indexAtPosition:1];
	
	if (index == 3)
	{
		UIAlertView * error = [[UIAlertView alloc] initWithTitle:@"Account Status" 
														 message:@"This feature is not implemented." 
														delegate:self 
											   cancelButtonTitle:@"Dismiss" 
											   otherButtonTitles:nil];
		[error show];
		[error release];
	} */
}

@end

