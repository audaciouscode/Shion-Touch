//
//  WeatherSensor.m
//  Shion Touch
//
//  Created by Chris Karr on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherSensor.h"


@implementation WeatherSensor

@synthesize level;
@synthesize minTemp;
@synthesize maxTemp;

- (NSString *) type
{
	return @"Weather Sensor";
}

- (NSString *) description
{
	if (level == nil)
		return @"Current Temperature: Unknown";
	else
		return [NSString stringWithFormat:@"Current Temperature: %@°", level];
}

- (NSString *) shortDescription
{
	if (level == nil)
		return @"";
	else
		return [NSString stringWithFormat:@"Currently %@°", level];
}

- (UIColor *) color
{
	return [UIColor colorWithRed:0.000 green:0.314 blue:0.961 alpha:1.0];
}

- (CGFloat) intensity
{
	if (self.level != nil)
	{
		float intensity = ([self.level floatValue] - minTemp) / (maxTemp - minTemp);
		
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
		
		NSInteger temp = [value integerValue];
		
		if (temp < minTemp)
			minTemp = temp;
		
		if (temp > maxTemp)
			maxTemp = temp;
		
		if ([lastUpdate compare:thisUpdate] == NSOrderedAscending)
			self.level = value;
	}
	
	[super addEvent:event];
}

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super initWithXmlElement:element])
	{
		NSString * remoteLevel = [[element attributeForName:@"tp"] stringValue];
		
		if (remoteLevel != nil)
		{
			NSInteger levelInteger = [remoteLevel integerValue];
			
			self.level = [NSNumber numberWithInteger:levelInteger];
			
			minTemp = 9999999;
			maxTemp = -9999999;
		}
	}
	
	return self;
}

@end
