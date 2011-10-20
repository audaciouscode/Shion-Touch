//
//  FavoritesManager.m
//  Shion Touch
//
//  Created by Chris Karr on 4/22/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "FavoritesManager.h"

#define FAVORITES @"favorites"

@implementation FavoritesManager

static FavoritesManager * sharedManager = nil;

- (BOOL) isFavorite:(NSString *) identifier
{
	return [favorites containsObject:identifier];
}

- (void) setFavorite:(BOOL) favorite identifier:(NSString *) identifier
{
	if (favorite)
		[favorites addObject:identifier];
	else
		[favorites removeObject:identifier];

	[[NSUserDefaults standardUserDefaults] setValue:[favorites allObjects] forKey:FAVORITES];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) init
{
	if (self = [super init])
	{
		favorites = [[NSMutableSet alloc] init];

		NSArray * fromPrefs = [[NSUserDefaults standardUserDefaults] valueForKey:FAVORITES];

		if (fromPrefs != nil)
			[favorites addObjectsFromArray:fromPrefs];
	}
	
	return self;
}

+ (FavoritesManager *) sharedManager
{
    @synchronized(self) 
	{
        if (sharedManager == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedManager;
}

+ (id) allocWithZone:(NSZone *) zone
{
    @synchronized(self) 
	{
        if (sharedManager == nil) 
		{
            sharedManager = [super allocWithZone:zone];
            return sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id) copyWithZone:(NSZone *) zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void) release
{
    //do nothing
}

- (id) autorelease
{
    return self;
}

@end
