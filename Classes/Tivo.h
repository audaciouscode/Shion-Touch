//
//  Tivo.h
//  Shion Touch
//
//  Created by Chris Karr on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface Tivo : Device
{
	NSMutableArray * shows;
}

- (NSArray *) recordings;

- (void) clearShows;
- (void) addShow:(NSDictionary *) dict;
- (NSArray *) shows;

- (NSUInteger) showCount;
- (NSUInteger) countShows:(NSArray *) items;

@end
