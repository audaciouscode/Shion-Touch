//
//  Lamp.m
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Lamp.h"
#import "DDXMLElement.h"

@implementation Lamp

- (NSString *) type
{
	return @"Lamp";
}

- (NSString *) description
{
	if ([self level] == nil)
		return @"Current Level: Unknown";
	else
		return [NSString stringWithFormat:@"Current Level: %.0f%%", ([[self level] floatValue] / 255) * 100];
}

- (NSString *) shortDescription
{
	if ([self level] == nil)
		return @"Level: Unknown";
	else 
		return [NSString stringWithFormat:@"Level: %.0f%%", ([[self level] floatValue] / 255) * 100];
}

- (CGFloat) intensity
{
	if ([self level] == nil)
		return 0.0;
	else 
		return [[self level] floatValue] / 255;
}

- (UIColor *) color
{
	return [UIColor colorWithRed: 1.000 green:0.678 blue:0.000 alpha:1.0];
}

@end
