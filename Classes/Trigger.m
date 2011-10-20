//
//  Trigger.m
//  Shion Touch
//
//  Created by Chris Karr on 7/4/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Trigger.h"

#import "FavoritesManager.h"
#import "NSString+XMLEntities.h"

#define TRIGGER_SITE @"trigger_site"
#define TRIGGER_DESCRIPTION @"trigger_description"
#define TRIGGER_FAVORITE @"trigger_favorite"
#define TRIGGER_IDENTIFIER @"trigger_identifier"
#define TRIGGER_FIRED @"trigger_fired"
#define TRIGGER_TYPE @"trigger_type"
#define TRIGGER_ACTION @"trigger_action"

@implementation Trigger

- (BOOL) favorite
{
	return [[FavoritesManager sharedManager] isFavorite:[self identifier]];
}

- (void) setFavorite:(BOOL) favorite
{
	[[FavoritesManager sharedManager] setFavorite:favorite identifier:[self identifier]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"favorites_changed" object:self];
}

+ (Trigger *) triggerForXmlElement:(DDXMLElement *) element
{
	Trigger * trigger = [[Trigger alloc] initWithXmlElement:element];
	
	return [trigger autorelease];
}

- (NSString *) site;
{
	return [self valueForKey:TRIGGER_SITE];
}

- (void) setSite:(NSString *) site
{
	[self setValue:site forKey:TRIGGER_SITE];
}

- (NSString *) identifier
{
	return [self valueForKey:TRIGGER_IDENTIFIER];
}

- (NSString *) name
{
	return [self valueForKey:TRIGGER_NAME];
}

- (NSString *) conditions
{
	return [self valueForKey:TRIGGER_DESCRIPTION];
}

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super init])
	{
		DDXMLNode * attribute = nil;
		
		if (attribute = [element attributeForName:@"n"])
			[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:TRIGGER_NAME];
		else
			[self setValue:@"Unknown Trigger" forKey:TRIGGER_NAME];
		
		if (attribute = [element attributeForName:@"site"])
			[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:TRIGGER_SITE];
		
		if (attribute = [element attributeForName:@"i"])
			[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:TRIGGER_IDENTIFIER];

		if (attribute = [element attributeForName:@"a"])
			[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:TRIGGER_ACTION];

		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm.ssz"];

		if (attribute = [element attributeForName:@"df"])
			[self setValue:[formatter dateFromString:[[attribute stringValue] stringByDecodingXMLEntities]] forKey:TRIGGER_FIRED];

		[formatter release];
		
		if (attribute = [element attributeForName:@"ty"])
			[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:TRIGGER_TYPE];

		BOOL descSet = NO;
		
		if (attribute = [element attributeForName:@"d"])
		{
			if (![[attribute stringValue] isEqual:@""])
			{
				[self setValue:[[attribute stringValue] stringByDecodingXMLEntities] forKey:TRIGGER_DESCRIPTION];
				
				descSet = YES;
			}
		}
		
		if (!descSet)
			[self setValue:@"Unknown/No Conditions" forKey:TRIGGER_DESCRIPTION];
	}
	
	return self;
}

- (NSDate *) fired
{
	return [self valueForKey:TRIGGER_FIRED];
}

- (NSString *) type
{
	return [self valueForKey:TRIGGER_TYPE];
}

- (NSString *) action
{
	return [self valueForKey:TRIGGER_ACTION];
}

@end
