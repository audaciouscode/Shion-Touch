//
//  OnlineViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "OnlineViewController.h"
#import "XMPPManager.h"

@implementation OnlineViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Shion Online";
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
	if (section == 0)
		return 3;
	else
		return 1;
}

- (void) textFieldDidEndEditing:(UITextField *) textField
{
	NSString * field = textField.placeholder;
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	if ([field isEqual:@"Username"])
		[defaults setValue:textField.text forKey:@"username"];
	else if ([field isEqual:@"Password"])
		[defaults setValue:textField.text forKey:@"password"];
	else if ([field isEqual:@"Device Name"])
		[defaults setValue:textField.text forKey:@"device_name"];
	
	[defaults synchronize];
	
	[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	[textField resignFirstResponder];
	
	return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	NSUInteger section = [indexPath indexAtPosition:0];
	NSUInteger index = [indexPath indexAtPosition:1];

	if (section == 0)
	{
		static NSString *CellIdentifier = @"OnlineSettingsTextCell";

		UITextField * text = nil;

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			cell.textLabel.backgroundColor = [UIColor clearColor];

			if (index != 3)
			{
				text = [[[UITextField alloc] initWithFrame:CGRectMake(140.0, 11.0, 160.0, 44.0)] autorelease];
				text.tag = 312;

				if (index == 1)
					text.secureTextEntry = YES;
			
				text.autocapitalizationType = UITextAutocapitalizationTypeNone;
				text.autocorrectionType = UITextAutocorrectionTypeNo;
				text.keyboardType = UIKeyboardTypeASCIICapable;
				text.returnKeyType = UIReturnKeyDone;
			
				text.delegate = self;
			
				[cell.contentView addSubview:text];
			}
		}
		else
			text = (UITextField *) [cell.contentView viewWithTag:312];
	
		if (index == 0)
		{
			cell.textLabel.text = @"Username:";
			text.placeholder = @"Username";
		
			NSString * username = [defaults valueForKey:@"username"];
		
			if (username)
				text.text = username;
		} 
		else if (index == 1)
		{
			cell.textLabel.text = @"Password:";
			text.placeholder = @"Password";

			NSString * password = [defaults valueForKey:@"password"];
		
			if (password)
				text.text = password;
		} 
		else if (index == 2)
		{
			cell.textLabel.text = @"Device Name:";
			text.placeholder = @"Device Name";

			NSString * deviceName = [defaults valueForKey:@"device_name"];
		
			if (deviceName == nil)
				deviceName = [[UIDevice currentDevice] name];

			text.text = deviceName;
		} 
		else if (index == 3)
		{
			cell.textLabel.text = @"Account Status";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} 
	
		return cell;
	}
	else
	{
		static NSString *CellIdentifier = @"OnlineSettingsButtonsCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.text = @"Connect to Shion Online";
			cell.textLabel.textAlignment = UITextAlignmentCenter;
		}
		
		return cell;
	}
}

- (void) goHome:(NSTimer *) theTimer
{
	[self.navigationController popToRootViewControllerAnimated:YES];
	
	[[XMPPManager sharedManager] go];

	[theTimer release];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger section = [indexPath indexAtPosition:0];
	
	if (section == 1)
	{
		[[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(goHome:) userInfo:nil repeats:NO] retain];
	}
}

@end

