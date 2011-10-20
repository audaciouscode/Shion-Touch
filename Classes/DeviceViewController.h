//
//  DeviceViewController.h
//  Shion Touch
//
//  Created by Chris Karr on 2/28/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "DeviceControllerView.h"
#import "DeviceWidgetView.h"

@interface DeviceViewController : UIViewController 
{
	Device * device;
	
	IBOutlet DeviceWidgetView * widget;
	IBOutlet DeviceControllerView * controls;
	
	BOOL controlsVisible;
}

@property(assign) BOOL controlsVisible;

@property(retain) Device * device;

+ (UIViewController *) controllerForDevice:(Device *) device;
- (void) refresh:(NSNotification *) theNote;

@end
