//
//  Lock.m
//  Shion Touch
//
//  Created by Chris Karr on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Lock.h"


@implementation Lock

@synthesize locked;

- (NSString *) type
{
	return @"Lock";
}

- (NSString *) description
{
	if (self.locked == nil)
		return @"Unknown";
	else if ([self.locked intValue] > 0)
		return @"Locked";
	else
		return @"Unlocked";
}

- (NSString *) shortDescription
{
	return [self description];
}

/* - (UIColor *) color
{
	return [UIColor colorWithRed:0.000 green:0.314 blue:0.961 alpha:1.0];
} */

- (CGFloat) intensity
{
	if (self.locked == nil)
		return 0.0;
	else if ([self.locked integerValue] > 0)
		return 1.0;
	else
		return 0.0;
}

- (void) addEvent:(NSDictionary *) event
{
	NSString * eventType = [event valueForKey:@"t"];
	
	if ([eventType isEqual:@"device"])
	{
		id value = [event valueForKey:@"lv"];
		
		if (![value isKindOfClass:[NSNumber class]])
			value = [NSNumber numberWithDouble:[value doubleValue]];
		
		self.locked = value;
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
			
			self.locked = [NSNumber numberWithInteger:levelInteger];
		}
	}
	
	return self;
}

@end
