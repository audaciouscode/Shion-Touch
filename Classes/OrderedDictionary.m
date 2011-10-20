//
//  OrderedDictionary.m
//  Shion Touch
//
//  Created by Chris Karr on 2/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "OrderedDictionary.h"


@implementation OrderedDictionary

- (id) init
{
	if (self = [self initWithCapacity:2])
	{
		
	}
		
	
	return self;
}

- (id) initWithCapacity:(NSUInteger) numItems
{
	store = [[NSMutableDictionary alloc] initWithCapacity:numItems];
	sortedKeyArray = [[NSMutableArray alloc] init];
	
	return self;
}

- (void) dealloc
{
	[store release];
	[sortedKeyArray release];
	
	[super dealloc];
}

- (NSUInteger) count
{
	return [store count];
}

- (id) objectForKey:(id) aKey
{
	return [store objectForKey:aKey];
}

- (NSEnumerator *) keyEnumerator
{
	return [sortedKeyArray objectEnumerator];
}

- (void) setObject:(id) anObject forKey:(id) aKey
{
	if (![sortedKeyArray containsObject:aKey])
		[sortedKeyArray addObject:aKey];
	
	[store setObject:anObject forKey:aKey];
}

- (void) removeObjectForKey:(id) aKey
{
	[sortedKeyArray removeObject:aKey];
	
	[store removeObjectForKey:aKey];
}

- (id) valueAtIndex:(NSUInteger) index
{
	return [store valueForKey:[sortedKeyArray objectAtIndex:index]];
}

@end
