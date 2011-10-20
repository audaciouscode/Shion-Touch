//
//  Location.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Location.h"

#define LOCATION_DETAILS @"details"
#define LOCATION_DEVICES @"devices"
#define LOCATION_SNAPSHOTS @"snapshots"

@implementation Location

- (void) setSnapshots:(NSArray *) snapshots;
{
	[self setValue:snapshots forKey:LOCATION_SNAPSHOTS];
}

- (NSArray *) snapshots
{
	return [self valueForKey:LOCATION_SNAPSHOTS];
}

- (void) setDevices:(NSArray *) devices
{
	[self setValue:devices forKey:LOCATION_DEVICES];
}

- (NSArray *) devices
{
	return [self valueForKey:LOCATION_DEVICES];
}

- (id) initWithName:(NSString *) name
{
		
	if (self = [super init])
	{
		[self setValue:name forKey:LOCATION_NAME];
		[self setValue:@"Status unknown." forKey:LOCATION_DETAILS];
	}
	
	return self;
}

- (NSString *) name
{
	NSString * name = [self valueForKey:LOCATION_NAME];

	if (name == nil || [name isEqual:@""])
		name = @"Unknown Location";

	return name;
}

- (NSString *) details
{
	return [self valueForKey:LOCATION_DETAILS];
}

@end
