//
//  TypesViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "TypesViewController.h"
#import "TypeViewController.h"

#import "ApplicationModel.h"

@implementation TypesViewController

- (UIImage *) imageForType:(NSString *) type
{
	if ([type isEqual:@"Appliance"])
		return [UIImage imageNamed:@"device_type_appliance.png"];
	else if ([type isEqual:@"Controller"])
		return [UIImage imageNamed:@"device_type_controller.png"];
	else if ([type isEqual:@"Lamp"])
		return [UIImage imageNamed:@"device_type_lamp.png"];
	else if ([type isEqual:@"Motion Sensor"])
		return [UIImage imageNamed:@"device_type_motion.png"];
	else if ([type isEqual:@"Telephone / Modem"])
		return [UIImage imageNamed:@"device_type_phone.png"];
	else if ([type isEqual:@"Thermostat"])
		return [UIImage imageNamed:@"device_type_thermostat.png"];
	else if ([type isEqual:@"House"])
		return [UIImage imageNamed:@"device_type_house.png"];
	else if ([type isEqual:@"Chime"])
		return [UIImage imageNamed:@"device_type_chime.png"];
	else if ([type isEqual:@"Mobile Device"])
		return [UIImage imageNamed:@"device_type_mobile.png"];
	else if ([type isEqual:@"Camera"])
		return [UIImage imageNamed:@"device_type_camera.png"];
	else if ([type isEqual:@"Power Sensor"])
		return [UIImage imageNamed:@"device_type_power.png"];
	else if ([type isEqual:@"Power Meter"])
		return [UIImage imageNamed:@"device_type_meter.png"];
	else if ([type isEqual:@"TiVo Digital Video Recorder"])
		return [UIImage imageNamed:@"device_type_tivo.png"];
	else if ([type isEqual:@"Lock"])
		return [UIImage imageNamed:@"device_type_lock.png"];
	else if ([type isEqual:@"Weather Sensor"])
		return [UIImage imageNamed:@"device_type_weather.png"];
	
	return [UIImage imageNamed:@"device_type_misc.png"];
}

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Types";
	
    [super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"model_updated" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"model_updated" object:nil];
	
    [super viewWillAppear:animated];
}

- (void) reload:(NSNotification *) theNote
{
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSArray * types = [[ApplicationModel sharedModel] allTypes];
	
	return [types count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"AllTypesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSArray * types = [[ApplicationModel sharedModel] allTypes];
	
	NSString * t = [types objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	cell.textLabel.text = t;

	NSArray * devices = [[ApplicationModel sharedModel] devicesWithType:t];
	
	NSUInteger count = [devices count];

	if (count == 1)
		cell.detailTextLabel.text = [NSString stringWithFormat:@"1 device: %@", [[devices lastObject] name]];
	else
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d devices", count];
	
	cell.imageView.image = [self imageForType:t];
		
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSArray * types = [[ApplicationModel sharedModel] allTypes];
	
	NSString * type = [types objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	TypeViewController * controller = [[TypeViewController alloc] initWithNibName:@"TypeViewController" bundle:nil];
	controller.type = type;
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
}


@end

