//
//  Camera.m
//  Shion Touch
//
//  Created by Chris Karr on 9/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"

#import "XMPPManager.h"

@implementation Camera

- (NSString *) photoPath
{
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	NSString * path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[self identifier]];

	path = [path stringByAppendingPathComponent:@"camera-images"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
	
	return path;
}

- (id) initWithXmlElement:(DDXMLElement *) element
{
	if (self = [super initWithXmlElement:element])
	{
		photos = [[NSMutableArray alloc] init];
		loadPhotos = nil;
		pendingPhotos = nil;
		
		[self photos];
	}
	
	return self;
}

- (NSString *) type
{
	return @"Camera";
}

- (NSString *) shortDescription
{
	NSUInteger photoCount = [[self photos] count];
	
	if (photoCount == 1)
		return @"1 photo";
	else
		return [NSString stringWithFormat:@"%d photos", photoCount];
}

- (NSString *) description
{
	return [self shortDescription];
}

- (void) fetchNextPhoto:(NSTimer *) theTimer
{
	[loadPhotos release];
	loadPhotos = nil;
	
	if ([pendingPhotos count] > 0)
	{
		NSString * photoId = [pendingPhotos lastObject];
		
		NSString * imagePath = [self photoPath];
		NSString * imageFilePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", photoId]];
		NSString * dataFilePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", photoId]];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:imageFilePath] && [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath])
		{
			// Do nothing. We already have the image...
		}
		else
		{
			CGRect bounds = [[UIScreen mainScreen] bounds];
			
			NSString * command = [NSString stringWithFormat:@"shion:fetchPhoto_forCamera_width_height(\"%@\", \"%@\", %d, %d)", photoId, 
								  [self identifier], (int) bounds.size.width, (int) bounds.size.height, nil];

			[[XMPPManager sharedManager] sendCommand:command forDevice:self];
		}
		
		[pendingPhotos removeLastObject];
		
		if ([pendingPhotos count] > 0)
			loadPhotos = [[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fetchNextPhoto:) userInfo:nil repeats:NO] retain];
	}
}

- (void) fetchPhotoList
{
	NSString * command = [NSString stringWithFormat:@"shion:fetchPhotoListForCamera(\"%@\")", [self identifier], nil];
	
	[[XMPPManager sharedManager] sendCommand:command forDevice:self];
}

- (void) setPhotoList:(NSArray *) list
{
	if (pendingPhotos == nil)
		pendingPhotos = [[NSMutableArray alloc] initWithArray:list];

	for (NSString * photoId in list)
	{
		if (![pendingPhotos containsObject:photoId])
			[pendingPhotos addObject:photoId];
	}
	
	while ([pendingPhotos count] > 50)
		[pendingPhotos removeObjectAtIndex:0];

	if (loadPhotos == nil && [pendingPhotos count] > 0)
		loadPhotos = [[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fetchNextPhoto:) userInfo:nil repeats:NO] retain];
}

- (void) addPhoto:(NSDictionary *) dict
{
	[self willChangeValueForKey:@"photos"];
	[self willChangeValueForKey:@"description"];

	NSMutableDictionary * photoDict = [NSMutableDictionary dictionaryWithDictionary:dict];

	NSString * imagePath = [self photoPath];
	NSString * imageFilePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [photoDict valueForKey:@"id"]]];
	
	NSData * imageData = [photoDict valueForKey:@"data"];
	
	[imageData writeToFile:imageFilePath atomically:YES];

	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd kk:mm:ss z"];

	[photoDict setValue:[formatter dateFromString:[photoDict valueForKey:@"date"]] forKey:@"date"];
	
	[formatter release];
	[photoDict removeObjectForKey:@"data"];
	[photoDict setValue:[[NSURL fileURLWithPath:imageFilePath] description] forKey:@"url"];
	
	[photos addObject:photoDict];

	NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	[photos sortUsingDescriptors:[NSArray arrayWithObject:sort]];
	[sort release];
	
	NSData * archivedData = [NSKeyedArchiver archivedDataWithRootObject:photoDict];

	NSString * imageInfoPath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", [photoDict valueForKey:@"id"]]];
	[archivedData writeToFile:imageInfoPath atomically:YES];
	
	if (loadPhotos == nil)
		loadPhotos = [[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fetchNextPhoto:) userInfo:nil repeats:NO] retain];
	
	[self willChangeValueForKey:@"description"];
	[self didChangeValueForKey:@"photos"];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:self];
}

- (NSArray *) photos
{
	if ([photos count] < 1)
	{
		NSFileManager * manager = [NSFileManager defaultManager];
		
		NSString * dataDir = [self photoPath];
		
		NSEnumerator * iter = [manager enumeratorAtPath:dataDir];
		NSString * file = nil;
		while (file = [iter nextObject])
		{
			if ([[file pathExtension] isEqual:@"data"])
			{
				NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithFile:[dataDir stringByAppendingPathComponent:file]];

				[photos addObject:dict];

				[[NSNotificationCenter defaultCenter] postNotificationName:@"model_updated" object:self];
			}
		}
		
		NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
		[photos sortUsingDescriptors:[NSArray arrayWithObject:sort]];
		[sort release];
		
		[self fetchPhotoList];
	}
	
	for (NSMutableDictionary * photo in photos)
	{
		if (![[photo allKeys] containsObject:@"uiimage"])
		{
			UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[photo valueForKey:@"url"]]]];
		
			CGFloat height = 44; // TV height
			CGFloat imgHeight = image.size.height;
		
			CGFloat ratio = height / imgHeight;
		
			CGSize newSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
		
			UIGraphicsBeginImageContext(newSize);
			[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
			UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();    
			UIGraphicsEndImageContext();
		
			[photo setValue:newImage forKey:@"uiimage"];
		}
	}
	
	return photos;
}

- (void) captureImage
{
	NSString * command = [NSString stringWithFormat:@"shion:captureImageWithCamera(\"%@\")", [self identifier], nil];
	
	[[XMPPManager sharedManager] sendCommand:command forDevice:self];
}

- (void) clearPhotos
{
	[self photos];
	
	if ([photos count] > 0)
	{
		NSFileManager * manager = [NSFileManager defaultManager];
		
		NSString * dataDir = [self photoPath];
		
		[manager removeItemAtPath:dataDir error:NULL];
		
		[photos removeAllObjects];
	}
}

@end
