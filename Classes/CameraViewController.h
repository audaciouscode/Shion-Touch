//
//  CameraViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 9/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20.h"

#import "Camera.h"

@interface CameraViewController : TTPhotoViewController
{
	Camera * device;

	UIBarButtonItem * captureButton;
	UIBarButtonItem * allButton;
}

@property(retain) Camera * device;

@end
