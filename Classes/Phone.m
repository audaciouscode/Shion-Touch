//
//  Phone.m
//  Shion Touch
//
//  Created by Chris Karr on 3/1/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Phone.h"
#import "DDXMLElement.h"
#import "DDXMLNode.h"

#import "PhoneNumberFormatter.h"

@implementation Phone

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super initWithXmlElement:element])
	{
		NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm.ssz"];

		DDXMLNode * attribute = nil;

		if (attribute = [element attributeForName:@"nm"])
			[self setValue:[attribute stringValue] forKey:PHONE_CALLER];

		if (attribute = [element attributeForName:@"nb"])
			[self setValue:[attribute stringValue] forKey:PHONE_NUMBER];

		if (attribute = [element attributeForName:@"dt"])
			[self setValue:[dateFormatter dateFromString:[attribute stringValue]] forKey:PHONE_CALL_DATE];
		
		[dateFormatter release];
	}
	
	return self;
}

- (NSString *) description
{
	NSString * name = [self valueForKey:PHONE_CALLER];
	NSString * number = [self valueForKey:PHONE_NUMBER];
	
	if (name != nil)
	{
		NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"M/d, h:mm a"];
		
		PhoneNumberFormatter * phoneFormatter = [[[PhoneNumberFormatter alloc] init] autorelease];
		
		return [NSString stringWithFormat:@"%@, %@", name, [phoneFormatter format:number withLocale:@"us"]];
	}
	
	return @"No Phone Calls";
}

- (NSString *) type
{
	return @"Telephone / Modem";
}

- (NSArray *) calls
{
	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:PHONE_CALL_DATE ascending:NO];
	
	NSArray * sortedCalls = [[self events] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

	[sort release];
	
	return sortedCalls;
}

- (void) addEvent:(NSDictionary *) event
{
	[super addEvent:event];
}

@end
