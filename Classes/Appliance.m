//
//  Appliance.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Appliance.h"

@implementation Appliance

- (NSNumber *) level
{
	return [self valueForKey:APPLIANCE_LEVEL];
}

- (void) setLevel:(NSNumber *) newLevel
{
	[self setValue:newLevel forKey:APPLIANCE_LEVEL];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"view_refresh" object:self];
}

- (NSString *) type
{
	return @"Appliance";
}

- (NSString *) description
{
	if ([self level] == nil)
		return @"State: Unknown";
	else if ([[self level] integerValue] > 0)
		return @"State: On";
	else
		return @"State: Off";
}

- (CGFloat) intensity
{
	if ([self level] == nil)
		return 0.0;
	else if ([[self level] integerValue] > 0)
		return 1.0;
	else
		return 0.0;
}

- (UIColor *) color
{
	return [UIColor colorWithRed:0.000 green:0.314 blue:0.961 alpha:1.0];
}

- (void) addEvent:(NSDictionary *) event
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:event];
	
	NSString * eventType = [event valueForKey:@"t"];
	
	if ([eventType isEqual:@"device"])
	{
		id value = [event valueForKey:@"v"];
		
		if (![value isKindOfClass:[NSNumber class]])
			value = [NSNumber numberWithDouble:[value doubleValue]];

		[dict setValue:value forKey:@"value"];
	}

	[super addEvent:dict];

	event = [[self events] lastObject];
	
	[self setLevel:[event valueForKey:@"value"]];
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
		}
	}

	return self;
}

- (BOOL) editable
{
	return YES;
}


@end
