//
//  CategoriesViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "CategoriesViewController.h"

#import "CategoryViewController.h"
#import "ApplicationModel.h"

@implementation CategoriesViewController

- (void)viewWillAppear:(BOOL)animated 
{
	self.navigationItem.title = @"Categories";
	
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
	NSArray * categories = [[ApplicationModel sharedModel] allCategories];
	
	return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier = @"AllCategoriesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSArray * categories = [[ApplicationModel sharedModel] allCategories];
	
	NSString * c = [categories objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	cell.textLabel.text = c;
	
	NSArray * snapshots = [[ApplicationModel sharedModel] snapshotsWithCategory:c];
	
	NSUInteger count = [snapshots count];
	
	if (count == 1)
		cell.detailTextLabel.text = [NSString stringWithFormat:@"1 snapshot: %@", [[snapshots lastObject] name]];
	else
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d snapshots", count];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSArray * categories = [[ApplicationModel sharedModel] allCategories];
	
	NSString * category = [categories objectAtIndex:[indexPath indexAtPosition:([indexPath length] - 1)]];
	
	CategoryViewController * controller = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
	controller.category = category;
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
}

@end

