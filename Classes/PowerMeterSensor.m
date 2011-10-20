//
//  PowerMeterSensor.m
//  Shion Touch
//
//  Created by Chris Karr on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PowerMeterSensor.h"


@implementation PowerMeterSensor

@synthesize level;
@synthesize minPower;
@synthesize maxPower;

- (NSString *) type
{
	return @"Power Meter";
}

- (NSString *) description
{
	if (level == nil)
		return @"Unknown";
	else
		return [NSString stringWithFormat:@"Using %@W", level];
}

- (NSString *) shortDescription
{
	return [self description];
}

- (UIColor *) color
{
	return [UIColor colorWithRed:0.000 green:0.314 blue:0.961 alpha:1.0];
}

- (CGFloat) intensity
{
	if (self.level != nil)
	{
		float intensity = ([self.level floatValue] - minPower) / (maxPower - minPower);
		
		if (intensity < 0.25)
			intensity = 0.25;
		
		return intensity;
	}
	
	return 0.0;
}

- (void) addEvent:(NSDictionary *) event
{
	NSDate * lastUpdate = [self lastUpdate];
	NSDate * thisUpdate = [event valueForKey:@"date"];
	
	NSString * eventType = [event valueForKey:@"t"];
	
	if ([eventType isEqual:@"device"])
	{
		id value = [event valueForKey:@"v"];
		
		if (![value isKindOfClass:[NSNumber class]])
			value = [NSNumber numberWithDouble:[value doubleValue]];
		
		NSInteger power = [value integerValue];
		
		if (power < minPower)
			minPower = power;
		
		if (power > maxPower)
			maxPower = power;
		
		if ([lastUpdate compare:thisUpdate] == NSOrderedAscending)
			self.level = value;
	}
	
	[super addEvent:event];
}

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super initWithXmlElement:element])
	{
		NSString * remoteLevel = [[element attributeForName:@"lv"] stringValue];
		
		if (remoteLevel != nil)
		{
			NSInteger levelInteger = [remoteLevel integerValue];
			
			self.level = [NSNumber numberWithInteger:levelInteger];

			minPower = 9999999;
			maxPower = -9999999;
		}
	}
	
	return self;
}

@end
