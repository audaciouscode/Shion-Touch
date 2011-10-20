//
//  CameraPhotoSource.m
//  Shion Touch
//
//  Created by Chris Karr on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraPhotoSource.h"
#import "CameraPhoto.h"

@implementation CameraPhotoSource

@synthesize title;

- (id) initWithCamera:(Camera *) deviceCamera
{
	if (self = [super init])
	{
		camera = [deviceCamera retain];
		[camera addObserver:self forKeyPath:@"photos" options:0 context:NULL];
		cachedPhotos = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc
{
	[camera release];
	[cachedPhotos release];
	
	[super dealloc];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[self willChangeValueForKey:@"numberOfPhotos"];
	[self willChangeValueForKey:@"maxPhotoIndex"];

	[self didChangeValueForKey:@"maxPhotoIndex"];
	[self didChangeValueForKey:@"numberOfPhotos"];
}

- (NSInteger) numberOfPhotos 
{
	return [[camera photos] count];
}

- (NSInteger) maxPhotoIndex 
{
	return [[camera photos] count] - 1;
}

- (id<TTPhoto>) photoAtIndex:(NSInteger) photoIndex 
{
	NSArray * photos = [camera photos];

	if (photoIndex >= [photos count])
		return nil;
	else if ([photos count] > 0)
	{
		if (photoIndex >= [cachedPhotos count])
		{
			NSDictionary * photoDict = [[camera photos] objectAtIndex:photoIndex];
			
			CameraPhoto * photo = [[CameraPhoto alloc] initWithURLString:[photoDict valueForKey:@"url"]];
			
			NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
			[formatter setDateStyle:NSDateFormatterLongStyle];
			[formatter setTimeStyle:NSDateFormatterLongStyle];
			
			photo.caption = [formatter stringFromDate:[photoDict valueForKey:@"date"]];
			
			[formatter release];
			
			photo.photoSource = self;
			photo.index = photoIndex;
		
			[cachedPhotos addObject:photo];
			
			return [photo autorelease];
		}
		else
			return [cachedPhotos objectAtIndex:photoIndex];
	}
	else
		return nil;
}

- (BOOL)isLoading 
{
	return NO;
}

- (BOOL)isLoaded 
{
	return YES;
}



@end
