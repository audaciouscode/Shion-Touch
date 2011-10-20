//
//  DeviceWidgetView.h
//  Shion Touch
//
//  Created by Chris Karr on 3/3/10.
//  Copyright 2010 CASIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface DeviceWidgetView : UIView 
{
	Device * device;
}

@property(assign) Device * device;

- (void) refresh;

@end
