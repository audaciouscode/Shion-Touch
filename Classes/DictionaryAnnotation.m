//
//  DictionaryAnnotation.m
//  Shion Touch
//
//  Created by Chris Karr on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DictionaryAnnotation.h"

#import "MobileDevice.h"

@implementation DictionaryAnnotation

- (CLLocationCoordinate2D) coordinate
{
	CLLocationCoordinate2D coord;
	
	coord.latitude = 0;
	coord.longitude = 0;
	
	MobileDevice * device = [self valueForKey:@"device"];
	
	if (device != nil)
	{
		NSNumber * lat = [device valueForKey:@"latitude"];
		NSNumber * lon = [device valueForKey:@"longitude"];

		if (lat != nil && lon != nil)
		{
			coord.latitude = [lat doubleValue];
			coord.longitude = [lon doubleValue];
		}
	}
	
	return coord;
}

- (NSString *) title
{
	return [[self valueForKey:@"device"] name];
}

- (NSString *) subtitle
{
	return [[self valueForKey:@"device"] model];
}

@end
