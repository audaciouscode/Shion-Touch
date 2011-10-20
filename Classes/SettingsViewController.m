//
//  SettingsViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "SettingsViewController.h"

#import "OnlineViewController.h"
#import "DisplaySettingsViewController.h"
#import "PrivacySettingsViewController.h"
#import "AboutTableViewController.h"

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Settings";
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
	NSUInteger index = [indexPath indexAtPosition:1];
	
	if (index == 0)
		cell.textLabel.text = @"Shion Online Settings";
	else if (index == 1)
		cell.textLabel.text = @"Display Settings";
	else if (index == 2)
		cell.textLabel.text = @"Privacy Settings";
	else if (index == 3)
		cell.textLabel.text = @"Send Feedback";
	else
		cell.textLabel.text = @"About Shion Touch";
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger index = [indexPath indexAtPosition:1];

	if (index == 0)
	{
		OnlineViewController * controller = [[OnlineViewController alloc] initWithNibName:@"OnlineViewController" bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	else if (index == 1)
	{
		DisplaySettingsViewController * controller = [[DisplaySettingsViewController alloc] initWithNibName:@"DisplaySettingsViewController" bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}		
	else if (index == 2)
	{
		PrivacySettingsViewController * controller = [[PrivacySettingsViewController alloc] initWithNibName:@"PrivacySettingsViewController" bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}		
	else if (index == 3)
	{
		MFMailComposeViewController * controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		
		[controller setToRecipients:[NSArray arrayWithObject:@"feedback@shiononline.com"]];
		[controller setSubject:@"Shion Touch Feedback"];
		[controller setMessageBody:@"Please enter your feedback here." isHTML:NO];
		controller.navigationBar.barStyle = UIBarStyleBlack;
		
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}		
	else 
	{
		AboutTableViewController * controller = [[AboutTableViewController alloc] initWithNibName:@"AboutTableViewController" bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*) controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*) error
{ 
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
			
		default:
		{
			UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Email" 
															 message:@"Sending Failed – Unknown Error"
															delegate:self 
												   cancelButtonTitle:@"OK" 
												   otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}

	[self dismissModalViewControllerAnimated:YES];
}

@end

