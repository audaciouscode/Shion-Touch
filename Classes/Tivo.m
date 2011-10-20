//
//  Tivo.m
//  Shion Touch
//
//  Created by Chris Karr on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Tivo.h"
#import "XMPPManager.h"

@implementation Tivo

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super initWithXmlElement:element])
	{
		shows = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (NSArray *) shows
{
	return shows;
}

- (void) clearShows
{
	[shows removeAllObjects];
}

- (NSUInteger) countShows:(NSArray *) items
{
	NSUInteger count = 0;

	for (NSDictionary * item in items)
	{
		NSArray * children = [item valueForKey:@"children"];
		
		if (children == nil)
			count += 1;
		else
			count += [self countShows:children];
	}
	
	return count;
}

- (NSUInteger) showCount
{
	return [self countShows:shows];
}

- (void) addShow:(NSDictionary *) dict
{
	[shows addObject:dict];
}

- (void) fetchShows
{
	NSString * command = [NSString stringWithFormat:@"shion:fetchRecordingsForTivo(\"%@\")", [self identifier], nil];
	
	[[XMPPManager sharedManager] sendCommand:command forDevice:self];
}

- (NSString *) description
{
	NSUInteger count = [self showCount];
	
	if (count == 0)
		[self fetchShows];
	
	if (count == 1)
		return @"1 recording";
	else
		return [NSString stringWithFormat:@"%d recordings", count];
}

- (NSString *) type
{
	return @"TiVo Digital Video Recorder";
}

- (void) setShows:(NSArray *) list
{
	[shows addObjectsFromArray:list];
}

- (NSArray *) recordings
{
	if ([shows count] < 1)
		[self fetchShows];
	
	return shows;
}

- (void) addEvent:(NSDictionary *) event
{
	[super addEvent:event];
}

@end
