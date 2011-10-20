//
//  MobileDevice.m
//  Shion Touch
//
//  Created by Chris Karr on 8/17/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "MobileDevice.h"

#import "XMPPManager.h"

@implementation MobileDevice

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super initWithXmlElement:element])
	{
		DDXMLNode * attribute = nil;
		
		if (attribute = [element attributeForName:@"sv"])
			[self setValue:[attribute stringValue] forKey:@"version"];
		else
			[self setValue:@"Unknown" forKey:@"version"];

		if (attribute = [element attributeForName:@"st"])
			[self setValue:[attribute stringValue] forKey:@"status"];
		else
			[self setValue:@"Unknown" forKey:@"status"];

		if (attribute = [element attributeForName:@"lc"])
			[self setValue:[attribute stringValue] forKey:@"last_caller"];
		else
			[self setValue:@"" forKey:@"last_caller"];
		
		if (attribute = [element attributeForName:@"lat"])
			[self setValue:[NSNumber numberWithDouble:[[attribute stringValue] doubleValue]] forKey:@"latitude"];

		if (attribute = [element attributeForName:@"lon"])
			 [self setValue:[NSNumber numberWithDouble:[[attribute stringValue] doubleValue]] forKey:@"longitude"];
	}
	
	return self;
}


- (void) addEvent:(NSDictionary *) event
{
	if ([event valueForKey:@"status"])
		[self setValue:[event valueForKey:@"status"] forKey:@"status"];

	if ([event valueForKey:@"caller"])
		[self setValue:[event valueForKey:@"caller"] forKey:@"last_caller"];

	if ([event valueForKey:@"latitude"])
		[self setValue:[NSNumber numberWithDouble:[[event valueForKey:@"latitude"] doubleValue]] forKey:@"latitude"];
	
	if ([event valueForKey:@"longitude"])
		[self setValue:[NSNumber numberWithDouble:[[event valueForKey:@"longitude"] doubleValue]] forKey:@"longitude"];
	
	[super addEvent:event];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"location_updated" object:self];
}

- (NSString *) lastCaller
{
	return [self valueForKey:@"last_caller"];
}

- (NSString *) version
{
	return [self valueForKey:@"version"];
}

- (NSString *) status
{
	return [self valueForKey:@"status"];
}


- (NSNumber *) latitude
{
	id lat = [self valueForKey:@"latitude"];

	if (![lat isKindOfClass:[NSNumber class]])
	{
		[self setValue:[NSNumber numberWithDouble:[lat doubleValue]] forKey:@"latitude"];
		
		return [self latitude];
	}
	
	return lat;
}

- (NSNumber *) longitude
{
	id lon = [self valueForKey:@"longitude"];
	
	if (![lon isKindOfClass:[NSNumber class]])
	{
		[self setValue:[NSNumber numberWithDouble:[lon doubleValue]] forKey:@"longitude"];
		
		return [self longitude];
	}
	
	return lon;
}

- (NSString *) type
{
	return @"Mobile Device";
}

- (NSString *) shortDescription
{
	return [NSString stringWithFormat:@"Mobile Device '%@'", [self name]];
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"%@ device", [self platform]];
}

- (void) beacon
{
	NSString * command = [NSString stringWithFormat:@"shion:beaconMobileDevice(\"%@\")", [self identifier], nil];
	[[XMPPManager sharedManager] sendCommand:command forDevice:self];
}

- (UIColor *) color
{
	if ([[self valueForKey:@"status"] isEqual:@"Online"])
		return [UIColor colorWithRed:0.000 green:0.314 blue:0.961 alpha:1.0];
	else if ([[self valueForKey:@"status"] isEqual:@"Private"])
		return [UIColor colorWithRed:0.910 green:0.173 blue:0.047 alpha:1.0];
	else
		return [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
}


@end
