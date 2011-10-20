//
//  CameraPhoto.m
//  Shion Touch
//
//  Created by Chris Karr on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraPhoto.h"

@implementation CameraPhoto

@synthesize photoSource, size, index, caption, url, title;

- (id)initWithURLString:(NSString *) urlString 
{
	if (self = [super init]) 
	{
		self.photoSource = self;
		self.index = 0;
		
		NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
		
		self.url = [urlString stringByReplacingOccurrencesOfString:@"file://" withString:@"http://"]; // [[TTURLCache sharedCache] createUniqueTemporaryURL];

		[[TTURLCache sharedCache] storeData:data forURL:self.url];

		UIImage * image = [UIImage imageWithData:data];
		self.size = image.size;
	}

	return self;
}

- (void) dealloc 
{
	[super dealloc];
}

- (NSString *) URLForVersion:(TTPhotoVersion) version
{
	return self.url;
}

- (NSInteger) numberOfPhotos 
{
	return 1;
}

- (NSInteger) maxPhotoIndex 
{
	return 0;
}

- (id<TTPhoto>) photoAtIndex:(NSInteger) photoIndex 
{
	return self;
}

- (BOOL)isLoading 
{
	return NO;
}

- (BOOL)isLoaded 
{
	return YES;
}

- (BOOL)isLoadingMore
{
	return NO;
}

-(BOOL)isOutdated
{
	return NO;
}

- (void)cancel
{
	
}

- (void)invalidate:(BOOL)erase
{
	
}

- (NSMutableArray*)delegates
{
	return [NSMutableArray array];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
	
}

@end
