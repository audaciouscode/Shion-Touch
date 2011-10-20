//
//  CameraPhoto.h
//  Shion Touch
//
//  Created by Chris Karr on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20.h"

@interface CameraPhoto : NSObject <TTPhoto, TTPhotoSource>
{
	CGSize size;
	NSString * url;
}

@property(retain) NSString * url;

- (id)initWithURLString:(NSString *) urlString;

@end
