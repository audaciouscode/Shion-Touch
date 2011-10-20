//
//  Thermostat.m
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Thermostat.h"

#define THERMOSTAT_MODE @"thermostat_mode"
#define THERMOSTAT_FAN_ACTIVE @"thermostat_fan_active"
#define THERMOSTAT_TEMPERATURE @"thermostat_temperature"
#define THERMOSTAT_COOL_POINT @"thermostat_cool_point"
#define THERMOSTAT_HEAT_POINT @"thermostat_heat_point"

@implementation Thermostat

@synthesize minTemp;
@synthesize maxTemp;

- (CGFloat) intensity
{
	NSNumber * temp = [self temperature];

	if (temp != nil)
	{
		float intensity = ([temp floatValue] - minTemp) / (maxTemp - minTemp);
		
		if (intensity < 0.25)
			intensity = 0.25;
		
		return intensity;
	}
	
	return 0.0;
}

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super initWithXmlElement:element])
	{
		minTemp = 255;
		maxTemp = 0;
		
		NSString * mode = [[element attributeForName:@"md"] stringValue];
		
		if (mode != nil)
			[self setValue:mode forKey:THERMOSTAT_MODE];

		NSString * temp = [[element attributeForName:@"tp"] stringValue];
		
		if (temp != nil)
			[self setValue:[NSNumber numberWithInteger:[temp integerValue]] forKey:THERMOSTAT_TEMPERATURE];

		NSString * cool = [[element attributeForName:@"cp"] stringValue];
		
		if (cool != nil)
			[self setValue:[NSNumber numberWithInteger:[cool integerValue]] forKey:THERMOSTAT_COOL_POINT];

		NSString * heat = [[element attributeForName:@"hp"] stringValue];
		
		if (heat != nil)
			[self setValue:[NSNumber numberWithInteger:[heat integerValue]] forKey:THERMOSTAT_HEAT_POINT];
	}
	
	return self;
}

- (void) addEvent:(NSDictionary *) event
{
	NSDate * lastUpdate = [self lastUpdate];
	NSDate * thisUpdate = [event valueForKey:@"date"];
	
	NSString * eventType = [event valueForKey:@"t"];

	BOOL doUpdate = ([thisUpdate compare:lastUpdate] == NSOrderedDescending);

	if ([eventType isEqual:@"device"])
	{
		id value = [event valueForKey:@"v"];
		
		if (![value isKindOfClass:[NSNumber class]])
			value = [NSNumber numberWithDouble:[value doubleValue]];
		
		float temp = [value floatValue];
		
		if (temp < minTemp && temp > 10)
			minTemp = temp;
		
		if (temp > maxTemp && temp < 120)
			maxTemp = temp;

		if (doUpdate)
			[self setValue:value forKey:THERMOSTAT_TEMPERATURE];
	}
	else if ([eventType isEqual:@"device_cool"])
	{
		id value = [event valueForKey:@"v"];
		
		if (![value isKindOfClass:[NSNumber class]])
			value = [NSNumber numberWithDouble:[value doubleValue]];
		
		if (doUpdate)
			[self setValue:value forKey:THERMOSTAT_COOL_POINT];
	}
	else if ([eventType isEqual:@"device_heat"])
	{
		id value = [event valueForKey:@"v"];
		
		if (![value isKindOfClass:[NSNumber class]])
			value = [NSNumber numberWithDouble:[value doubleValue]];
		
		if (doUpdate)
			[self setValue:value forKey:THERMOSTAT_HEAT_POINT];
	}
	else if ([eventType isEqual:@"device_mode"])
	{
		id value = [event valueForKey:@"v"];
		
		if (doUpdate)
			[self setValue:value forKey:THERMOSTAT_MODE];
	}
	
	[super addEvent:event];
}

- (NSString *) description
{
	if ([self temperature] == nil)
		return @"Current Temperature: Unknown";
	else
		return [NSString stringWithFormat:@"Current Temperature: %@°", [self temperature]];
}

- (NSString *) shortDescription
{
	if ([self temperature] == nil)
		return @"";
	else
		return [NSString stringWithFormat:@"Currently %@°", [self temperature]];
}


- (NSString *) mode
{
	NSString * mode = [self valueForKey:THERMOSTAT_MODE];
	
	if (mode == nil || [mode isEqual:@""])
		mode = @"Unknown";
	
	return mode;
}

- (UIColor *) color
{
	return [UIColor colorWithRed:0.910 green:0.173 blue:0.047 alpha:1.0];
}

- (BOOL) fanActive
{
	return [[self valueForKey:THERMOSTAT_FAN_ACTIVE] boolValue];
}

- (NSNumber *) temperature
{
	return [self valueForKey:THERMOSTAT_TEMPERATURE];
}

- (NSNumber *) coolPoint
{
	return [self valueForKey:THERMOSTAT_COOL_POINT];
}

- (NSNumber *) heatPoint
{
	return [self valueForKey:THERMOSTAT_HEAT_POINT];
}

- (NSString *) type
{
	return @"Thermostat";
}

- (BOOL) editable
{
	return YES;
}

@end
