//
//  ThermostatModeViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "ThermostatModeViewController.h"
#import "XMPPManager.h"

@implementation ThermostatModeViewController

@synthesize thermostat;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
		options = [[NSArray arrayWithObjects:@"Off", @"Auto", @"Heat", @"Cool", nil] retain];

	return self;
}

- (void) dealloc
{
	[options release];
	
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = @"Thermostat Mode";
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloth.png"]]; // [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0];
	table.backgroundColor = [UIColor clearColor];
	
	[super viewWillAppear:animated];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"ThermostatModeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSInteger selected = [indexPath indexAtPosition:([indexPath length] - 1)];
	
	NSString * option = [options objectAtIndex:selected];
	
	cell.textLabel.text = option;

	if ([[thermostat mode] isEqual:option])
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger selected = [indexPath indexAtPosition:([indexPath length] - 1)];
	
	NSString * option = [options objectAtIndex:selected];
	
	[thermostat setValue:option forKey:@"thermostat_mode"]; // TODO: Setter
	
	[self.navigationController popViewControllerAnimated:YES];
	
	NSString * command = [NSString stringWithFormat:@"shion:setMode_forThermostat(\"%@\", \"%@\")", option, [thermostat identifier]];
	[[XMPPManager sharedManager] sendCommand:command forDevice:thermostat];
}

@end
