//
//  CameraPhotoSource.h
//  Shion Touch
//
//  Created by Chris Karr on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20.h"

#import "Camera.h"

@interface CameraPhotoSource : TTURLRequestModel <TTPhotoSource> 
{
	NSString * title;
	Camera * camera;
	NSMutableArray * cachedPhotos;
}

- (id) initWithCamera:(Camera *) camera;

@end
