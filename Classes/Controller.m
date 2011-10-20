//
//  Controller.m
//  Shion Touch
//
//  Created by Chris Karr on 4/23/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Controller.h"


@implementation Controller

@synthesize level;

- (NSString *) type
{
	return @"Controller";
}

- (NSString *) description
{
	if (self.level != nil)
	{		
		float f = [self.level floatValue];
		
		return [NSString stringWithFormat:@"Network Status: %0.0f%%", ((f * 100) / 255)];
	}
	else
		return @"Network Status: Unknown";
}

- (NSString *) shortDescription
{
	if ([self level] == nil)
		return @"Unknown Network Status";
	else 
		return [NSString stringWithFormat:@"Network: %.0f%%", ([[self level] floatValue] / 255) * 100];
}

- (void) addEvent:(NSDictionary *) event
{
	NSMutableDictionary * newDict = [NSMutableDictionary dictionaryWithDictionary:event];
	
	NSString * eventType = [event valueForKey:@"t"];
	
	if ([eventType isEqual:@"device"])
	{
		id value = [event valueForKey:@"v"];
		
		if (![value isKindOfClass:[NSNumber class]])
			value = [NSNumber numberWithDouble:[value doubleValue]];
	
		[newDict setValue:value forKey:@"v"];
	}
	
	[super addEvent:newDict];
	
	event = [[self events] lastObject];
	
	self.level = [event valueForKey:@"v"];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"view_refresh" object:self];
}


- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super initWithXmlElement:element])
	{
		NSString * remoteLevel = [[element attributeForName:@"lv"] stringValue];
		
		if (remoteLevel != nil)
		{
			CGFloat levelFloat = [remoteLevel floatValue];
			
			self.level = [NSNumber numberWithFloat:levelFloat];
		}
	}
	
	return self;
}

- (CGFloat) intensity
{
	if ([self level] == nil)
		return 0.0;
	else 
		return [[self level] floatValue] / 255;
}

- (UIColor *) color
{
	return [UIColor colorWithRed:0.725 green:0.961 blue:0.094 alpha:1.0];
}

@end
