//
//  Snapshot.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Snapshot.h"
#import "Location.h"
#import "ApplicationModel.h"
#import "FavoritesManager.h"
#import "NSString+XMLEntities.h"

#define SNAPSHOT_SITE @"snapshot_site"
#define SNAPSHOT_DESCRIPTION @"snapshot_description"
#define SNAPSHOT_FAVORITE @"snapshot_favorite"
#define SNAPSHOT_IDENTIFIER @"snapshot_identifier"
#define SNAPSHOT_CATEGORY @"snapshot_category"

@implementation Snapshot

@synthesize devices;

- (BOOL) favorite
{
	return [[FavoritesManager sharedManager] isFavorite:[self identifier]];
}

- (void) setFavorite:(BOOL) favorite
{
	[[FavoritesManager sharedManager] setFavorite:favorite identifier:[self identifier]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"favorites_changed" object:self];
}

+ (Snapshot *) snapshotForXmlElement:(DDXMLElement *) element
{
	Snapshot * snapshot = [[Snapshot alloc] initWithXmlElement:element];
	
	return [snapshot autorelease];
}

- (NSString *) site;
{
	return [self valueForKey:SNAPSHOT_SITE];
}

- (void) setSite:(NSString *) site
{
	[self setValue:site forKey:SNAPSHOT_SITE];
}

- (NSString *) identifier
{
	return [self valueForKey:SNAPSHOT_IDENTIFIER];
}

- (NSString *) name
{
	return [self valueForKey:SNAPSHOT_NAME];
}

- (NSString *) description
{
	return [self valueForKey:SNAPSHOT_DESCRIPTION];
}

- (NSString *) category
{
	return [self valueForKey:SNAPSHOT_CATEGORY];
}

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super init])
	{
		// <snapshot identifier="E01E0884-72A1-4318-B2ED-74D31F6EAC55" name="Workspace On" category="Workspace">
		// <device name="Lamp Tree" identifier="78E3CB94-70A2-468F-A0A4-F6FF10E1435F" description="0% Strength"/>
		// </snapshot>

		self.devices = [NSMutableArray array];
		
		NSArray * deviceElements = [element elementsForName:@"d"];
		for (DDXMLElement * deviceElement in deviceElements)
		{
			NSDictionary * device = [NSMutableDictionary dictionary];
			
			[device setValue:[[[deviceElement attributeForName:@"n"] stringValue] stringByDecodingXMLEntities] forKey:@"name"];
			[device setValue:[[deviceElement attributeForName:@"i"] stringValue] forKey:@"identifier"];
			[device setValue:[[[deviceElement attributeForName:@"d"] stringValue] stringByDecodingXMLEntities] forKey:@"description"];
			
			[self.devices addObject:device];
		}
		
		DDXMLNode * attribute = nil;
		
		if (attribute = [element attributeForName:@"n"])
			[self setValue:[attribute stringValue] forKey:SNAPSHOT_NAME];
		else
			[self setValue:@"Unknown Snapshot" forKey:SNAPSHOT_NAME];

		if (attribute = [element attributeForName:@"site"])
			[self setValue:[attribute stringValue] forKey:SNAPSHOT_SITE];

		if (attribute = [element attributeForName:@"i"])
			[self setValue:[attribute stringValue] forKey:SNAPSHOT_IDENTIFIER];

		if (attribute = [element attributeForName:@"c"])
			[self setValue:[attribute stringValue] forKey:SNAPSHOT_CATEGORY];

		BOOL descSet = NO;
		
		if (attribute = [element attributeForName:@"d"])
		{
			if (![[attribute stringValue] isEqual:@""])
			{
				[self setValue:[element stringValue] forKey:SNAPSHOT_DESCRIPTION];
				
				descSet = YES;
			}
		}
		
		if (!descSet)
		{
			if ([self.devices count] == 1)
				[self setValue:@"1 device" forKey:SNAPSHOT_DESCRIPTION];
			else
				[self setValue:[NSString stringWithFormat:@"%d devices", [self.devices count]] forKey:SNAPSHOT_DESCRIPTION];
		}
	}
	
	return self;
}

@end
