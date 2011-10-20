//
//  PhoneViewController.m
//  Shion Touch
//
//  Created by Chris Karr on 4/26/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "PhoneViewController.h"

#import "Phone.h"
#import "PhoneNumberFormatter.h"

@implementation PhoneViewController

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	Phone * phone = (Phone *) self.device;
	
	NSArray * calls = [phone calls];
	
    return [calls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PhoneDeviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
	Phone * phone = (Phone *) self.device;
	
	NSArray * calls = [phone calls];
	
	NSInteger index = [indexPath indexAtPosition:([indexPath length] - 1)];
	NSDictionary * call = [calls objectAtIndex:index];
	
	PhoneNumberFormatter * phoneFormatter = [[PhoneNumberFormatter alloc] init];
	cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [call valueForKey:@"nm"], [phoneFormatter format:[call valueForKey:@"nb"] withLocale:@"us"]];
	[phoneFormatter release];
	
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"h:mm a, MMMM d, yyyy"];
	cell.detailTextLabel.text = [formatter stringFromDate:[call valueForKey:PHONE_CALL_DATE]];
	[formatter release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	Phone * phone = (Phone *) self.device;
	
	NSArray * calls = [phone calls];
	
	NSInteger index = [indexPath indexAtPosition:([indexPath length] - 1)];
	NSDictionary * call = [calls objectAtIndex:index];
	
	BOOL found = NO;
	
	ABAddressBookRef addressBook = ABAddressBookCreate();
	CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
	CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
	CFRelease(addressBook);
	
	for(int i = 0; i < nPeople; i++)
	{
		ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
		
		ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
		
		if (phoneNumberProperty)
		{
			NSArray * phoneNumbers = (NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumberProperty);
			CFRelease(phoneNumberProperty);
			
			for (NSString * phoneNumber in phoneNumbers)
			{
				phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
				
				if (phoneNumber != nil && [phoneNumber rangeOfString:[call valueForKey:@"nb"]].location != NSNotFound)
				{
					ABPersonViewController * personViewController = [[ABPersonViewController alloc] init];
					
					personViewController.personViewDelegate = self;
					personViewController.displayedPerson = person; // Assume person is already defined.
					
					[self.navigationController pushViewController:personViewController animated:YES];
					[personViewController release];
					
					found = YES;
				}
				
			}
			
			[phoneNumbers release];
		}
	}
	
	CFRelease(allPeople);
	
	if (!found)
	{
		NSString * callButton = nil;
		
		PhoneNumberFormatter * phoneFormatter = [[PhoneNumberFormatter alloc] init];
		
		if ([[UIDevice currentDevice].model rangeOfString:@"iPhone"].location != NSNotFound)
			callButton = [NSString stringWithFormat:@"Call %@", [phoneFormatter format:[call valueForKey:@"nb"] withLocale:@"us"]];
		
		[phoneFormatter release];
		
		NSString * message = [NSString stringWithFormat:@"%@ not found.", [call valueForKey:@"nm"]];
		
		UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:message
															 delegate:self
													cancelButtonTitle:@"Ignore"
											   destructiveButtonTitle:callButton
													otherButtonTitles:@"Add to Contacts", nil];
		
		[action showInView:[[UIApplication sharedApplication] keyWindow]];
	}
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return YES;
}

@end

