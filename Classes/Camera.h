//
//  Camera.h
//  Shion Touch
//
//  Created by Chris Karr on 9/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface Camera : Device 
{
	NSMutableArray * photos;
	NSMutableArray * pendingPhotos;
	NSTimer * loadPhotos;
}

- (NSArray *) photos;
- (void) setPhotoList:(NSArray *) list;
- (void) addPhoto:(NSDictionary *) dict;
- (void) captureImage;

- (void) clearPhotos;

@end
