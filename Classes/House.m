//
//  House.m
//  Shion Touch
//
//  Created by Chris Karr on 4/29/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "House.h"

@implementation House

- (NSString *) type
{
	return @"House";
}

- (NSString *) shortDescription
{
	return [NSString stringWithFormat:@"X10 House '%@'", [self address]];
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"X10 devices in the '%@' housecode", [self address]];
}

@end
