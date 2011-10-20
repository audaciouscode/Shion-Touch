//
//  Site.m
//  Shion Touch
//
//  Created by Chris Karr on 4/23/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import "Site.h"
#import "ApplicationModel.h"

#import "Controller.h"

#define SITE_NAME @"site_name"

@implementation Site

- (NSString *) name
{
	return [self valueForKey:SITE_NAME];
}

- (void) setName:(NSString *) name
{
	[self setValue:name forKey:SITE_NAME];
}

- (UIImage *) siteImage
{
	return [UIImage imageNamed:@"computer.png"];
}

- (NSString *) networkDescription
{
	NSArray * devices = [[ApplicationModel sharedModel] devicesForSite:[self name]];

	for (Device * device in devices)
	{
		if ([device isKindOfClass:[Controller class]])
			return [device description];
	}
	
	return @"Network Status: Unknown";
}

- (NSString *) deviceCountDescription
{
	NSArray * devices = [[ApplicationModel sharedModel] devicesForSite:[self name]];
	
	if ([devices count] == 1)
		return [NSString stringWithFormat:@"1 device: %@", [[devices lastObject] name]];
	else
		return [NSString stringWithFormat:@"%d devices", [devices count]];
}

@end
