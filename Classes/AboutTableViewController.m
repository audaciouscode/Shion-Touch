//
//  AboutTableViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 5/27/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "AboutTableViewController.h"


@implementation AboutTableViewController


- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Credits";
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloth.png"]]; // [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0];
	self.view.backgroundColor = [UIColor clearColor];
	
	[super viewWillAppear:animated];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0)
		return 1;
	else if (section == 1)
		return 8;
	else
		return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"AboutTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	NSUInteger index = [indexPath indexAtPosition:0];
	
	if (index == 0)
	{
		cell.textLabel.text = @"Chris J. Karr";
		cell.detailTextLabel.text = @"Creator";
	}
	else if (index == 1)
	{
		NSUInteger subindex = [indexPath indexAtPosition:1];

		if (subindex == 0)
		{
			cell.textLabel.text = @"Kevin Andersson";
			cell.detailTextLabel.text = @"Icons (Icondesign.dk)";
		}
		else if (subindex == 1)
		{
			cell.textLabel.text = @"Ahmed Abdelkader";
			cell.detailTextLabel.text = @"PhoneNumberFormatter";
		}
		else if (subindex == 2)
		{
			cell.textLabel.text = @"Eddie Wilson";
			cell.detailTextLabel.text = @"iPhone UI Icon Set";
		}
		else if (subindex == 3)
		{
			cell.textLabel.text = @"The KissXML Team";
			cell.detailTextLabel.text = @"KissXML Framework";
		}
		else if (subindex == 4)
		{
			cell.textLabel.text = @"Deusty Designs LLC";
			cell.detailTextLabel.text = @"xmppframework";
		}
		else if (subindex == 5)
		{
			cell.textLabel.text = @"Septicus Software";
			cell.detailTextLabel.text = @"SSCrypto Framework";
		}
		else if (subindex == 6)
		{
			cell.textLabel.text = @"Michael Waterfall";
			cell.detailTextLabel.text = @"NSString+XMLEntities.[mh]";
		}
		else if (subindex == 8)
		{
			cell.textLabel.text = @"Facebook";
			cell.detailTextLabel.text = @"Three20 Framework";
		}
	}
	else
	{
		cell.textLabel.text = @"Shion Touch © 2010";
		cell.detailTextLabel.text = @"CASIS LLC";
	}

    return cell;
}

@end

